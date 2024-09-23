import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/screens/auth/screen/login_screen.dart';
import 'package:we_chat/screens/screen/home_screen.dart';

class splashServices {
  final auth = FirebaseAuth.instance;
  void isLogin(BuildContext context) {
    if (auth.currentUser != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }
}
