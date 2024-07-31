import 'package:flutter/material.dart';
import 'package:infopromo_v1/screens/landing_page.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          IntroPage1(controller: _controller),
          IntroPage2(controller: _controller),
          LandingPage(),
        ],
      ),
    );
  }
}

class IntroPage1 extends StatelessWidget {
  final PageController controller;

  IntroPage1({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              'assets/images/Image1.png'), // Replace with your image path
          SizedBox(height: 20),
          Text(
            'Info Promo',
            style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: Color(0xFFED1C24),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Offres locales à proximité',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Color(0xFFED1C24),
              size: 30,
            ),
            onPressed: () {
              controller.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }
}

class IntroPage2 extends StatelessWidget {
  final PageController controller;

  IntroPage2({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFED1C24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              'assets/images/Image2.png'), // Replace with your image path
          SizedBox(height: 20),
          Text(
            'Économisez jusqu\'à 70 %',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'sur les choses que vous faites tous les jours',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              controller.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }
}
