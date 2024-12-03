import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder

# Load pre-saved data
images = np.load("images.npy")  # Load image data from file
labels = np.load("labels.npy")  # Load labels from file

# Normalize image data
images = images / 255.0  # Scale pixel values to [0, 1] for neural network training

# Encode labels to integers
label_encoder = LabelEncoder()  # Create a LabelEncoder to convert labels to numeric values
labels_encoded = label_encoder.fit_transform(labels)  # Encode the labels into integers

# Split the dataset into train, validation, and test sets
X_train, X_temp, y_train, y_temp = train_test_split(images, labels_encoded, test_size=0.2, random_state=42)  # 80% training, 20% temp (validation + test)
X_val, X_test, y_val, y_test = train_test_split(X_temp, y_temp, test_size=0.5, random_state=42)  # Split temp data into 50% validation, 50% test

# Save the processed data
np.save("X_train.npy", X_train)  # Save the training images
np.save("X_val.npy", X_val)  # Save the validation images
np.save("X_test.npy", X_test)  # Save the test images
np.save("y_train.npy", y_train)  # Save the training labels
np.save("y_val.npy", y_val)  # Save the validation labels
np.save("y_test.npy", y_test)  # Save the test labels

# Output the shapes of the datasets
print(f"Training data: {X_train.shape}, Validation data: {X_val.shape}, Test data: {X_test.shape}")
print("Processed data saved as .npy files.")
