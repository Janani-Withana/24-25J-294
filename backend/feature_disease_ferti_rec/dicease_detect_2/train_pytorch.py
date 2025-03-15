import os
import torch
import torchvision
import torch.nn as nn
import torch.optim as optim
import torchvision.transforms as transforms
from torchvision import datasets, models
from torch.utils.data import DataLoader

import torch
print(torch.cuda.is_available())  # Should print True
print(torch.cuda.get_device_name(0))  # Should print your GPU model


# ✅ Check for GPU
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f"✅ Using device: {device}")

# ✅ Define Data Transforms (Resizing, Normalization, Augmentation)
IMG_SIZE = (224, 224)
BATCH_SIZE = 8

transform = transforms.Compose([
    transforms.Resize(IMG_SIZE),
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(20),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])  # ImageNet normalization
])

# ✅ Load Dataset
dataset_path = "train_images"

train_dataset = datasets.ImageFolder(root=dataset_path, transform=transform)
train_loader = DataLoader(train_dataset, batch_size=BATCH_SIZE, shuffle=True)

# ✅ Get Class Labels
class_names = train_dataset.classes
num_classes = len(class_names)
print(f"✅ Class Labels: {class_names}")

# ✅ Load Pre-trained Model (MobileNetV2)
model = models.mobilenet_v2(pretrained=True)

# Modify the final classification layer
model.classifier[1] = nn.Linear(model.last_channel, num_classes)

# Move model to GPU
model = model.to(device)

# ✅ Define Loss Function and Optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.0001)

# ✅ Train Model
EPOCHS = 20

for epoch in range(EPOCHS):
    model.train()
    running_loss = 0.0
    correct = 0
    total = 0

    for images, labels in train_loader:
        images, labels = images.to(device), labels.to(device)  # Move to GPU

        optimizer.zero_grad()  # Zero out gradients
        outputs = model(images)  # Forward pass
        loss = criterion(outputs, labels)  # Compute loss
        loss.backward()  # Backpropagation
        optimizer.step()  # Update weights

        running_loss += loss.item()
        _, predicted = torch.max(outputs, 1)  # Get class with max probability
        correct += (predicted == labels).sum().item()
        total += labels.size(0)

    epoch_loss = running_loss / len(train_loader)
    epoch_acc = correct / total

    print(f"Epoch [{epoch+1}/{EPOCHS}], Loss: {epoch_loss:.4f}, Accuracy: {epoch_acc:.4f}")

# ✅ Save Model
torch.save(model.state_dict(), "paddy_disease_classifier1.pth")
print("✅ Model saved successfully!")
