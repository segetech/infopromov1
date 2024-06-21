import 'package:flutter/material.dart';
import 'package:infopromo_v1/screens/introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToIntro();
  }

  _navigateToIntro() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => IntroductionScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.scale(
          scale: 0.5, // Réduit la taille de 50%
          child: Image.asset(
              'assets/logo.png'), // Assurez-vous d'avoir ce fichier dans le dossier assets
        ),
      ),
    );
  }
}
