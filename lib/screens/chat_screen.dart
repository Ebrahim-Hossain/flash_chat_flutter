import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  User? logInUser;
  late String text;
  final _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        logInUser = user;
        log('${logInUser?.email}');
      }
    }catch(e){
      log(e.toString());
    }
  }

  // Future<void> getMessages() async {
  //  var messages = await _fireStore.collection('messages').get();
  //   for (var message in messages.docs){
  //     log("${message.data()}");
  //   }
  // }
  Future<void> getSteam() async {
    await for (var snapShots in _fireStore.collection('messages').snapshots()){
      for (var message in snapShots.docs){
        log("${message.data()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                getSteam();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                  stream: _fireStore.collection('messages').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Widget> messageWidgets = [];
                      final messages = snapshot.data?.docs;
                      for (var message in messages!) {
                        final messageText = message.data()['text'];
                        final messageSender = message.data()['sender'];
                        final messageWidget = Text('$messageText from $messageSender');
                        messageWidgets.add(messageWidget);
                      }
                      return Column(children: messageWidgets,);
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        text = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      _fireStore.collection('messages').add({
                        'sender' : logInUser?.email,
                        'text' : text,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}