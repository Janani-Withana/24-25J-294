import firebase_admin
from firebase_admin import credentials, firestore
import pandas as pd

# Initialize Firebase Admin
cred = credentials.Certificate(r"E:\Research Project\Main_Repo\24-25J-294\backend\feature_disease_ferti_rec\ferti_rec\nodemcu-592b5-firebase-adminsdk-h1yk4-de5f503e85.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Read CSV File
csv_file = "rice_varieties.csv"  # Replace with your CSV file path
df = pd.read_csv(csv_file)

# Upload Data to Firestore
collection_name = "rice_varieties"  # Replace with your Firestore collection

for index, row in df.iterrows():
    doc_data = {
        "age_group": row["age_group"],  # Ensure column names match your CSV
        "rice_variety": row["rice_variety"]
    }
    db.collection(collection_name).add(doc_data)

print("Data successfully uploaded to Firebase Firestore!")