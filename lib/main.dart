import 'package:flutter/material.dart';
import 'package:infopromo_v1/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infopromo_v1/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isFirstTime ? SplashScreen() : HomeScreen(),
  ));
}
