import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'geolocation_page.dart';

class VendorDetailsPage extends StatefulWidget {
  final String userId;
  final String boutiqueName;
  final String whatsappNumber;
  final String address;
  final String commune;
  final String category;
  final String? logoUrl;

  VendorDetailsPage({
    required this.userId,
    required this.boutiqueName,
    required this.whatsappNumber,
    required this.address,
    required this.commune,
    required this.category,
    this.logoUrl,
  });

  @override
  _VendorDetailsPageState createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage> {
  final TextEditingController _descriptionController = TextEditingController();
  bool isOpenEveryDay = true;
  TimeOfDay _generalOpeningTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _generalClosingTime = TimeOfDay(hour: 17, minute: 0);

  Map<String, TimeOfDay> _openingTimes = {
    "Lundi": TimeOfDay(hour: 8, minute: 0),
    "Mardi": TimeOfDay(hour: 8, minute: 0),
    "Mercredi": TimeOfDay(hour: 8, minute: 0),
    "Jeudi": TimeOfDay(hour: 8, minute: 0),
    "Vendredi": TimeOfDay(hour: 8, minute: 0),
    "Samedi": TimeOfDay(hour: 8, minute: 0),
    "Dimanche": TimeOfDay(hour: 8, minute: 0),
  };
  Map<String, TimeOfDay> _closingTimes = {
    "Lundi": TimeOfDay(hour: 17, minute: 0),
    "Mardi": TimeOfDay(hour: 17, minute: 0),
    "Mercredi": TimeOfDay(hour: 17, minute: 0),
    "Jeudi": TimeOfDay(hour: 17, minute: 0),
    "Vendredi": TimeOfDay(hour: 17, minute: 0),
    "Samedi": TimeOfDay(hour: 17, minute: 0),
    "Dimanche": TimeOfDay(hour: 17, minute: 0),
  };

  final List<String> paymentMethods = [
    'Cash',
    'Carte bancaire',
    'Mobile Money',
    'Virement bancaire',
  ];
  List<String> _selectedPaymentMethods = [];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectGeneralTime(bool isOpening) async {
    try {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: isOpening ? _generalOpeningTime : _generalClosingTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (selectedTime != null) {
        setState(() {
          if (isOpening) {
            _generalOpeningTime = selectedTime;
          } else {
            _generalClosingTime = selectedTime;
          }
        });
      }
    } catch (e) {
      print("Erreur lors de la sélection du temps : $e");
    }
  }

  Future<void> _selectTimeForDay(String day, bool isOpening) async {
    try {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: isOpening ? _openingTimes[day]! : _closingTimes[day]!,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (selectedTime != null) {
        setState(() {
          if (isOpening) {
            _openingTimes[day] = selectedTime;
          } else {
            _closingTimes[day] = selectedTime;
          }
        });
      }
    } catch (e) {
      print("Erreur lors de la sélection du temps pour $day : $e");
    }
  }

  void _goToGeolocationPage() async {
    try {
      // Sauvegarder les informations de la boutique dans Firestore
      await FirebaseFirestore.instance
          .collection('Shops')
          .doc(widget.userId)
          .update({
        'description': _descriptionController.text,
        'isOpenEveryDay': isOpenEveryDay,
        'generalOpeningTime': _generalOpeningTime.format(context),
        'generalClosingTime': _generalClosingTime.format(context),
        'openingTimes': _openingTimes
            .map((day, time) => MapEntry(day, time.format(context))),
        'closingTimes': _closingTimes
            .map((day, time) => MapEntry(day, time.format(context))),
        'paymentMethods': _selectedPaymentMethods,
      });

      // Naviguer vers la page de géolocalisation après l'enregistrement
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GeolocationPage(userId: widget.userId),
        ),
      );
    } catch (e) {
      print("Erreur pendant l'enregistrement des données de la boutique : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erreur: Impossible d\'enregistrer les informations')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFED1C24),
        title: Text(
          'Nous y sommes presque',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4, // Champ plus grand pour la description
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description, color: Color(0xFFED1C24)),
                  labelText: 'Description de la Boutique',
                  labelStyle: TextStyle(color: Color(0xFFED1C24)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFED1C24)),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                "Horaires d'ouverture",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: Text('Ouvert tous les jours'),
                value: isOpenEveryDay,
                activeColor: Color(0xFFED1C24),
                onChanged: (value) {
                  setState(() {
                    isOpenEveryDay = value;
                  });
                },
              ),
              SizedBox(height: 10),
              if (isOpenEveryDay) ...[
                ListTile(
                  title: Text('Heure d\'ouverture générale'),
                  trailing: Text(_generalOpeningTime.format(context)),
                  onTap: () => _selectGeneralTime(true),
                ),
                ListTile(
                  title: Text('Heure de fermeture générale'),
                  trailing: Text(_generalClosingTime.format(context)),
                  onTap: () => _selectGeneralTime(false),
                ),
              ],
              if (!isOpenEveryDay)
                ..._openingTimes.keys.map((day) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Heure d\'ouverture - $day'),
                        trailing: Text(_openingTimes[day]!.format(context)),
                        onTap: () => _selectTimeForDay(day, true),
                      ),
                      ListTile(
                        title: Text('Heure de fermeture - $day'),
                        trailing: Text(_closingTimes[day]!.format(context)),
                        onTap: () => _selectTimeForDay(day, false),
                      ),
                      Divider(),
                    ],
                  );
                }).toList(),
              SizedBox(height: 20),
              Text(
                "Modes de paiement",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: paymentMethods.map((method) {
                  return FilterChip(
                    label: Text(method),
                    selected: _selectedPaymentMethods.contains(method),
                    selectedColor: Color(0xFFED1C24).withOpacity(0.7),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          _selectedPaymentMethods.add(method);
                        } else {
                          _selectedPaymentMethods.remove(method);
                        }
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    checkmarkColor: Colors.white,
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goToGeolocationPage,
                child: Text('Continuer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFED1C24),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
