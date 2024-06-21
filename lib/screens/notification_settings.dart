import 'package:flutter/material.dart';
import 'package:infopromo_v1/constants.dart'; // Importez les constantes

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  String _emailNotificationFrequency = 'quotidien';
  bool _smsNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres de notifications',
            style: TextStyle(
                color: Colors.white)), // Appliquez la couleur blanche au titre
        backgroundColor:
            primaryColor, // Utilisez la couleur primaire pour l'AppBar
        iconTheme: IconThemeData(
            color: Colors
                .white), // Appliquez la couleur blanche à l'icône de retour
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications push',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      primaryColor), // Appliquez la couleur primaire au titre
            ),
            SizedBox(height: 10),
            SwitchListTile(
              title: Text('Autoriser les notifications push'),
              value:
                  _pushNotificationsEnabled, // Définissez la valeur en fonction de l'état des notifications push
              onChanged: (value) {
                setState(() {
                  _pushNotificationsEnabled =
                      value; // Mettez à jour l'état des notifications push
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'E-mails de notification',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      primaryColor), // Appliquez la couleur primaire au titre
            ),
            SizedBox(height: 10),
            SwitchListTile(
              title: Text('Autoriser les e-mails de notification',
                  style: TextStyle(
                      color:
                          primaryColor)), // Appliquez la couleur primaire au texte
              value:
                  _emailNotificationsEnabled, // Définissez la valeur en fonction de l'état des e-mails de notification
              onChanged: (value) {
                setState(() {
                  _emailNotificationsEnabled =
                      value; // Mettez à jour l'état des e-mails de notification
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Notifications par SMS',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      primaryColor), // Appliquez la couleur primaire au titre
            ),
            SizedBox(height: 10),
            SwitchListTile(
              title: Text('Autoriser les notifications par SMS',
                  style: TextStyle(
                      color:
                          primaryColor)), // Appliquez la couleur primaire au texte
              value:
                  _smsNotificationsEnabled, // Définissez la valeur en fonction de l'état des notifications par SMS
              onChanged: (value) {
                setState(() {
                  _smsNotificationsEnabled =
                      value; // Mettez à jour l'état des notifications par SMS
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Fréquence des e-mails',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      primaryColor), // Appliquez la couleur primaire au titre
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value:
                  _emailNotificationFrequency, // Définissez la valeur sélectionnée en fonction de la fréquence actuelle
              onChanged: (String? newValue) {
                setState(() {
                  _emailNotificationFrequency =
                      newValue!; // Mettez à jour la fréquence des e-mails
                });
              },
              items: <String>['quotidien', 'hebdomadaire', 'mensuel']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(
                          color:
                              primaryColor)), // Appliquez la couleur primaire au texte
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
