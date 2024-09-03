import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'vendor_dashboard_page.dart'; // Import de la page du tableau de bord

class VendorCongratulationsPage extends StatefulWidget {
  @override
  _VendorCongratulationsPageState createState() =>
      _VendorCongratulationsPageState();
}

class _VendorCongratulationsPageState extends State<VendorCongratulationsPage> {
  String shopName = "Votre boutique";

  @override
  void initState() {
    super.initState();
    _loadShopName();
  }

  Future<void> _loadShopName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot shopDoc = await FirebaseFirestore.instance
            .collection('Shops')
            .doc(user.uid)
            .get();

        if (shopDoc.exists) {
          Map<String, dynamic>? data = shopDoc.data() as Map<String, dynamic>?;
          setState(() {
            shopName = data?['name'] ?? "Nom de la boutique non trouvé";
          });
        } else {
          print("Le document de la boutique n'existe pas");
        }
      } catch (e) {
        print("Erreur lors de la récupération du nom de la boutique: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFED1C24),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.celebration,
                color: Colors.white,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Félicitations $shopName!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Votre boutique est prête.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Rediriger l'utilisateur vers la page du tableau de bord
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VendorDashboardPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFFED1C24),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Continuer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
