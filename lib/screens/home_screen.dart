import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'components/custom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  GoogleMapController? _mapController;
  LatLng _bamakoPosition = LatLng(12.6392, -8.0029); // Coordonnées de Bamako
  LatLng? _currentPosition; // Position actuelle de l'utilisateur

  final List<Widget> _screens = [
    // Ajouter les écrans ici comme vous l'avez fait précédemment
    Center(child: Text('Notifications')),
    Center(child: Text('Enregistré')),
    Center(child: Text('Profil')), // ProfilScreen à ajouter ici si nécessaire
  ];

  @override
  void initState() {
    super.initState();
    _checkPermissionAndGetLocation();
  }

  Future<void> _checkPermissionAndGetLocation() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      _getCurrentLocation();
    } else if (status.isDenied ||
        status.isRestricted ||
        status.isPermanentlyDenied) {
      _showLocationPermissionDialog(); // Afficher une boîte de dialogue pour expliquer pourquoi la localisation est nécessaire
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14),
        ),
      );
    } catch (e) {
      print("Erreur lors de la récupération de la position : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: Impossible de récupérer la position')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14),
        ),
      );
    } else {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _bamakoPosition, zoom: 12),
        ),
      );
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission de localisation nécessaire'),
        content: Text(
            'Cette application a besoin d\'accéder à votre position pour fonctionner correctement. Veuillez accorder la permission.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              var status = await Permission.location.request();
              if (status.isGranted) {
                _getCurrentLocation();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Permission de localisation refusée')),
                );
              }
            },
            child: Text('Autoriser'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _bamakoPosition,
                    zoom: 12,
                  ),
                  myLocationEnabled: true,
                ),
                Positioned(
                  top: 50,
                  left: 15,
                  right: 15,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.search, color: Colors.red),
                            hintText: "Rechercher",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Action pour la localisation actuelle
                        },
                        icon: Icon(Icons.location_pin),
                        label: Text('Bacodjicoroni ACI'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Action pour le bouton d'alertes/notifications
                        },
                        icon: Icon(Icons.notifications),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : _screens[_selectedIndex - 1],
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
