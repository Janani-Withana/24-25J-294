import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool _isLoading = false;
  List<List<Map<String, String>>> chatHistory = [];
  static const String userId = "user123";

  @override
  void initState() {
    super.initState();
    _initializeBotConversation();
    loadChatHistoryFromFirebase();
  }

  void _initializeBotConversation() {
    setState(() {
      messages.add({"bot": "ආයුබෝවන්!"});
      messages.add({"bot": "මට ඔබට උදව් කළ හැකි ද?"});
    });
  }

  void loadChatSession(List<Map<String, String>> chat) {
    setState(() {
      messages = chat;
    });
  }

  Future<void> loadChatHistoryFromFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("chat_history")
          .doc(userId)
          .collection("messages")
          .orderBy("timestamp", descending: false)
          .get();

      List<Map<String, String>> session = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data.containsKey("question") && data.containsKey("answer")) {
          // each doc → TWO bubbles
          session.add({"user": data["question"]}); 
          session.add({"bot": data["answer"]}); 
        }
      }

      if (session.isNotEmpty) {
        setState(() {
          chatHistory = [session]; // You can group more sessions later
        });
      }
    } catch (e) {
      print("Error loading chat history: $e");
    }
  }

  Future<void> sendMessage(String message) async {
    const String userId = "user123";
    var url = Uri.parse('http://192.168.8.199:5000/api/chat');

    setState(() {
      messages.add({"user": message}); // Show user message immediately
      _isLoading = true; // Start loading indicator
    });

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'message': message, 'user_id': userId}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var reply = data['reply'] ?? 'No reply generated from the server';

        setState(() {
          messages.add({"bot": reply});
        });
      } else {
        setState(() {
          messages.add({
            "bot":
                "Error: Unable to get a valid response. Status code: ${response.statusCode}"
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"bot": "Error: $e"});
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  void saveCurrentChatToHistory() {
    chatHistory.add(List<Map<String, String>>.from(messages));
  }

  void openHistoryDrawer() {
    saveCurrentChatToHistory();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ChatHistory(
        userId: userId, // ← NEW
        onChatSelected: loadChatSession,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {},
            ),
            title: const Text(
              'ගොවි ගුරු',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.black),
                onPressed: openHistoryDrawer,
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Image.asset(
                            "assets/images/chatbot_logo.png",
                            width: 100,
                            height: 100,
                          ),
                        ),
                      );
                    }

                    var message = messages[index - 1];
                    bool isUser = message.containsKey("user");
                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFF4BA26A)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isUser
                                ? const Radius.circular(16)
                                : Radius.zero,
                            bottomRight: isUser
                                ? Radius.zero
                                : const Radius.circular(16),
                          ),
                        ),
                        child: SelectableText( 
                          isUser ? message["user"]! : message["bot"]!,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'ඔබේ ප්‍රශ්නය ඇතුලත් කරන්න',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF4BA26A)),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          sendMessage(_controller.text);
                          _controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF4BA26A)),
            ),
          ),
      ],
    );
  }
}
