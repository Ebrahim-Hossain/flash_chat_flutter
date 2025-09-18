import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_flutter/current_user.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'chat_builder.dart';



class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  late String text;
  final _fireStore = FirebaseFirestore.instance;
  TextEditingController textFieldText = TextEditingController();

  @override
  void initState() {
    super.initState();
    CurrentUser.getCurrentUser();
  }



  // Future<void> getMessages() async {
  //  var messages = await _fireStore.collection('messages').get();
  //   for (var message in messages.docs){
  //     log("${message.data()}");
  //   }
  // }
  Future<void> getSteam() async {
    await for (var snapShots in _fireStore.collection('messages').snapshots()) {
      for (var message in snapShots.docs) {
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
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ChatBuilder(fireStore: _fireStore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFieldText,
                      style: TextStyle(color: Colors.black54),
                      onChanged: (value) {
                        //Do something with the user input.
                        text = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textFieldText.clear();
                      //Implement send functionality.
                      _fireStore.collection('messages').add({
                        'sender': CurrentUser.logInUser?.email,
                        'text': text,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


