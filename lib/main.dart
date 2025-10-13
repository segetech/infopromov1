import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:infopromo_v1/screens/introduction_screen.dart';
import 'package:infopromo_v1/screens/landing_page.dart';
import 'package:infopromo_v1/screens/home_screen.dart';
import 'package:infopromo_v1/screens/signup_page.dart';
import 'package:infopromo_v1/screens/vendor_registration_page.dart';
import 'package:infopromo_v1/screens/user_congratulations_page.dart';
import 'package:infopromo_v1/screens/vendor_congratulations_page.dart';
import 'package:infopromo_v1/utils/session.dart';

// Initialisation de Firebase
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Session.init(); // Initialize session management
  // Utiliser la configuration générée par FlutterFire pour toutes les plateformes
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: kDebugMode,
      initialRoute: '/',
      routes: {
        '/': (context) => IntroductionScreen(),
        '/landing': (context) => LandingPage(),
        '/home': (context) => HomeScreen(),
        '/signup': (context) => SignupPage(),
        '/vendor_registration': (context) =>
            VendorRegistrationPage(userId: null), // Placeholder userId
        '/user_congratulations': (context) => UserCongratulationsPage(),
        '/vendor_congratulations': (context) => VendorCongratulationsPage(),
      },
    );
  }
}
