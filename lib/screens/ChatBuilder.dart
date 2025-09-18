import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_flutter/current_user.dart';
import 'package:flash_chat_flutter/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatBuilder extends StatelessWidget {
  const ChatBuilder({super.key, required FirebaseFirestore fireStore})
    : _fireStore = fireStore;

  final FirebaseFirestore _fireStore;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: _fireStore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> messageWidgets = [];
            final messages = snapshot.data?.docs;

            for (var message in messages!) {
              final messageText = message.data()['text'];
              final messageSender = message.data()['sender'];
              final currentUser = CurrentUser.logInUser?.email;
              final messageWidget = Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: MessageBubble(
                  messageSender: messageSender,
                  messageText: messageText,
                  isMe: messageSender == currentUser,
                ),
              );
              messageWidgets.add(messageWidget);
            }
            return ListView(
              reverse: true,
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              children: messageWidgets,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.messageSender,
    required this.messageText,
    required this.isMe,
  });

  final dynamic messageSender;
  final dynamic messageText;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          '$messageSender',
          style: TextStyle(color: Colors.black38, fontSize: 15),
        ),
        SizedBox(height: 2),
        Container(
          decoration: BoxDecoration(
            borderRadius: isMe ? BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
            ) : BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                spreadRadius: 0.5,
                blurRadius: 8,
                offset: Offset(1, 4),
              ),
            ],
          ),
          padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            '$messageText',
            style: TextStyle(fontSize: 18, color: isMe ? Colors.white : Colors.black54),
          ),
        ),
      ],
    );
  }
}
