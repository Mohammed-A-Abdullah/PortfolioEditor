import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protofolio_edit/constant.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  Future<void> deleteMessage(String docId) async {
    await FirebaseFirestore.instance.collection('messages').doc(docId).delete();
  }

  Future<void> markAsRead(String docId) async {
    await FirebaseFirestore.instance.collection('messages').doc(docId).update({
      'isRead': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Messages", style: TextStyle(fontFamily: 'Rubic')),
        centerTitle: true,
        backgroundColor: sectionColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "There is no message",
                style: TextStyle(fontFamily: 'Rubic', fontSize: 20,color: primaryColor,fontWeight: FontWeight.bold),
              ),
            );
          }

          final messages = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: messages.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final msg = messages[index];
              final docId = msg.id;
              final email = msg['email'] ?? "No Email";
              final content = msg['message'] ?? "";
              final timestamp = msg['timestamp'];
              final isRead = msg['isRead'] ?? false;

              String formattedTime = "";
              if (timestamp is Timestamp) {
                formattedTime = DateFormat(
                  "yyyy-MM-dd • hh:mm a",
                ).format(timestamp.toDate());
              }

              return GestureDetector(
                onTap: () async {
                  await markAsRead(docId);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MessageDetailPage(
                        email: email,
                        content: content,
                        time: formattedTime,
                        docId: docId,
                        onDelete: () async {
                          await deleteMessage(docId);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  color: isRead
                      ? cardColor
                      : Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: isRead ? 2 : 6,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (!isRead)
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: Colors.blue,
                                ),
                              ),
                            Expanded(
                              child: Text(
                                email,
                                style: TextStyle(
                                  fontFamily: 'Rubic',
                                  fontSize: 16,
                                  fontWeight: isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  color: isRead
                                      ? primaryColor
                                      : Colors.blueAccent,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            fontFamily: 'Rubic',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MessageDetailPage extends StatelessWidget {
  final String email;
  final String content;
  final String time;
  final String docId;
  final VoidCallback onDelete;

  const MessageDetailPage({
    super.key,
    required this.email,
    required this.content,
    required this.time,
    required this.docId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Read message",
          style: TextStyle(fontFamily: 'Rubic'),
        ),
        backgroundColor: sectionColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: primaryColor),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: cardColor,
                  title: const Text(
                    "Delete",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    "Are you sure about deleting the message?",
                    style: TextStyle(color: primaryColor, fontSize: 18),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onDelete();
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      email,
                      style: TextStyle(
                        fontFamily: 'Rubic',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    time,
                    style: const TextStyle(
                      fontFamily: 'Rubic',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 1),
              Text(
                content,
                style: const TextStyle(
                  fontFamily: 'Rubic',
                  fontSize: 18,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
