import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool isAnimate = false;

  onstartAnimate() {
    isAnimate = true;
    notifyListeners();
  }
}
