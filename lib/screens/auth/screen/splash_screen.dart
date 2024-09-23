import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/screenServices/splashServices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  splashServices services = splashServices();
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    Future.delayed(const Duration(seconds: 2), () {
      services.isLogin(context);
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
              right: media.width * 0.25,
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
