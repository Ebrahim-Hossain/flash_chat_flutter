import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:flash_chat_flutter/screens/chat_screen.dart';
import 'package:flash_chat_flutter/screens/components/refactor_button.dart';
import 'package:flutter/material.dart';
import 'package:overlay_adaptive_progress_hub/overlay_adaptive_progress_hub.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static const String id = "registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OverlayAdaptiveProgressHub(
        inAsyncCall: isLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(height: 48.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                style: TextStyle(color: Colors.black54),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                style: TextStyle(color: Colors.black54),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(height: 24.0),
              RefactorButton(
                color: Colors.blueAccent,
                text: 'Register',
                function: () async {
                  // log('$email');
                  // log('$password');
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    if (newUser.user != null) {
                      if(!context.mounted) return;
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      isLoading = false;
                    });

                  }
                  catch (e) {
                    log(e.toString());
                    setState(() {
                      isLoading = false;
                    });
                  }

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
