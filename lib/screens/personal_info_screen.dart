import 'package:flutter/material.dart';
import 'package:infopromo_v1/constants.dart'; // Importer les constantes

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informations personnelles',
          style: TextStyle(color: Colors.white), // Texte blanc pour le titre
        ),
        backgroundColor:
            primaryColor, // Utiliser la couleur primaire pour l'AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Nom',
              icon: Icons.person,
              enabled: _isEditing,
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Adresse e-mail',
              icon: Icons.email,
              enabled: _isEditing,
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Numéro de téléphone',
              icon: Icons.phone,
              enabled: _isEditing,
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Quartier',
              icon: Icons.location_city,
              enabled: _isEditing,
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Âge',
              icon: Icons.cake,
              enabled: _isEditing,
            ),
            SizedBox(height: 20),
            if (_isEditing)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                  });
                  // Logique pour enregistrer les informations personnelles
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Utiliser la couleur primaire
                ),
                child: Text(
                  'Enregistrer',
                  style: TextStyle(
                      color: Colors.white), // Texte blanc pour le bouton
                ),
              ),
            if (!_isEditing)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Utiliser la couleur primaire
                ),
                child: Text(
                  'Modifier',
                  style: TextStyle(
                      color: Colors.white), // Texte blanc pour le bouton
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required bool enabled,
  }) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        labelText: label,
        labelStyle: TextStyle(color: primaryColor),
        prefixIcon: Icon(icon, color: primaryColor),
      ),
      enabled: enabled,
    );
  }
}
