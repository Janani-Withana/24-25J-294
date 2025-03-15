import tensorflow as tf
import matplotlib.pyplot as plt

# Load trained model
model = tf.keras.models.load_model("paddy_disease_classifier.h5")

# Plot training history
plt.plot(history.history['accuracy'], label='Train Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
plt.legend()
plt.xlabel("Epochs")
plt.ylabel("Accuracy")
plt.title("Training and Validation Accuracy")
plt.show()
