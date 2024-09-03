import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/side_menu.dart';

class VendorDashboardPage extends StatefulWidget {
  @override
  _VendorDashboardPageState createState() => _VendorDashboardPageState();
}

class _VendorDashboardPageState extends State<VendorDashboardPage> {
  String shopName = "";
  String phoneNumber = "";
  String logoUrl = "";

  @override
  void initState() {
    super.initState();
    _loadVendorDetails();
  }

  Future<void> _loadVendorDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot shopDoc = await FirebaseFirestore.instance
            .collection('Shops')
            .doc(user.uid)
            .get();

        if (shopDoc.exists) {
          Map<String, dynamic>? data = shopDoc.data() as Map<String, dynamic>?;
          print("Données récupérées : $data");
          if (data != null) {
            print("Valeur actuelle de shopName avant affectation: $shopName");
            setState(() {
              shopName = data['name'] ?? "Nom de la boutique non trouvé";
              phoneNumber = data['whatsappNumber'] ?? "Numéro non disponible";
              logoUrl = data['logoUrl'] ?? "";
            });
            print("Valeur de shopName après affectation: $shopName");
          } else {
            print("Les données de la boutique sont nulles");
          }
        } else {
          print("Le document de la boutique n'existe pas");
        }
      } catch (e) {
        print("Erreur lors de la récupération des détails de la boutique: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEDEC), // Couleur de fond
      appBar: AppBar(
        backgroundColor: Color(0xFFFDEDEC),
        elevation: 0,
        title: Text(
          'Tableau de Bord',
          style: TextStyle(
            color: Color(0xFFED1C24),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Color(0xFFED1C24)),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Color(0xFFED1C24)),
            onPressed: () {
              // Action pour les notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.chat_bubble, color: Color(0xFFED1C24)),
            onPressed: () {
              // Action pour les messages
            },
          ),
        ],
      ),
      drawer: SideMenu(
        shopName: shopName,
        phoneNumber: phoneNumber,
        logoUrl: logoUrl,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              CircleAvatar(
                radius: 50,
                backgroundImage: logoUrl.isNotEmpty
                    ? NetworkImage(logoUrl)
                    : AssetImage('assets/icons/shop_icon.png') as ImageProvider,
              ),
              SizedBox(height: 10),
              Text(
                'Bonjour $shopName !',
                style: TextStyle(
                  color: Color(0xFFED1C24),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // Section Mes Messages
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'Mes Messages',
                  style: TextStyle(
                    color: Color(0xFFED1C24),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Section Promos
              _buildDashboardSection(
                title: 'Promos',
                items: [
                  _buildDashboardItem('Mes Promos Actives', '3', true),
                  _buildDashboardItem('Créer une nouvelle promotion', '', false,
                      icon: Icons.add),
                  _buildDashboardItem('En attente', '0', false),
                  _buildDashboardItem('Total Promos', '12', false),
                ],
              ),
              SizedBox(height: 20),
              // Section Statistiques
              _buildDashboardSection(
                title: 'Statistiques',
                items: [
                  _buildDashboardItem('Nombre d’abonnés', '75', true),
                  _buildDashboardItem('Visiteur Active', '0', false),
                  _buildDashboardItem('Visiteur de la Journée', '36', false),
                  _buildDashboardItem('Vue unique', '27', false),
                ],
              ),
              SizedBox(height: 20),
              // Graphique placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Graphique des vues',
                    style: TextStyle(
                      color: Color(0xFFED1C24),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardSection(
      {required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFFED1C24),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: items,
        ),
      ],
    );
  }

  Widget _buildDashboardItem(String title, String value, bool isHighlighted,
      {IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlighted ? Color(0xFFED1C24) : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Color(0xFFED1C24),
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: isHighlighted ? Colors.white : Color(0xFFED1C24),
              size: 30,
            ),
          if (icon != null) SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isHighlighted ? Colors.white : Color(0xFFED1C24),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (value.isNotEmpty) SizedBox(height: 10),
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(
                color: isHighlighted ? Colors.white : Color(0xFFED1C24),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
