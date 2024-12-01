import os
import firebase_admin
from firebase_admin import credentials, storage
from PIL import Image
import io
from datetime import datetime
import time

# Initialize Firebase with correct credentials
cred = credentials.Certificate('E:/Research Project/Main_Repo/24-25J-294/backend/feature_disease_ferti_rec/combine_images/firebase_credentials.json')  # Update with your Firebase credentials file path
firebase_admin.initialize_app(cred, {
    'storageBucket': 'uee-we-53.appspot.com'  # Corrected bucket name
})

# Firebase storage bucket
bucket = storage.bucket()

# Firebase folder where the images are uploaded
firebase_folder = 'uploaded_images/'  # Replace with your Firebase folder path
output_dir = 'E:/Research Project/Main_Repo/24-25J-294/backend/feature_disease_ferti_rec/combine_images/output'  # Local output folder (optional if you want to save locally)

# Ensure the output directory exists (optional)
os.makedirs(output_dir, exist_ok=True)

def get_latest_images_from_firebase():
    """Fetches the latest two images from Firebase"""
    blobs = bucket.list_blobs(prefix=firebase_folder)
    # Filter to only get images (e.g., PNG/JPG files)
    image_blobs = [blob for blob in blobs if blob.name.lower().endswith(('png', 'jpg', 'jpeg'))]

    # Sort blobs by the last modified time (most recent first)
    image_blobs.sort(key=lambda x: x.updated, reverse=True)

    # Get the latest two images
    if len(image_blobs) >= 2:
        image1_blob = image_blobs[0]
        image2_blob = image_blobs[1]
        return image1_blob, image2_blob
    else:
        raise Exception("Not enough images found in Firebase")

def stitch_images(image1_blob, image2_blob):
    """Stitches two images from Firebase into one"""
    # Download the images from Firebase into memory as bytes
    image1_bytes = image1_blob.download_as_bytes()
    image2_bytes = image2_blob.download_as_bytes()

    # Open the images using PIL from bytes
    image1 = Image.open(io.BytesIO(image1_bytes))
    image2 = Image.open(io.BytesIO(image2_bytes))

    # Get the dimensions of both images
    width1, height1 = image1.size
    width2, height2 = image2.size

    # Resize images to the same height (optional but recommended)
    new_height = min(height1, height2)
    image1 = image1.resize((int(width1 * new_height / height1), new_height))
    image2 = image2.resize((int(width2 * new_height / height2), new_height))

    # Create a new image with a combined width
    combined_width = image1.width + image2.width
    combined_image = Image.new('RGB', (combined_width, new_height))

    # Paste the images side by side
    combined_image.paste(image1, (0, 0))
    combined_image.paste(image2, (image1.width, 0))

    # Generate a timestamp for the filename
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')

    # Save the combined image locally (optional)
    output_filename = f"combined_image_{timestamp}.jpg"
    output_path = os.path.join(output_dir, output_filename)
    combined_image.save(output_path)

    # Return the combined image and the Firebase output path
    return combined_image, output_filename

def upload_to_firebase(local_image_path, firebase_output_path):
    """Uploads the stitched image back to Firebase"""
    blob = bucket.blob(firebase_output_path)
    blob.upload_from_filename(local_image_path)
    print(f"Uploaded the stitched image to Firebase at: {firebase_output_path}")

def process_images_every_hour():
    """Process images every hour by stitching and uploading back to Firebase"""
    while True:
        # Get the latest two images from Firebase
        try:
            image1_blob, image2_blob = get_latest_images_from_firebase()

            # Stitch the images
            stitched_image, output_filename = stitch_images(image1_blob, image2_blob)

            # Upload the stitched image back to Firebase
            firebase_output_path = f'{firebase_folder}{output_filename}'
            upload_to_firebase(os.path.join(output_dir, output_filename), firebase_output_path)

        except Exception as e:
            print(f"Error: {e}")

        # Wait for 1 hour before processing the next batch of images
        print("Waiting for 1 hour before processing new images...")
        time.sleep(3600)  # Sleep for 1 hour (3600 seconds)

if __name__ == "__main__":
    process_images_every_hour()
