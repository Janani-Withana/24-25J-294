import os
import pandas as pd
import cv2

# Define dataset path
dataset_path = "train_images"

# Initialize a list to store image data
image_data = []
corrupt_images = 0  # Counter for corrupt images

# Loop through each disease folder
for disease in os.listdir(dataset_path):
    disease_path = os.path.join(dataset_path, disease)
    
    if os.path.isdir(disease_path):  # Ensure it's a directory
        for img_name in os.listdir(disease_path):
            img_path = os.path.join(disease_path, img_name)

            # Try loading the image to check if it's valid
            try:
                img = cv2.imread(img_path)
                if img is not None:
                    height, width, _ = img.shape
                    image_data.append([img_name, disease, img_path, height, width, "OK"])
                else:
                    print(f"🛑 Corrupt Image Found: {img_path} - Deleting...")
                    os.remove(img_path)  # DELETE corrupt image
                    corrupt_images += 1
            except Exception as e:
                print(f"⚠️ Error Processing {img_path}: {e} - Deleting...")
                os.remove(img_path)  # DELETE problematic image
                corrupt_images += 1

# Convert to DataFrame
df = pd.DataFrame(image_data, columns=["Image_Name", "Disease", "Path", "Height", "Width", "Status"])

# Save to CSV
df.to_csv("dataset_summary.csv", index=False)

print(f"✅ Dataset summary saved as dataset_summary.csv")
print(f"🗑️ Deleted {corrupt_images} corrupt images.")
