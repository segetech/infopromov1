import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infopromo_v1/utils/session.dart';
import 'package:infopromo_v1/screens/sign.dart';
import 'package:infopromo_v1/screens/vendor_dashboard_page.dart';
import 'package:infopromo_v1/screens/boutique/shopinformation.dart'; // Import de la page ShopInformationPage

class SideMenu extends StatelessWidget {
  final String shopName;
  final String phoneNumber;
  final String logoUrl;

  SideMenu({
    required this.shopName,
    required this.phoneNumber,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFED1C24)),
            accountName: Text(
              shopName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(
              phoneNumber,
              style: TextStyle(fontSize: 16),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: logoUrl.isNotEmpty
                  ? NetworkImage(logoUrl)
                  : AssetImage('assets/logo.png') as ImageProvider,
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Color(0xFFED1C24)),
            title: Text(
              'Tableau de bord',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VendorDashboardPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Color(0xFFED1C24)),
            title: Text(
              'Paramètres',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Information de la boutique'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ShopInformationPage()), // Navigation vers ShopInformationPage
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Color(0xFFED1C24)),
            title: Text(
              'Déconnexion',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Session.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
