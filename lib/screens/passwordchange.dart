import 'package:flutter/material.dart';
import 'package:infopromo_v1/constants.dart'; // Importer les constantes

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Changer le mot de passe',
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
              controller: _oldPasswordController,
              label: 'Ancien mot de passe',
              icon: Icons.lock,
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _newPasswordController,
              label: 'Nouveau mot de passe',
              icon: Icons.lock,
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'Confirmer le nouveau mot de passe',
              icon: Icons.lock,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique pour changer le mot de passe
                String oldPassword = _oldPasswordController.text;
                String newPassword = _newPasswordController.text;
                String confirmPassword = _confirmPasswordController.text;

                // Vérifier si les champs ne sont pas vides et si les mots de passe correspondent
                if (oldPassword.isNotEmpty &&
                    newPassword.isNotEmpty &&
                    confirmPassword.isNotEmpty &&
                    newPassword == confirmPassword) {
                  // Mettez ici votre logique pour changer le mot de passe
                  // Par exemple, vous pouvez appeler une fonction pour envoyer les données au backend
                  print('Changer le mot de passe avec succès');
                } else {
                  // Afficher un message d'erreur si les champs sont vides ou si les mots de passe ne correspondent pas
                  print(
                      'Erreur : Veuillez remplir tous les champs et assurez-vous que les mots de passe correspondent.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Utiliser la couleur primaire
              ),
              child: Text(
                'Changer le mot de passe',
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
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
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
    );
  }
}
