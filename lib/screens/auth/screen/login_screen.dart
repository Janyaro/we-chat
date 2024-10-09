import 'package:flutter/material.dart';
import 'package:we_chat/Utility/mysnakbar.dart';
import 'package:we_chat/api/Api.dart';
import 'package:we_chat/screenServices/loginServices.dart';
import 'package:we_chat/screens/screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      isAnimate = true;
    });
  }

  _onbuttonClick() {
    Utility().showCircularAndicator(context);
    LoginServices().signInWithGoogle(context).then((user) async {
      Navigator.pop(context);
      if (user != null) {
        if (await Api.ExistedUser()) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          await Api.CreateUser().then((value) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          });
        }
      }
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    print('main scaffold hoon');
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
              top: media.height * 0.15,
              width: media.width * 0.5,
              right: isAnimate ? media.width * 0.25 : -media.width * 0.5,
              duration: const Duration(seconds: 1),
              child: Image.asset('asset/icon.png')),
          Positioned(
              bottom: media.height * 0.15,
              width: media.width * .9,
              left: media.width * 0.05,
              height: media.height * 0.06,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.green.shade200),
                  onPressed: () {
                    _onbuttonClick();
                  },
                  icon: Image.asset(
                    'asset/google.png',
                    height: media.height * 0.03,
                  ),
                  label: RichText(
                      text: const TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                        TextSpan(text: 'Sign In With '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w500))
                      ]))))
        ],
      ),
    );
  }
}
