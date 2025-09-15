import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:flash_chat_flutter/screens/chat_screen.dart';
import 'package:flash_chat_flutter/screens/components/refactor_button.dart';
import 'package:flutter/material.dart';
import 'package:overlay_adaptive_progress_hub/overlay_adaptive_progress_hub.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                controller: emailController,
                style: TextStyle(color: Colors.black54),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                controller: passwordController,
                style: TextStyle(color: Colors.black54),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "Enter your password",
                ),
              ),
              SizedBox(height: 24.0),
              RefactorButton(
                color: Colors.lightBlueAccent,
                text: 'Log In',
                function: () async{
                  setState(() {
                    isLoading = true;
                  });

                  try{
                    final user = await _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                    if (user.user != null){
                      if(!context.mounted) return;
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      isLoading = false;
                    });
                  }on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      log('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      log('Wrong password provided for that user.');
                    } else if (e.code == 'invalid-email') {
                      log('The email address is not valid.');
                    } else {
                      log('Login failed: ${e.message}');
                    }
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
