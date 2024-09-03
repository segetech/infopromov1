import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';

class ShopInformationPage extends StatefulWidget {
  @override
  _ShopInformationPageState createState() => _ShopInformationPageState();
}

class _ShopInformationPageState extends State<ShopInformationPage> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _shopPhoneNumberController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _communeController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = '';
  List<String> _selectedPaymentMethods = [];
  String _selectedCountryCode = '+223'; // Default country code for Mali
  String? _shopLogoUrl;
  File? _newLogo;
  bool _isEditing = false;
  GeoPoint? _shopLocation;

  final picker = ImagePicker();

  final List<String> categories = [
    'Électronique',
    'Mode',
    'Couture',
    'Maison',
    'Beauté',
    'Alimentation',
    'Agroalimentaire',
    'Cosmétiques naturels',
    'Artisanat',
    'Téléphonie et accessoires',
    'Informatique',
    'Produits agricoles',
    'Santé et bien-être',
    'Librairie et fournitures',
    'Construction et matériaux',
    'Transport et logistique',
    'Habillement traditionnel',
    'Bijoux et accessoires',
    'Meubles et décoration',
  ];

  final List<String> paymentMethods = [
    'Cash',
    'Carte bancaire',
    'Mobile Money',
    'Virement bancaire',
  ];

  final List<Map<String, String>> quartiers = [
    {'quartier': 'Badalabougou', 'commune': 'Commune V'},
    {'quartier': 'Baco-Djicoroni', 'commune': 'Commune V'},
    {'quartier': 'Baco-Djicoroni ACI', 'commune': 'Commune V'},
    {'quartier': 'Djelibougou', 'commune': 'Commune I'},
    {'quartier': 'Hamdallaye', 'commune': 'Commune IV'},
    {'quartier': 'ACI 2000', 'commune': 'Commune IV'},
    {'quartier': 'Boulkassoumbougou', 'commune': 'Commune I'},
    {'quartier': 'Sikoroni', 'commune': 'Commune I'},
    {'quartier': 'Lafiabougou', 'commune': 'Commune IV'},
    {'quartier': 'Niarela', 'commune': 'Commune II'},
    {'quartier': 'Bozola', 'commune': 'Commune II'},
    {'quartier': 'Sabalibougou', 'commune': 'Commune V'},
    {'quartier': 'Bamako-Coura', 'commune': 'Commune III'},
    {'quartier': 'Fadjiguila', 'commune': 'Commune I'},
    {'quartier': 'Banconi', 'commune': 'Commune I'},
    {'quartier': 'Sebenikoro', 'commune': 'Commune IV'},
    {'quartier': 'Quinzambougou', 'commune': 'Commune II'},
    {'quartier': 'Magnambougou', 'commune': 'Commune VI'},
    {'quartier': 'Niamakoro', 'commune': 'Commune VI'},
    {'quartier': 'Missabougou', 'commune': 'Commune VI'},
    {'quartier': 'Faladie', 'commune': 'Commune VI'},
    {'quartier': 'Daoudabougou', 'commune': 'Commune V'},
    {'quartier': 'Sogoniko', 'commune': 'Commune VI'},
    {'quartier': 'Kalaban-Coura', 'commune': 'Commune V'},
    {'quartier': 'Sotuba', 'commune': 'Commune I'},
    {'quartier': 'N\'Tomikorobougou', 'commune': 'Commune III'},
    {'quartier': 'Djicoroni-Para', 'commune': 'Commune IV'},
    {'quartier': 'Korofina-Nord', 'commune': 'Commune I'},
    {'quartier': 'Korofina-Sud', 'commune': 'Commune I'},
    {'quartier': 'Sirakoro-Méguétana', 'commune': 'Commune VI'},
    {'quartier': 'Sabakabougou', 'commune': 'Commune VI'},
    {'quartier': 'Sokorodji', 'commune': 'Commune I'},
    {'quartier': 'Sabalibougou', 'commune': 'Commune V'},
    {'quartier': 'Koulouba', 'commune': 'Commune III'},
    {'quartier': 'Niamakoro', 'commune': 'Commune VI'},
    {'quartier': 'Point G', 'commune': 'Commune III'},
    {'quartier': 'Titibougou', 'commune': 'Commune VI'},
    {'quartier': 'Yirimadio', 'commune': 'Commune VI'},
    {'quartier': 'Sibiribougou', 'commune': 'Commune VI'},
    {'quartier': 'Sangarebougou', 'commune': 'Commune VI'},
    {'quartier': 'Niamana', 'commune': 'Commune VI'},
    {'quartier': 'Mountougoula', 'commune': 'Commune VI'},
    {'quartier': 'Diarrakou', 'commune': 'Commune V'},
    {'quartier': 'Kanadjiguila', 'commune': 'Commune V'},
    {'quartier': 'Banankabougou', 'commune': 'Commune VI'},
    {'quartier': 'Sebenikoro', 'commune': 'Commune IV'},
    {'quartier': 'Darsalam', 'commune': 'Commune III'},
    {'quartier': 'Medina-Coura', 'commune': 'Commune II'},
    {'quartier': 'Doumanzana', 'commune': 'Commune I'},
    {'quartier': 'Kalabancoura', 'commune': 'Commune V'},
    {'quartier': 'Mopti-Coura', 'commune': 'Commune III'},
    {'quartier': 'Mali', 'commune': 'Commune VI'},
    {'quartier': 'N\'Golonina', 'commune': 'Commune II'},
    {'quartier': 'Sikoroni', 'commune': 'Commune I'},
    {'quartier': 'Sotuba-ACI', 'commune': 'Commune I'},
    {'quartier': 'Banconi-Sokorodji', 'commune': 'Commune I'},
    {'quartier': 'Samaya', 'commune': 'Commune VI'},
    {'quartier': 'Tiébani', 'commune': 'Commune VI'},
    {'quartier': 'Tabakoro', 'commune': 'Commune VI'},
    {'quartier': 'Djalakorodji', 'commune': 'Commune VI'},
    {'quartier': 'Senou', 'commune': 'Commune VI'},
    {'quartier': 'Samanko', 'commune': 'Commune VI'},
    {'quartier': 'Noumorila', 'commune': 'Commune VI'},
    {'quartier': 'Moribabougou', 'commune': 'Commune VI'},
    {'quartier': 'Kalabambougou', 'commune': 'Commune VI'},
    {'quartier': 'N\'Gabacoro Droit', 'commune': 'Commune VI'},
    {'quartier': 'Kalanbancoura', 'commune': 'Commune VI'},
    {'quartier': 'Hipprodrome', 'commune': 'Commune II'},
    {'quartier': 'Missira', 'commune': 'Commune I'},
    {'quartier': 'Kalanbanbougou', 'commune': 'Commune VI'},
    {'quartier': 'Faladié', 'commune': 'Commune VI'},
    {'quartier': 'Banamba', 'commune': 'Commune VI'},
    {'quartier': 'Dio-Gare', 'commune': 'Commune VI'},
    {'quartier': 'Fadiga', 'commune': 'Commune I'},
    {'quartier': 'Fassougou', 'commune': 'Commune VI'},
  ];

  @override
  void initState() {
    super.initState();
    _loadShopInfo();
  }

  Future<void> _loadShopInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot shopDoc = await FirebaseFirestore.instance
          .collection('Shops')
          .doc(user.uid)
          .get();
      if (shopDoc.exists) {
        Map<String, dynamic>? data = shopDoc.data() as Map<String, dynamic>?;
        setState(() {
          _shopNameController.text = data?['name'] ?? '';
          _shopPhoneNumberController.text = data?['whatsappNumber'] ?? '';
          _shopAddressController.text = data?['address'] ?? '';
          _communeController.text = data?['commune'] ?? '';
          _descriptionController.text = data?['description'] ?? '';
          _selectedCategory = data?['category'] ?? '';
          _selectedPaymentMethods =
              List<String>.from(data?['paymentMethods'] ?? []);
          _shopLogoUrl = data?['logoUrl'];
          _shopLocation = data?['location'];
        });
      }
    }
  }

  Future<void> _updateShopInfo() async {
    if (_formKey.currentState?.validate() ?? false) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> shopData = {
          'name': _shopNameController.text.trim(),
          'whatsappNumber':
              '$_selectedCountryCode ${_shopPhoneNumberController.text.trim()}',
          'address': _shopAddressController.text.trim(),
          'commune': _communeController.text.trim(),
          'category': _selectedCategory,
          'description': _descriptionController.text.trim(),
          'paymentMethods': _selectedPaymentMethods,
          'location': _shopLocation,
        };
        if (_newLogo != null) {
          String logoUrl = await _uploadShopLogo(user.uid);
          shopData['logoUrl'] = logoUrl;
        }
        await FirebaseFirestore.instance
            .collection('Shops')
            .doc(user.uid)
            .update(shopData);
        setState(() {
          _isEditing = false;
        });
      }
    }
  }

  Future<String> _uploadShopLogo(String uid) async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child('shop_logos/$uid.jpg');
    await storageRef.putFile(_newLogo!);
    return await storageRef.getDownloadURL();
  }

  Future<void> _pickLogoImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newLogo = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information de la Boutique'),
        backgroundColor: Color(0xFFED1C24),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: _shopNameController.text.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _isEditing ? _pickLogoImage : null,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFFED1C24),
                              width: 3.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: _newLogo != null
                                ? FileImage(_newLogo!)
                                : _shopLogoUrl != null
                                    ? NetworkImage(_shopLogoUrl!)
                                    : AssetImage('assets/icons/shop_icon.png')
                                        as ImageProvider,
                            child: _isEditing
                                ? Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.edit,
                                          color: Color(0xFFED1C24)),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildInfoField('Nom de la Boutique',
                        controller: _shopNameController),
                    SizedBox(height: 10), // Added space between fields
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CountryCodePicker(
                            onChanged: (countryCode) {
                              setState(() {
                                _selectedCountryCode = countryCode.dialCode!;
                                _shopPhoneNumberController
                                    .clear(); // Clear the number field to avoid duplication
                              });
                            },
                            initialSelection: 'ML',
                            favorite: ['ML', 'SN', 'GH', 'FR' 'CI'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            textStyle: TextStyle(color: Color(0xFFED1C24)),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: _buildInfoField(
                            'Numéro de Téléphone',
                            controller: _shopPhoneNumberController,
                            inputType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // Additional space added
                    Autocomplete<Map<String, String>>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<Map<String, String>>.empty();
                        }
                        return quartiers.where((quartier) =>
                            quartier['quartier']!
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()));
                      },
                      displayStringForOption: (Map<String, String> option) =>
                          option['quartier']!,
                      onSelected: (Map<String, String> selection) {
                        _shopAddressController.text = selection['quartier']!;
                        _communeController.text = selection['commune']!;
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        return _buildInfoField(
                          'Adresse de la Boutique',
                          controller: fieldTextEditingController,
                        );
                      },
                    ),
                    SizedBox(height: 20), // Additional space added
                    _buildInfoField(
                      'Commune',
                      controller: _communeController,
                      enabled: false,
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.category, color: Color(0xFFED1C24)),
                        labelText: 'Catégorie',
                        labelStyle: TextStyle(color: Color(0xFFED1C24)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFED1C24)),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCategory.isNotEmpty
                          ? _selectedCategory
                          : null,
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: _isEditing
                          ? (value) {
                              setState(() {
                                _selectedCategory = value ?? '';
                              });
                            }
                          : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez sélectionner une catégorie';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _buildInfoField(
                      'Description',
                      controller: _descriptionController,
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Modes de paiement",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFED1C24)),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: paymentMethods.map((method) {
                        return FilterChip(
                          label: Text(method),
                          selected: _selectedPaymentMethods.contains(method),
                          selectedColor: Color(0xFFED1C24).withOpacity(0.7),
                          onSelected: _isEditing
                              ? (isSelected) {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedPaymentMethods.add(method);
                                    } else {
                                      _selectedPaymentMethods.remove(method);
                                    }
                                  });
                                }
                              : null,
                          backgroundColor: Colors.grey[200],
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    if (_isEditing)
                      ElevatedButton(
                        onPressed: _updateShopInfo,
                        child: Text('Enregistrer'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          backgroundColor: Color(0xFFED1C24),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    SizedBox(height: 20),
                    _buildMapSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoField(String label,
      {required TextEditingController controller,
      TextInputType inputType = TextInputType.text,
      bool enabled = true,
      int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      enabled: enabled && _isEditing,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFFED1C24)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFED1C24)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFED1C24)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFED1C24)),
        ),
        prefixIcon: label == 'Nom de la Boutique'
            ? Icon(Icons.store, color: Color(0xFFED1C24))
            : label == 'Numéro de Téléphone'
                ? Icon(Icons.phone, color: Color(0xFFED1C24))
                : label == 'Adresse de la Boutique'
                    ? Icon(Icons.location_on, color: Color(0xFFED1C24))
                    : label == 'Commune'
                        ? Icon(Icons.location_city, color: Color(0xFFED1C24))
                        : label == 'Description'
                            ? Icon(Icons.description, color: Color(0xFFED1C24))
                            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer $label';
        }
        return null;
      },
    );
  }

  Widget _buildMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Localisation de la Boutique',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFED1C24),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _shopLocation?.latitude ?? 0,
                  _shopLocation?.longitude ?? 0,
                ),
                zoom: 15,
              ),
              markers: {
                if (_shopLocation != null)
                  Marker(
                    markerId: MarkerId('shopLocation'),
                    position: LatLng(
                      _shopLocation!.latitude,
                      _shopLocation!.longitude,
                    ),
                    infoWindow: InfoWindow(title: _shopNameController.text),
                  ),
              },
            ),
          ),
        ),
      ],
    );
  }
}
