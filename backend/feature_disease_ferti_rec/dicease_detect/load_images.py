import os
import cv2
import pandas as pd
import numpy as np

# Paths to dataset
folder_path = "train_images"  # Path to the image folder
csv_path = "train.csv"  # Path to the CSV file containing image information

# Load the CSV file
df = pd.read_csv(csv_path)  # Load CSV data into pandas DataFrame

# Image parameters
IMAGE_SIZE = (224, 224)  # Target image size for resizing

# Initialize lists for images and labels
images = []  # List to hold image data
labels = []  # List to hold label data

# Loop over each row in the CSV
for _, row in df.iterrows():  # Iterate over each row of the DataFrame
    image_id = row['image_id']  # Extract image ID
    label = row['label']  # Extract label
    image_path = os.path.join(folder_path, label, image_id)  # Construct the path to the image
    if os.path.exists(image_path):  # Check if the image exists
        img = cv2.imread(image_path)  # Read the image using OpenCV
        img = cv2.resize(img, IMAGE_SIZE)  # Resize the image to the target size
        images.append(img)  # Add the image to the images list
        labels.append(label)  # Add the label to the labels list

# Convert lists to numpy arrays
images = np.array(images)  # Convert images list to numpy array
labels = np.array(labels)  # Convert labels list to numpy array

# Save the images and labels to disk
np.save("images.npy", images)  # Save image data
np.save("labels.npy", labels)  # Save label data

# Print the number of images and labels loaded
print(f"Loaded {len(images)} images and {len(labels)} labels. Data saved to disk.")
