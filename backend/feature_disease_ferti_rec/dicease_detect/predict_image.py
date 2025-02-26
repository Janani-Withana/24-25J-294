import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing import image
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder
import os

# Load the trained model
model = tf.keras.models.load_model('final_model.h5')  # Load the trained model

# Load label encoder (assuming it's saved as 'label_encoder_classes.npy')
label_encoder = LabelEncoder()  # Initialize the LabelEncoder
label_encoder.classes_ = np.load('label_encoder_classes.npy', allow_pickle=True)  # Load saved class names

# Debug: Print the loaded class labels to verify
print("Loaded class labels:", label_encoder.classes_)

def load_and_preprocess_image(img_path):
    """Load and preprocess the image."""
    img = image.load_img(img_path, target_size=(224, 224))  # Load and resize the image
    img_array = image.img_to_array(img) / 255.0  # Convert to array and normalize pixel values
    img_array = np.expand_dims(img_array, axis=0)  # Add batch dimension
    return img_array

def predict_image(img_path):
    """Predict the class of the image."""
    img_array = load_and_preprocess_image(img_path)  # Preprocess the image
    prediction = model.predict(img_array)  # Predict the class of the image
    predicted_class_idx = np.argmax(prediction)  # Get the index of the highest probability

    # Use the manually defined class names
    class_names = [
        "bacterial_leaf_blight", "bacterial_leaf_streak", "bacterial_panicle_blight",
        "blast", "brown_spot", "dead_heart", "downy_mildew", "hispa",
        "normal", "tungro"
    ]
    predicted_class = class_names[predicted_class_idx]  # Get the predicted class name
    return predicted_class, prediction[0][predicted_class_idx]  # Return the predicted class and its confidence

def display_image(img_path):
    """Display the uploaded image."""
    img = image.load_img(img_path)  # Load the image
    plt.imshow(img)  # Display the image
    plt.axis('off')  # Hide axes
    plt.show()

if __name__ == "__main__":
    # Image path to check
    img_path = 'AAAAAAAAAAA.jpg'  # Replace with the actual image path you want to check

    if os.path.exists(img_path):  # Check if the image exists
        print(f"Uploading image: {img_path}")  # Print message about the image being uploaded
        display_image(img_path)  # Display the image

        # Predict the class of the image
        predicted_class, confidence = predict_image(img_path)
        print(f"Predicted class (disease): {predicted_class}")  # Print predicted class
        print(f"Prediction confidence: {confidence * 100:.2f}%")  # Print prediction confidence
    else:
        print("Image file not found. Please check the path.")  # If image is not found, print error
