import os
import pandas as pd

# Paths to your dataset
folder_path = "train_images"  # Folder where images are stored
csv_path = "train.csv"  # CSV file containing image IDs and labels

# Load the CSV file
df = pd.read_csv(csv_path)  # Read the CSV file into a pandas DataFrame

# Verify label folders
folder_labels = set(os.listdir(folder_path))  # Get set of folder names in the 'train_images' directory
csv_labels = set(df['label'])  # Get set of labels from the CSV file

# Check label matches
if csv_labels.issubset(folder_labels):  # Check if all CSV labels are present in the folder labels
    print("All labels in the CSV file match folder names.")  # If they match, print a success message
else:
    print("Mismatch found between labels in CSV and folder structure!")  # If there is a mismatch, print an error message
    # Print the labels in CSV but not in the folders and vice versa
    print("Labels in CSV but not in folders:", csv_labels - folder_labels)
    print("Labels in folders but not in CSV:", folder_labels - csv_labels)

# Verify images
missing_images = []  # List to store missing image IDs
for _, row in df.iterrows():  # Iterate over each row in the DataFrame
    image_id = row['image_id']  # Extract image ID from the row
    label = row['label']  # Extract the label from the row
    image_path = os.path.join(folder_path, label, image_id)  # Construct the full path to the image
    if not os.path.exists(image_path):  # Check if the image file does not exist
        missing_images.append(image_id)  # Add missing image ID to the list

# Report missing images
if missing_images:  # If any missing images are found
    print(f"Missing images found: {len(missing_images)}")  # Print the count of missing images
    print(missing_images)  # Print the list of missing image IDs
else:
    print("All images listed in the CSV file exist in the folders.")  # If no missing images, print success
