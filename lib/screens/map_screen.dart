import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Info Promo'),
      ),
      body: Center(
        child: Text('Carte avec les offres locales'), // Vous pouvez utiliser Google Maps ici
      ),
    );
  }
}
