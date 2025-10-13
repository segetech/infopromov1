import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'vendor_congratulations_page.dart';
import 'VendorDetailsPage.dart';

class GeolocationPage extends StatefulWidget {
  final String userId;

  GeolocationPage({required this.userId});

  @override
  _GeolocationPageState createState() => _GeolocationPageState();
}

class _GeolocationPageState extends State<GeolocationPage> {
  LatLng _bamakoPosition = LatLng(12.6392, -8.0029);
  LatLng? _currentPosition;
  LatLng? _selectedPosition;
  GoogleMapController? _mapController;
  bool _isLoading = false;
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();
    _setCustomMarkerIcon();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _setCustomMarkerIcon() async {
    _customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/icons/boutique_marker.png',
    );
  }

  Future<bool> _ensureLocationReady() async {
    // Vérifie si les services de localisation sont activés
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activez la localisation dans les paramètres.')),
      );
      await Geolocator.openLocationSettings();
      return false;
    }

    // Vérifie/sollicite la permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission de localisation refusée')),
      );
      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission refusée définitivement. Ouvrez les réglages.')),
      );
      await Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final ok = await _ensureLocationReady();
      if (!ok) return;

      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 6),
        );
      } catch (_) {
        // Sur émulateur, la position courante peut être indisponible; essaye la dernière connue
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) {
          position = last;
        } else {
          // Fallback: rester sur Bamako si aucune position n'est disponible
          setState(() {
            _currentPosition = null;
            _selectedPosition = _bamakoPosition;
          });
          return;
        }
      }

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _selectedPosition = _currentPosition;
      });

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14),
        ),
      );
    } catch (e) {
      // Log et message utilisateur
      // ignore: avoid_print
      print('Erreur lors de la récupération de la position: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur: Impossible de récupérer la position")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _bamakoPosition, zoom: 12),
      ),
    );

    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14),
        ),
      );
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }

  Future<void> _confirmLocation() async {
    if (_selectedPosition != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance
            .collection('Shops')
            .doc(widget.userId)
            .update({
          'location': GeoPoint(
              _selectedPosition!.latitude, _selectedPosition!.longitude),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VendorCongratulationsPage()),
        );
      } catch (e) {
        print("Erreur pendant la sauvegarde de la position : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur: Impossible d\'enregistrer la position')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Veuillez sélectionner un emplacement sur la carte')),
      );
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VendorDetailsPage(
          userId: widget.userId,
          boutiqueName: '',
          whatsappNumber: '',
          address: '',
          commune: '',
          category: '',
          logoUrl: '',
        ),
      ),
    );
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFED1C24),
          title: Text(
            'Géolocalisation de votre boutique',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _bamakoPosition,
                      zoom: 12,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onTap: _onMapTapped,
                    markers: _selectedPosition != null
                        ? {
                            Marker(
                              markerId: MarkerId('selected-location'),
                              position: _selectedPosition!,
                              icon:
                                  _customIcon ?? BitmapDescriptor.defaultMarker,
                              draggable: true,
                              onDragEnd: (newPosition) {
                                setState(() {
                                  _selectedPosition = newPosition;
                                });
                              },
                            ),
                          }
                        : {},
                  ),
                  if (_isLoading) Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _confirmLocation,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Confirmer la Position'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFED1C24),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
