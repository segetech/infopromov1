import 'package:flutter/material.dart';
import 'package:infopromo_v1/screens/map_screen.dart';
import 'package:infopromo_v1/screens/categories_screen.dart';
import 'package:infopromo_v1/screens/profile_screen.dart'; // Importez votre nouvelle page de profil

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    MapScreen(),
    CategoriesScreen(),
    Center(child: Text('Notifications')),
    Center(child: Text('Enregistré')),
    ProfileScreen(), // Ajoutez la page de profil ici
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Deals du jour',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Catégories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Enregistré',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 252, 19,
            3), // Couleur des icônes et des légendes sélectionnées
        unselectedItemColor: Colors
            .black, // Couleur des icônes et des légendes non sélectionnées
        selectedLabelStyle: TextStyle(
          color: Color.fromARGB(255, 252, 19, 3),
        ), // Couleur des légendes sélectionnées
        unselectedLabelStyle: TextStyle(
          color: Colors.black,
        ), // Couleur des légendes non sélectionnées
        onTap: _onItemTapped,
      ),
    );
  }
}
