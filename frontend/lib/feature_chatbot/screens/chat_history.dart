import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatHistory extends StatelessWidget {
  final String userId;
  final void Function(List<Map<String, String>>) onChatSelected;

  const ChatHistory({
    super.key,
    required this.userId,
    required this.onChatSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("chat_history")
              .doc(userId)
              .collection("messages")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            // loading / empty states
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("පෙර සංවාද නොමැත"));
            }

            // convert every Firestore doc → one mini “session” ────
            final sessions = snapshot.data!.docs.map((doc) {
              final d = doc.data();
              final DateTime when =
                  (d['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
              return {
                "messages": [
                  {"user": d["question"] as String},
                  {"bot": d["answer"] as String},
                ],
                "timestamp": when,
              };
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "පෙර සංවාද",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final List<Map<String, String>> msgs =
                            List<Map<String, String>>.from(
                                session["messages"] as List);

                        final preview =
                            (msgs.isNotEmpty ? (msgs[0]["user"] ?? "") : "")
                                .characters
                                .take(30)
                                .toString();
                        final dateStr = DateFormat('yyyy-MM-dd  HH:mm')
                            .format(session["timestamp"] as DateTime);

                        return ListTile(
                          title: SelectableText( 
                            dateStr,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 6, 104, 3), 
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: SelectableText( 
                            "$preview…",
                            style: const TextStyle(color: Colors.black87),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            onChatSelected(msgs);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
