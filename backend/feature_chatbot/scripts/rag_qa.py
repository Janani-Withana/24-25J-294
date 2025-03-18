import os
import pandas as pd
import numpy as np
import faiss
import torch
import json
from sentence_transformers import (
    SentenceTransformer,
    InputExample,
    losses,
    models,
    util
)
from torch.utils.data import DataLoader
from dotenv import load_dotenv
load_dotenv()

try:
    from gemini_api import configure_gemini, call_gemini_api
except ImportError:
    configure_gemini = None
    call_gemini_api = None

# -----------------------------
# 1) Fine-Tuning Function
# -----------------------------
def fine_tune_embeddings(
    csv_path: str,
    base_model_name: str = "paraphrase-multilingual-MiniLM-L12-v2",
    output_dir: str = "fine_tuned_multilingual_model",
    epochs: int = 5,
    batch_size: int = 32,
    warmup_steps: int = 100,
    log_path: str = "training_logs.json"
):
    print(f"Loading base model: {base_model_name}")
    model = SentenceTransformer(base_model_name)

    print(f"Reading Q&A CSV from: {csv_path}")
    df = pd.read_csv(csv_path)

    train_examples = []
    for _, row in df.iterrows():
        question = str(row["Question"])
        answer = str(row["Answer"])
        
        # Positive example
        train_examples.append(InputExample(texts=[question, answer], label=1.0))


    train_dataloader = DataLoader(train_examples, shuffle=True, batch_size=batch_size)
    train_loss = losses.MultipleNegativesRankingLoss(model)

    print("Starting fine-tuning...")

    # Store training loss per epoch
    training_log = []

    for epoch in range(epochs):
        loss = model.fit(
            train_objectives=[(train_dataloader, train_loss)],
            epochs=1, 
            warmup_steps=warmup_steps,
            show_progress_bar=True,
        )
        
        # Log loss for this epoch
        training_log.append({"epoch": epoch + 1, "loss": loss})
        
        # Save logs to JSON
        with open(log_path, "w") as log_file:
            json.dump(training_log, log_file)


    model.save(output_dir)
    print(f"Fine-tuning complete. Model saved to: {output_dir}")

# -----------------------------
# 2) Build FAISS Index
# -----------------------------
def build_faiss_index(csv_path: str, model_path: str, faiss_index_path: str = "faiss_index.bin"):
    print(f"Loading fine-tuned model from: {model_path}")
    embedding_model = SentenceTransformer(model_path)

    df = pd.read_csv(csv_path)
    questions = df["Question"].astype(str).tolist()

    print("Computing embeddings for all questions...")
    question_embeddings = embedding_model.encode(questions, normalize_embeddings=True)

    dimension = question_embeddings.shape[1]
    print(f"Embedding dimension: {dimension}")

    index = faiss.IndexFlatIP(dimension)  # Cosine similarity (use with normalized vectors)
    index.add(np.array(question_embeddings, dtype=np.float32))

    # Write index to disk
    faiss.write_index(index, faiss_index_path)
    print(f"FAISS index built and saved to: {faiss_index_path}")

    return df

# -----------------------------
# 3) Retrieve Best Match
# -----------------------------
def retrieve_answer(
    user_query: str,
    embedding_model: SentenceTransformer,
    df: pd.DataFrame,
    faiss_index_path: str = "faiss_index.bin",
    threshold: float = 0.9
):
    """
    Retrieve the most relevant answer using FAISS similarity search.
    Returns (best_question, best_answer) or (None, None) if no good match.
    """
    # Load FAISS index
    index = faiss.read_index(faiss_index_path)

    # Encode query
    query_embedding = embedding_model.encode([user_query], normalize_embeddings=True)
    query_embedding = np.array(query_embedding, dtype=np.float32)

    # Search top K=1
    distances, best_match_idx = index.search(query_embedding, k=1)
    distance_score = distances[0][0]

    print(f"Distance score: {distance_score:.4f}")

    # If the best match score is below threshold, treat it as no relevant answer
    if distance_score >= threshold:
        best_idx = best_match_idx[0][0]
        best_question = df.iloc[best_idx]["Question"]
        best_answer = df.iloc[best_idx]["Answer"]
        return best_question, best_answer
    else:
        return None, None

# -----------------------------
# 4) Optionally Refine with Gemini (If you have Gemini available)
# -----------------------------
def generate_refined_answer(
    user_query: str,
    retrieved_answer: str,
) -> str:
    
    gemini_model = None
    GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY")
    if GEMINI_API_KEY:
        if configure_gemini is not None:
            gemini_model = configure_gemini(GEMINI_API_KEY)
        else:
            print("configure_gemini is None, cannot configure Gemini.")
    else:
        print("GEMINI_API_KEY not set.")

    if gemini_model is not None and call_gemini_api is not None:
        if retrieved_answer:
            prompt = (
                f"භාවිතා කළ යුතු පිළිතුර: {retrieved_answer}\n"
                "කරුණාකර මෙම පිළිතුර වැඩිදියුණු කරන්න."
            )
        else:
            prompt = (
                "භාවිතා කළ යුතු පිළිතුරක් නොමැත.\n"
                f"කරුණාකර මෙම ප්‍රශ්නයට විස්තරාත්මක පිළිතුරක් ලබාදෙන්න:\n{user_query}"
            )
        return call_gemini_api(gemini_model, prompt)
    else:
        # No Gemini -> just return the retrieved answer or fallback
        return retrieved_answer if retrieved_answer else "No suitable answer found."


# -----------------------------
# 5) Optional: Run once to fine-tune & build index
# -----------------------------
if __name__ == "__main__":
    QA_CSV_PATH = "data/sinhala_farming_data.csv"
    BASE_MODEL = "paraphrase-multilingual-MiniLM-L12-v2"
    FINETUNED_MODEL_DIR = "models/fine_tuned_multilingual_model"
    FAISS_INDEX_PATH = "data/faiss_index.bin"

    # A) Fine-tune
    fine_tune_embeddings(
        csv_path=QA_CSV_PATH,
        base_model_name=BASE_MODEL,
        output_dir=FINETUNED_MODEL_DIR,
        epochs=5,
        batch_size=32,
        warmup_steps=100
    )

    # B) Build index
    df = build_faiss_index(
        csv_path=QA_CSV_PATH,
        model_path=FINETUNED_MODEL_DIR,
        faiss_index_path=FAISS_INDEX_PATH
    )

    print("Done.")
