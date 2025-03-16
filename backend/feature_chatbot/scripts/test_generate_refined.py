import os
import pandas as pd
import numpy as np
import faiss
from sentence_transformers import SentenceTransformer
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# -----------------------------
# Retrieve Answer Using Hugging Face Model
# -----------------------------
def retrieve_answer(
    user_query: str,
    model_repo: str,
    df: pd.DataFrame,
    faiss_index_path: str = "data/faiss_index.bin",
    threshold: float = 0.8
):
    # Load fine-tuned embedding model from Hugging Face
    embedding_model = SentenceTransformer(model_repo)

    # Load FAISS index
    index = faiss.read_index(faiss_index_path)

    # Encode user query
    query_embedding = embedding_model.encode([user_query], normalize_embeddings=True)
    query_embedding = np.array(query_embedding, dtype=np.float32)

    # Perform FAISS search (top K=1)
    distances, best_match_idx = index.search(query_embedding, k=1)

    # Check if the similarity is above threshold
    if distances[0][0] >= threshold:
        best_idx = best_match_idx[0][0]
        best_question = df.iloc[best_idx]["Question"]
        best_answer = df.iloc[best_idx]["Answer"]
        return best_question, best_answer
    else:
        return None, None


# -----------------------------
# Optional: Gemini API to refine the answer
# -----------------------------
try:
    from gemini_api import configure_gemini, call_gemini_api
except ImportError:
    configure_gemini = None
    call_gemini_api = None


def generate_refined_answer(user_query: str, retrieved_answer: str) -> str:
    gemini_model = None
    GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY")

    if GEMINI_API_KEY and configure_gemini:
        gemini_model = configure_gemini(GEMINI_API_KEY)

    if gemini_model and call_gemini_api:
        prompt = (
            f"භාවිතා කළ යුතු පිළිතුර: {retrieved_answer}\n"
            "කරුණාකර මෙම පිළිතුර වැඩිදියුණු කරන්න."
        ) if retrieved_answer else (
            f"භාවිතා කළ යුතු පිළිතුරක් නොමැත.\n"
            f"කරුණාකර මෙම ප්‍රශ්නයට විස්තරාත්මක පිළිතුරක් ලබාදෙන්න:\n{user_query}"
        )
        return call_gemini_api(gemini_model, prompt)

    return retrieved_answer or "No suitable answer found."


# -----------------------------
# Example Usage
# -----------------------------
if __name__ == "__main__":
    # Define paths and Hugging Face model repo
    QA_CSV_PATH = "data/sinhala_farming_data.csv"
    FAISS_INDEX_PATH = "data/faiss_index.bin"
    MODEL_REPO = "Janani-Withana/sinhala-farming-qa-model"

    # Load questions and answers
    df = pd.read_csv(QA_CSV_PATH)

    # Example query
    user_query = "අක්කරයකට යෙදිය යුතු පොහොර ප්‍රමාණය කුමක්ද?"

    # Retrieve the answer from the fine-tuned Hugging Face model
    question, answer = retrieve_answer(
        user_query=user_query,
        model_repo=MODEL_REPO,
        df=df,
        faiss_index_path=FAISS_INDEX_PATH,
        threshold=0.8  # Adjust based on experimentation
    )

    if answer:
        refined_answer = generate_refined_answer(user_query, answer)
        print("Retrieved Question:", question)
        print("Answer:", refined_answer)
    else:
        refined_answer = generate_refined_answer(user_query, None)
        print("Answer:", refined_answer)
