import 'package:flutter/material.dart';
import 'package:infopromo_v1/screens/introduction_screen.dart';
import 'package:infopromo_v1/screens/landing_page.dart';
import 'package:infopromo_v1/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => IntroductionScreen(),
        '/landing': (context) => LandingPage(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
