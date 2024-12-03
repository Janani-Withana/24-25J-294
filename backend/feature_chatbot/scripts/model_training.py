import pandas as pd
from sklearn.model_selection import train_test_split
import torch
from torch.utils.data import Dataset, DataLoader
import nltk
from nltk.tokenize import word_tokenize
from collections import Counter
import torch.nn.functional as F
import torch.nn as nn

nltk.download('punkt')
nltk.download('punkt_tab')

# Load the dataset
data = pd.read_csv('data/sinhala_farming_data.csv')  # Replace with your dataset file name
questions = data['Question'].values
answers = data['Answer'].values

# Split the dataset into training and testing sets
train_questions, test_questions, train_answers, test_answers = train_test_split(
    questions, answers, test_size=0.2, random_state=42)


# Tokenize questions and answers
def tokenize(text):
    return word_tokenize(text)

train_questions = [tokenize(q) for q in train_questions]
train_answers = [tokenize(a) for a in train_answers]

# Build vocabulary
def build_vocab(sentences):
    counter = Counter()
    for sentence in sentences:
        counter.update(sentence)
    return {word: idx+1 for idx, (word, _) in enumerate(counter.items())}  # idx+1 to reserve 0 for padding

# Build vocabularies
question_vocab = build_vocab(train_questions)
answer_vocab = build_vocab(train_answers)

# Add <PAD>, <SOS>, <EOS>
PAD_TOKEN = 0
SOS_TOKEN = len(answer_vocab) + 1
EOS_TOKEN = len(answer_vocab) + 2

answer_vocab['<SOS>'] = SOS_TOKEN
answer_vocab['<EOS>'] = EOS_TOKEN

# Save vocabularies
torch.save(question_vocab, 'models/vocab_question.pth', _use_new_zipfile_serialization=False)
torch.save(answer_vocab, 'models/vocab_answer.pth', _use_new_zipfile_serialization=False)

class ChatDataset(Dataset):
    def __init__(self, questions, answers, question_vocab, answer_vocab, max_len=30):
        self.questions = questions
        self.answers = answers
        self.question_vocab = question_vocab
        self.answer_vocab = answer_vocab
        self.max_len = max_len

    def encode(self, sentence, vocab, max_len):
        encoded = [vocab.get(word, PAD_TOKEN) for word in sentence]
        return encoded[:max_len] + [PAD_TOKEN] * (max_len - len(encoded))

    def __len__(self):
        return len(self.questions)

    def __getitem__(self, idx):
        q_encoded = self.encode(self.questions[idx], self.question_vocab, self.max_len)
        a_encoded = [SOS_TOKEN] + self.encode(self.answers[idx], self.answer_vocab, self.max_len) + [EOS_TOKEN]
        return torch.tensor(q_encoded), torch.tensor(a_encoded)
    
train_dataset = ChatDataset(train_questions, train_answers, question_vocab, answer_vocab)
test_dataset = ChatDataset(test_questions, test_answers, question_vocab, answer_vocab)

train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
test_loader = DataLoader(test_dataset, batch_size=32, shuffle=False)

class Seq2Seq(nn.Module):
    def __init__(self, vocab_size, embedding_dim, hidden_dim, output_dim):
        super(Seq2Seq, self).__init__()
        self.embedding = nn.Embedding(vocab_size, embedding_dim, padding_idx=PAD_TOKEN)
        self.encoder = nn.LSTM(embedding_dim, hidden_dim, batch_first=True)
        self.decoder = nn.LSTM(embedding_dim, hidden_dim, batch_first=True)
        self.fc = nn.Linear(hidden_dim, output_dim)

    def forward(self, input, target):
        embedded_input = self.embedding(input)
        _, (hidden, cell) = self.encoder(embedded_input)

        embedded_target = self.embedding(target)
        decoder_output, _ = self.decoder(embedded_target, (hidden, cell))
        output = self.fc(decoder_output)
        return output

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

model = Seq2Seq(
    vocab_size=len(question_vocab) + len(answer_vocab) + 3,  # +3 for PAD, SOS, EOS
    embedding_dim=256,
    hidden_dim=512,
    output_dim=len(answer_vocab) + 3
).to(device)

criterion = nn.CrossEntropyLoss(ignore_index=PAD_TOKEN)
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

def train_epoch(model, loader, optimizer, criterion):
    model.train()
    epoch_loss = 0
    for questions, answers in loader:
        questions, answers = questions.to(device), answers.to(device)
        optimizer.zero_grad()
        outputs = model(questions, answers[:, :-1])  # Shift target by 1
        loss = criterion(outputs.view(-1, outputs.size(-1)), answers[:, 1:].reshape(-1))  # Ignore <SOS>
        loss.backward()
        optimizer.step()
        epoch_loss += loss.item()
    return epoch_loss / len(loader)

# Train the model
for epoch in range(100):  # Adjust epochs as necessary
    loss = train_epoch(model, train_loader, optimizer, criterion)
    print(f"Epoch {epoch+1}, Loss: {loss:.4f}")

torch.save(model.state_dict(), 'models/sinhala_chatbot_model.pth', _use_new_zipfile_serialization=False)

# Load the trained model
def load_chatbot_model(question_vocab, answer_vocab):
    model = Seq2Seq(
      vocab_size=len(question_vocab) + len(answer_vocab) + 3,  # +3 for PAD, SOS, EOS
      embedding_dim=256,
      hidden_dim=512,
      output_dim=len(answer_vocab) + 3
    ).to(device)
    state_dict = torch.load('models/sinhala_chatbot_model.pth', map_location=device)
    model.load_state_dict(state_dict)
    model.eval()
    return model


def preprocess_question(question, vocab, max_len):
    """
    Tokenize and encode the question using the provided vocabulary and max length.
    """
    tokens = word_tokenize(question)
    encoded = [vocab.get(token, PAD_TOKEN) for token in tokens]  # Default to PAD_TOKEN for unknown words
    return torch.tensor(encoded[:max_len] + [PAD_TOKEN] * (max_len - len(encoded)), dtype=torch.long)

def generate_chatbot_response(model, question, question_vocab, answer_vocab, max_len=30, temperature=0.7, top_k=5):
    """
    Generate a response for a given question using the trained Seq2Seq model.
    """
    model.eval()  # Set model to evaluation mode
    with torch.no_grad():
        # Preprocess the question
        input_tensor = preprocess_question(question, question_vocab, max_len).unsqueeze(0).to(device)  # Add batch dimension

        # Encode the question
        embedded_input = model.embedding(input_tensor)
        _, (hidden, cell) = model.encoder(embedded_input)

        # Start decoding with <SOS> token
        decoder_input = torch.tensor([[SOS_TOKEN]], dtype=torch.long).to(device)
        response_tokens = []

        for _ in range(max_len):
            # Decode the next token
            embedded_decoder_input = model.embedding(decoder_input)
            decoder_output, (hidden, cell) = model.decoder(embedded_decoder_input, (hidden, cell))
            output_token_logits = model.fc(decoder_output[:, -1, :])  # Get the last time-step output

            # Apply temperature and top-k filtering
            logits = output_token_logits / temperature
            top_k_logits = torch.topk(logits, k=top_k, dim=-1).indices.squeeze(0)
            next_token = top_k_logits[torch.multinomial(F.softmax(logits, dim=-1)[0, top_k_logits], 1)].item()

            response_tokens.append(next_token)
            if next_token == EOS_TOKEN or next_token == answer_vocab.get('.'):
                break

            decoder_input = torch.tensor([[next_token]], dtype=torch.long).to(device)

        idx_to_word = {idx: word for word, idx in answer_vocab.items()}
        response = [idx_to_word[token] for token in response_tokens if token not in {PAD_TOKEN, SOS_TOKEN, EOS_TOKEN}]
        return ' '.join(response)


    app.run(debug=True)
