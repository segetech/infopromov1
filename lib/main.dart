import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:infopromo_v1/screens/introduction_screen.dart';
import 'package:infopromo_v1/screens/landing_page.dart';
import 'package:infopromo_v1/screens/signup_page.dart';
import 'package:infopromo_v1/screens/vendor_registration_page.dart';
import 'package:infopromo_v1/screens/user_congratulations_page.dart';
import 'package:infopromo_v1/screens/vendor_congratulations_page.dart';
import 'package:flutter/foundation.dart'; // Pour détecter si c'est une application Web

// Initialisation de Firebase
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Initialisation pour le Web
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDV3oFJKNA2wZoEODDWRL_BJ2vF7ALdcHE",
        authDomain: "myinfopromo-8c7fd.firebaseapp.com",
        projectId: "myinfopromo-8c7fd",
        storageBucket: "myinfopromo-8c7fd.appspot.com",
        messagingSenderId: "139791381142",
        appId: "1:139791381142:web:3bdae3edc8f70f285d88b7",
      ),
    );
  } else {
    // Initialisation pour Android/iOS
    await Firebase.initializeApp();
  }

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
        '/signup': (context) => SignupPage(),
        '/vendor_registration': (context) =>
            VendorRegistrationPage(userId: null), // Placeholder userId
        '/user_congratulations': (context) => UserCongratulationsPage(),
        '/vendor_congratulations': (context) => VendorCongratulationsPage(),
      },
    );
  }
}
