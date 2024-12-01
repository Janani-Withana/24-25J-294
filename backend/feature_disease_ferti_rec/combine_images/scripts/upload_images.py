import firebase_admin
from firebase_admin import credentials, storage
import os
import time
from random import choice

# Firebase initialization
cred = credentials.Certificate(r'E:\Research Project\Main_Repo\24-25J-294\backend\feature_disease_ferti_rec\combine_images\firebase_credentials.json')  # Ensure correct path
firebase_admin.initialize_app(cred, {
    'storageBucket': 'uee-we-53.appspot.com'  # Corrected bucket name
})

# Firebase storage bucket
bucket = storage.bucket()

# Local folder containing random images on your laptop
local_folder = r'E:\Research Project\Main_Repo\24-25J-294\backend\feature_disease_ferti_rec\dicease_detect\train_images\bacterial_leaf_blight'  # Ensure correct path

# Firebase folder where the images will be uploaded
firebase_folder = 'uploaded_images/'

def upload_image_to_firebase(local_image_path, firebase_path):
    # Upload the image to Firebase Storage
    blob = bucket.blob(firebase_path)
    blob.upload_from_filename(local_image_path)
    print(f"Uploaded {local_image_path} to Firebase as {firebase_path}")

def get_random_image_from_folder(folder_path):
    # Get a random image file from the folder
    image_files = [f for f in os.listdir(folder_path) if f.lower().endswith(('png', 'jpg', 'jpeg'))]
    if image_files:
        return os.path.join(folder_path, choice(image_files))
    else:
        print("No image files found in the folder.")
        return None

def upload_images_every_hour():
    while True:
        # Get two random images from the local folder
        image1 = get_random_image_from_folder(local_folder)
        image2 = get_random_image_from_folder(local_folder)

        if image1 and image2:
            # Generate unique names for the images to upload to Firebase
            timestamp = time.strftime('%Y%m%d_%H%M%S')
            firebase_image1_path = f'{firebase_folder}image1_{timestamp}.jpg'
            firebase_image2_path = f'{firebase_folder}image2_{timestamp}.jpg'

            # Upload both images to Firebase
            upload_image_to_firebase(image1, firebase_image1_path)
            upload_image_to_firebase(image2, firebase_image2_path)

        # Wait for 1 hour before uploading new images
        print("Waiting for 1 hour before the next upload.")
        time.sleep(3600)  # Sleep for 1 hour (3600 seconds)

if __name__ == "__main__":
    upload_images_every_hour()
