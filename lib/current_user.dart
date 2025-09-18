import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  static User? logInUser;
  static final _auth = FirebaseAuth.instance;
  static void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        logInUser = user;
        log('${logInUser?.email}');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}