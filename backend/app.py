# app.py

from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
import pandas as pd
import faiss
import numpy as np
from sentence_transformers import SentenceTransformer

from feature_chatbot.scripts import retrieve_answer, generate_refined_answer


app = Flask(__name__)
CORS(app)

# ------------------------------------------------------
# Load chatbot components (fine-tuned model, CSV, FAISS index)
# ------------------------------------------------------
MODEL_PATH = "Janani-Withana/sinhala-farming-qa-model"
#MODEL_PATH = "feature_chatbot/models/fine_tuned_multilingual_model"
FAISS_INDEX_PATH = "feature_chatbot/data/faiss_index.bin"
QA_CSV_PATH = "feature_chatbot/data/sinhala_farming_data.csv"

try:
    # Load model
    embedding_model = SentenceTransformer(MODEL_PATH)
    # Load CSV
    df = pd.read_csv(QA_CSV_PATH)
    # Load FAISS index
    index = faiss.read_index(FAISS_INDEX_PATH)
    print("Model, data, and FAISS index loaded successfully.")
except Exception as e:
    print(f"Error loading model or data: {e}")
    embedding_model = None


@app.route("/api/chat", methods=["POST"])
def chat():
    if embedding_model is None:
        return jsonify({"error": "Model not loaded."}), 500

    try:
        data = request.json
        user_query = data.get("message", "")

        if not user_query:
            return jsonify({'error': 'No question provided'}), 400

        # Retrieve best match from FAISS
        best_question, best_answer = retrieve_answer(
            user_query=user_query,
            embedding_model=embedding_model,
            df=df,
            faiss_index_path=FAISS_INDEX_PATH,
            threshold = 0.8
        )

        print(best_question,best_answer)

        if best_answer:
            final_answer = generate_refined_answer(user_query, best_answer)
            return jsonify({"reply": final_answer})
        else:
            return jsonify({"reply": "සුදුසු පිළිතුරක් නොමැත ⚠️"})

        # (Optional) call generate_refined_answer to process with Gemini
        # if best_answer:
        #     final_response = generate_refined_answer(user_query, best_answer)
        #     return jsonify({"reply": final_response})
        # else:
        #     return jsonify({"reply": "No suitable answer found."})
        

    except Exception as e:
        logging.error(f"Error occurred: {e}")
        return jsonify({"error": "Internal server error."}), 500


if __name__ == "__main__":
    # Run Flask in debug mode for development
    app.run(host='0.0.0.0', port=5000, debug=True)
