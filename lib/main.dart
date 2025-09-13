import 'package:flash_chat_flutter/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter/screens/login_screen.dart';
import 'package:flash_chat_flutter/screens/registration_screen.dart';
import 'package:flash_chat_flutter/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute:  WelcomeScreen.id,
      routes: {
        "chat_screen" : (context) => ChatScreen(),
        "login_screen" : (context) => LoginScreen(),
        "registration_screen" : (context) => RegistrationScreen(),
        WelcomeScreen.id : (context) => WelcomeScreen(),
      },
    );
  }
}