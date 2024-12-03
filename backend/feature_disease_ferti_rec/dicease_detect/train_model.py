import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
from sklearn.metrics import classification_report
from sklearn.preprocessing import LabelEncoder

# Load preprocessed data
X_train = np.load("X_train.npy")  # Load training data
X_val = np.load("X_val.npy")  # Load validation data
X_test = np.load("X_test.npy")  # Load test data
y_train = np.load("y_train.npy")  # Load training labels
y_val = np.load("y_val.npy")  # Load validation labels
y_test = np.load("y_test.npy")  # Load test labels

# Initialize and fit LabelEncoder
label_encoder = LabelEncoder()  # Initialize LabelEncoder to convert labels to integers
y_train_encoded = label_encoder.fit_transform(y_train)  # Encode training labels
y_val_encoded = label_encoder.transform(y_val)  # Encode validation labels
y_test_encoded = label_encoder.transform(y_test)  # Encode test labels

# Save label encoder classes to a file for later use
np.save('label_encoder_classes.npy', label_encoder.classes_)  # Save the classes to a file

# Define the CNN model
model = Sequential([
    Conv2D(32, (3, 3), activation='relu', input_shape=(224, 224, 3)),  # Convolution layer with 32 filters
    MaxPooling2D((2, 2)),  # Max pooling layer
    Conv2D(64, (3, 3), activation='relu'),  # Another convolution layer with 64 filters
    MaxPooling2D((2, 2)),  # Max pooling layer
    Conv2D(128, (3, 3), activation='relu'),  # Another convolution layer with 128 filters
    MaxPooling2D((2, 2)),  # Max pooling layer
    Flatten(),  # Flatten the 2D output to 1D
    Dense(128, activation='relu'),  # Dense fully connected layer with 128 neurons
    Dropout(0.5),  # Dropout layer to prevent overfitting
    Dense(64, activation='relu'),  # Dense fully connected layer with 64 neurons
    Dense(10, activation='softmax')  # Output layer with 10 neurons (one for each disease class)
])

# Compile the model
model.compile(optimizer='adam',  # Use Adam optimizer
              loss='sparse_categorical_crossentropy',  # Sparse categorical cross-entropy loss for multi-class classification
              metrics=['accuracy'])  # Track accuracy during training

# Set up callbacks
early_stopping = EarlyStopping(monitor='val_loss', patience=5, restore_best_weights=True)  # Early stopping to prevent overfitting
model_checkpoint = ModelCheckpoint("best_model.keras", save_best_only=True, monitor='val_loss')  # Save best model

# Train the model
history = model.fit(
    X_train, y_train_encoded,  # Training data and labels
    validation_data=(X_val, y_val_encoded),  # Validation data and labels
    epochs=20,  # Train for 20 epochs
    batch_size=32,  # Use a batch size of 32
    callbacks=[early_stopping, model_checkpoint]  # Use early stopping and model checkpoint callbacks
)

# Evaluate the model
test_loss, test_accuracy = model.evaluate(X_test, y_test_encoded)  # Evaluate model on test data
print(f"Test Accuracy: {test_accuracy:.2f}")  # Print the test accuracy

# Classification report
y_pred = np.argmax(model.predict(X_test), axis=-1)  # Get predicted labels
print("\nClassification Report:")
print(classification_report(y_test_encoded, y_pred))  # Print classification report

# Save the final model
model.save("final_model.h5")  # Save the trained model
print("Model training completed and saved.")
