// lib/components/custom_navigation_bar.dart

import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  CustomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
          label: 'Profil',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor:
          Colors.white, // Couleur du texte des éléments sélectionnés
      unselectedItemColor: Colors.white
          .withOpacity(0.7), // Couleur des éléments non sélectionnés
      showUnselectedLabels: false, // Masquer les labels non sélectionnés
      backgroundColor: Color(0xFFED1C24), // Couleur rouge pour l'arrière-plan
      type: BottomNavigationBarType.fixed,
      onTap: onItemTapped,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white, // Couleur du texte des éléments sélectionnés
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.white
            .withOpacity(0.7), // Couleur du texte des éléments non sélectionnés
      ),
    );
  }
}
