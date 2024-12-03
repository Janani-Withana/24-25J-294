from flask import Flask, request, jsonify
from flask_cors import CORS
import torch
from nltk.tokenize import word_tokenize
import torch.nn as nn
from feature_chatbot.scripts.model_training import Seq2Seq, load_chatbot_model, generate_chatbot_response
import logging

# Flask app
app = Flask(__name__)
CORS(app)

# Load chatbot model and vocabularies
question_vocab = torch.load('/feature_chatbot/models/vocab_question.pth', weights_only=False)
answer_vocab = torch.load('/feature_chatbot/models/vocab_answer.pth', weights_only=False)
chatbot_model = load_chatbot_model(question_vocab, answer_vocab)

# chatbot route
@app.route("/api/chat", methods=['POST'])
def chat():
    try:
        data = request.json
        question = data.get("message", "")

        if not question:
           return jsonify({'error': 'No question provided'}), 400
    
        response = generate_chatbot_response(chatbot_model, question, question_vocab, answer_vocab)
        return jsonify({"reply": response})
   
    except Exception as e:
        logging.error(f"Error occurred: {e}")
        return jsonify({"error": "Internal server error."}), 500

if __name__ == '__main__':
    app.run(debug=True)
