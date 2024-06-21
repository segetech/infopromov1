import 'package:flutter/material.dart';
import 'package:infopromo_v1/screens/home_screen.dart';

class IntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          IntroPage(
            backgroundColor: Colors.white,
            title: 'Info Promo',
            titleColor: Color(0xFFED1C24),
            titleFontSize: 56, // Taille du titre doublée
            subtitle: 'Offres locales à proximité',
            subtitleColor: Colors.black,
            subtitleFontSize: 20, // Augmenté par rapport à l'original
            showArrow: true,
            arrowColor: Color(0xFFED1C24),
          ),
          IntroPage(
            backgroundColor: Color(0xFFED1C24),
            title: 'Économisez jusqu\'à 70 %',
            titleColor: Colors.white,
            titleFontSize: 28,
            subtitle: 'sur les choses que vous faites tous les jours',
            subtitleColor: Colors.white,
            subtitleFontSize: 16,
            showArrow: true,
            arrowColor: Colors.white,
          ),
          IntroPageWithButton(),
        ],
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final Color titleColor;
  final double titleFontSize;
  final String subtitle;
  final Color subtitleColor;
  final double subtitleFontSize;
  final bool showArrow;
  final Color arrowColor;

  IntroPage({
    required this.backgroundColor,
    required this.title,
    required this.titleColor,
    required this.titleFontSize,
    required this.subtitle,
    required this.subtitleColor,
    required this.subtitleFontSize,
    required this.showArrow,
    required this.arrowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: subtitleColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (showArrow) ...[
            SizedBox(height: 20),
            IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: arrowColor,
                size: 30,
              ),
              onPressed: () {
                // Code pour passer à la page suivante
                PageController controller = PageController();
                controller.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class IntroPageWithButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFED1C24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_very_satisfied,
            size: 100,
            color: Colors.white,
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      HomeScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Text(
              'Commencer',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
