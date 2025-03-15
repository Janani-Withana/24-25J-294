import torch
import torchvision.transforms as transforms
import torch.nn as nn
from torchvision import models
from PIL import Image
import os

# ✅ Check for GPU
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f"✅ Using device: {device}")

# ✅ Define image transformations (resize & normalize)
IMG_SIZE = (480, 640)  # Ensure the same size as training
transform = transforms.Compose([
    transforms.Resize(IMG_SIZE),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

# ✅ Load the trained model
model = models.mobilenet_v2(pretrained=False)
num_classes = 11  # Update if the number of disease classes changes
model.classifier[1] = nn.Linear(model.last_channel, num_classes)

# Load the saved model weights
model.load_state_dict(torch.load("paddy_disease_classifier.pth", map_location=device))
model = model.to(device)
model.eval()  # Set model to evaluation mode
print("✅ Model loaded successfully!")

# ✅ Define class names (Must match training labels)
class_names = [
    "bacterial_leaf_blight", "bacterial_leaf_streak", "bacterial_panicle_blight",
    "blast", "brown_spot", "dead_heart", "downy_mildew",
    "hispa", "nitrogen_deficiency", "normal", "tungro"
]

# ✅ Function to make a prediction
def predict_image(image_path):
    image = Image.open(image_path).convert("RGB")  # Open image
    image = transform(image).unsqueeze(0).to(device)  # Apply transformations & add batch dimension

    with torch.no_grad():  # Disable gradient calculations
        output = model(image)
        _, predicted = torch.max(output, 1)  # Get the predicted class index
        confidence = torch.softmax(output, dim=1)[0][predicted].item()  # Get confidence score

    predicted_class = class_names[predicted.item()]  # Convert index to class name
    print(f"🟢 Predicted Disease: {predicted_class} (Confidence: {confidence:.2f})")

# ✅ Test on a single image
test_image_path = "test_images/sample.jpg"  # Replace with your test image
if os.path.exists(test_image_path):
    predict_image(test_image_path)
else:
    print(f"❌ Error: Image '{test_image_path}' not found!")
