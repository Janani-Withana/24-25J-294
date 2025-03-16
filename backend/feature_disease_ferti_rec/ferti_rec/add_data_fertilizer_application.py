import firebase_admin
from firebase_admin import credentials, firestore
import pandas as pd

# Initialize Firebase Admin SDK with your credentials
cred = credentials.Certificate(r"E:\Research Project\Main_Repo\24-25J-294\backend\feature_disease_ferti_rec\ferti_rec\nodemcu-592b5-firebase-adminsdk-h1yk4-de5f503e85.json")
firebase_admin.initialize_app(cred)

# Initialize Firestore
db = firestore.client()

# Path to your CSV file
csv_file = r'E:\Research Project\Main_Repo\24-25J-294\backend\feature_disease_ferti_rec\ferti_rec\fertilizer_application.csv'

# Read CSV file using pandas
df = pd.read_csv(csv_file)

# Iterate through each row in the DataFrame
for _, row in df.iterrows():
    # Create a document reference (you can choose a suitable collection name here)
    document_ref = db.collection('fertilizer_application_quantity').add({
        'age_group': row['age_group'],  # Updated column name
        'time_to_apply': row['time_to_apply'],  # Updated column name
        'urea_kg_per_ha': row['urea_kg_per_ha'],  # Updated column name
        'tsp_kg_per_ha': row['tsp_kg_per_ha'],  # Updated column name
        'mop_kg_per_ha': row['mop_kg_per_ha']  # Updated column name
    })

print("Data has been successfully uploaded to Firebase.")