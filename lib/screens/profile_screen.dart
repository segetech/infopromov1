import 'package:flutter/material.dart';
import 'package:infopromo_v1/screens/personal_info_screen.dart';
import 'package:infopromo_v1/screens/passwordchange.dart';
import 'package:infopromo_v1/screens/notification_settings.dart'; // Importer la page des paramètres de notifications
import 'package:infopromo_v1/constants.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Salika Famanta',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '+223 70 00 90 07',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'salikafamanta@gmail.com',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              leading: Icon(Icons.person, color: primaryColor),
              title: Text('Informations personnelles'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalInfoScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock, color: primaryColor),
              title: Text('Changer le mot de passe'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: primaryColor),
              title: Text('Paramètres de notifications'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationSettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: primaryColor),
              title: Text('Historique d\'activité'),
              onTap: () {
                // Navigate to activity history screen
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: primaryColor),
              title: Text('Paramètres de compte'),
              onTap: () {
                // Navigate to account settings screen
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: primaryColor),
              title: Text('Aide & Support'),
              onTap: () {
                // Navigate to help & support screen
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: primaryColor),
              title: Text('Déconnexion'),
              onTap: () {
                // Handle logout
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: primaryColor),
              title: Text('Supprimer le compte'),
              onTap: () {
                // Handle account deletion
              },
            ),
          ],
        ),
      ),
    );
  }
}
