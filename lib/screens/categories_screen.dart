import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Catégories'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          CategoryCard('Cadeaux'),
          CategoryCard('Beauté & bien-être'),
          CategoryCard('Hôtels & voyages'),
          CategoryCard('Restaurants & bars'),
          CategoryCard('Électronique'),
          CategoryCard('Mode Femmes'),
          CategoryCard('Forme & santé'),
          CategoryCard('Vente au détail'),
          CategoryCard('Super Marché'),
          CategoryCard('Pour la Maison'),
          CategoryCard('Loisirs & sorties'),
          CategoryCard('Salle de Jeux'),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;

  CategoryCard(this.title);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
