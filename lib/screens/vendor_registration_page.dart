import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'VendorDetailsPage.dart';

class VendorRegistrationPage extends StatefulWidget {
  final String? userId; // Reçoit l'ID utilisateur

  VendorRegistrationPage({required this.userId}); // Constructeur avec userId

  @override
  _VendorRegistrationPageState createState() => _VendorRegistrationPageState();
}

class _VendorRegistrationPageState extends State<VendorRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _boutiqueNameController = TextEditingController();
  final TextEditingController _whatsappNumberController =
      TextEditingController();
  final TextEditingController _boutiqueAddressController =
      TextEditingController();
  final TextEditingController _communeController = TextEditingController();
  String _selectedCategory = '';
  String _selectedCountryCode = '+223'; // Mali par défaut
  bool acceptTerms = false;
  bool _isLoading = false;
  File? _logoImage; // Variable pour stocker l'image du logo

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
  void dispose() {
    _boutiqueNameController.dispose();
    _whatsappNumberController.dispose();
    _boutiqueAddressController.dispose();
    _communeController.dispose();
    super.dispose();
  }

  Future<void> _pickLogoImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // Optionnel: réduire la qualité de l'image
    );

    if (pickedImage != null &&
        (pickedImage.path.endsWith(".jpg") ||
            pickedImage.path.endsWith(".jpeg") ||
            pickedImage.path.endsWith(".png"))) {
      setState(() {
        _logoImage = File(pickedImage.path);
      });
    } else {
      // Gérer les cas où l'image n'est pas compatible
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Format d\'image non supporté.')),
      );
    }
  }

  Future<String?> _uploadLogoImage(String userId) async {
    if (_logoImage == null) return null;

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('logos/$userId.jpg');
      await storageRef.putFile(_logoImage!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading logo image: $e");
      return null;
    }
  }

  Future<void> _registerVendor() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Upload logo image and get the download URL
        String? logoUrl = await _uploadLogoImage(widget.userId!);

        // Save vendor shop information to Firestore
        await FirebaseFirestore.instance
            .collection('Shops')
            .doc(widget.userId)
            .set({
          'name': _boutiqueNameController.text.trim(),
          'whatsappNumber':
              '$_selectedCountryCode ${_whatsappNumberController.text.trim()}',
          'address': _boutiqueAddressController.text.trim(),
          'commune': _communeController.text.trim(),
          'category': _selectedCategory,
          'logoUrl': logoUrl ?? '',
        });

        // Navigate to VendorDetailsPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VendorDetailsPage(
              userId: widget.userId!,
              boutiqueName: _boutiqueNameController.text.trim(),
              whatsappNumber:
                  '$_selectedCountryCode ${_whatsappNumberController.text.trim()}',
              address: _boutiqueAddressController.text.trim(),
              commune: _communeController.text.trim(),
              category: _selectedCategory,
              logoUrl: logoUrl ?? '',
            ),
          ),
        );
      } catch (e) {
        print("Error during vendor registration: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur: Impossible de sauvegarder les données')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFED1C24),
        centerTitle: true,
        title: Text(
          'Enregistrement Boutique',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Image.asset(
                          'assets/icons/solar_shop-broken.png',
                          height: 100,
                          color: Color(0xFFED1C24),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Enregistrement Boutique de',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFED1C24)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _boutiqueNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.store, color: Color(0xFFED1C24)),
                        labelText: 'Nom de la Boutique',
                        labelStyle: TextStyle(color: Color(0xFFED1C24)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFED1C24)),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le nom de la boutique';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CountryCodePicker(
                            onChanged: (countryCode) {
                              setState(() {
                                _selectedCountryCode = countryCode.dialCode!;
                                _whatsappNumberController.clear();
                              });
                            },
                            initialSelection: 'ML',
                            favorite: ['ML', 'SN', 'GH', 'FR', 'CI'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            textStyle: TextStyle(color: Color(0xFFED1C24)),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _whatsappNumberController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.phone, color: Color(0xFFED1C24)),
                              labelText: 'Numéro Whatsapp',
                              labelStyle: TextStyle(color: Color(0xFFED1C24)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFED1C24)),
                              ),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              PhoneNumberInputFormatter(
                                  countryCode: _selectedCountryCode),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer le numéro Whatsapp';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
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
                        _boutiqueAddressController.text =
                            selection['quartier']!;
                        _communeController.text = selection['commune']!;
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextFormField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on),
                            labelText: 'Adresse de la Boutique',
                            labelStyle: TextStyle(color: Color(0xFFED1C24)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFED1C24)),
                            ),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer l\'adresse de la boutique';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _communeController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city),
                        labelText: 'Commune',
                        labelStyle: TextStyle(color: Color(0xFFED1C24)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFED1C24)),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                    SizedBox(height: 10),
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
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez sélectionner une catégorie';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickLogoImage,
                      child: Text('Importez le logo de la boutique'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFED1C24),
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 16),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                    ),
                    if (_logoImage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Image.file(
                          _logoImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              acceptTerms = value!;
                            });
                          },
                          activeColor: Color(0xFFED1C24),
                        ),
                        Flexible(
                          child: Text(
                            'J\'accepte les conditions générales d\'utilisation',
                            style: TextStyle(
                                color: acceptTerms
                                    ? Color(0xFFED1C24)
                                    : Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: acceptTerms ? _registerVendor : null,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Continuer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFED1C24),
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        disabledBackgroundColor: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  final String countryCode;

  PhoneNumberInputFormatter({required this.countryCode});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    StringBuffer newText = StringBuffer();
    if (countryCode == '+223') {
      for (int i = 0; i < text.length && i < 8; i++) {
        if (i != 0 && i % 2 == 0) newText.write('-');
        newText.write(text[i]);
      }
    } else if (countryCode == '+225') {
      newText.write(' ');
      for (int i = 0; i < text.length && i < 10; i++) {
        if (i == 2 || i == 4 || i == 6) newText.write(' ');
        newText.write(text[i]);
      }
    } else {
      newText.write(text);
    }

    return newValue.copyWith(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
