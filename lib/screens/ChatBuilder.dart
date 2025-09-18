import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ChatBuilder extends StatelessWidget {
  const ChatBuilder({
    super.key,
    required FirebaseFirestore fireStore,
  }) : _fireStore = fireStore;

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
              final messageWidget = Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsetsGeometry.directional(start: 15) ,
                      child: Text(
                        '$messageSender',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightBlueAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 0.5,
                            blurRadius: 8,
                            offset: Offset(1, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Text(
                        '$messageText',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              messageWidgets.add(messageWidget);
            }
            return ListView(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: messageWidgets,
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}