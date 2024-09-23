import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/screens/auth/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));
    Future.delayed(const Duration(microseconds: 5), () {
      setState(() {
        isAnimate = true;
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: media.height * 0.15,
              width: media.width * 0.5,
              right: isAnimate ? media.width * 0.25 : -media.width * .5,
              child: Image.asset('asset/icon.png')),
          Positioned(
              bottom: media.height * 0.15,
              width: media.width * .9,
              left: media.width * 0.05,
              height: media.height * 0.06,
              child: const Center(
                  child: Text(
                'Made by Wasim',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )))
        ],
      ),
    );
  }
}
