import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'vendor_registration_page.dart';
import 'user_congratulations_page.dart';
import 'sign.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _communeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isVendor = false;
  bool acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    {'quartier': 'Koulouba', 'commune': 'Commune III'},
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
    {'quartier': 'Darsalam', 'commune': 'Commune III'},
    {'quartier': 'Medina-Coura', 'commune': 'Commune II'},
    {'quartier': 'Doumanzana', 'commune': 'Commune I'},
    {'quartier': 'Kalabancoura', 'commune': 'Commune V'},
    {'quartier': 'Kalabancoura ACI', 'commune': 'Commune V'},
    {'quartier': 'Mopti-Coura', 'commune': 'Commune III'},
    {'quartier': 'Mali', 'commune': 'Commune VI'},
    {'quartier': 'N\'Golonina', 'commune': 'Commune II'},
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
    {'quartier': 'Hipprodrome', 'commune': 'Commune II'},
    {'quartier': 'Missira', 'commune': 'Commune I'},
    {'quartier': 'Kalanbanbougou', 'commune': 'Commune VI'},
    {'quartier': 'Banamba', 'commune': 'Commune VI'},
    {'quartier': 'Dio-Gare', 'commune': 'Commune VI'},
    {'quartier': 'Fadiga', 'commune': 'Commune I'},
    {'quartier': 'Fassougou', 'commune': 'Commune VI'},
    {'quartier': 'Kalaban Koro', 'commune': 'Commune VI'},
  ];

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _adresseController.dispose();
    _communeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Créer un utilisateur avec email et mot de passe
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Ajouter les informations utilisateur à Firestore
        await _firestore.collection('Users').doc(userCredential.user?.uid).set({
          'prenom': _prenomController.text.trim(),
          'nom': _nomController.text.trim(),
          'email': _emailController.text.trim(),
          'adresse': _adresseController.text.trim(),
          'commune': _communeController.text.trim(),
          'isVendor': isVendor,
          'phone': _phoneController.text.trim(),
        });

        if (isVendor) {
          // Rediriger vers la page d'enregistrement du vendeur
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VendorRegistrationPage(userId: userCredential.user?.uid),
            ),
          );
        } else {
          // Rediriger vers la page de félicitations utilisateur
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserCongratulationsPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Erreur inconnue')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conditions générales d\'utilisation'),
          content: SingleChildScrollView(
            child: Text(
              'Ici, vous pouvez inclure vos conditions générales d\'utilisation...',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFED1C24),
        title: Text(
          'Inscription',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _prenomController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Prénom',
                              labelStyle: TextStyle(
                                color: Color(0xFFED1C24),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFED1C24)),
                              ),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre prénom';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _nomController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Nom',
                              labelStyle: TextStyle(
                                color: Color(0xFFED1C24),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFED1C24)),
                              ),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre nom';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'Numéro Tél.',
                        labelStyle: TextStyle(color: Color(0xFFED1C24)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFED1C24)),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _PhoneNumberInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre numéro de téléphone';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color(0xFFED1C24)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFED1C24)),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre adresse email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Veuillez entrer une adresse email valide';
                        }
                        return null;
                      },
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
                        _adresseController.text = selection['quartier']!;
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
                            labelText: 'Adresse',
                            labelStyle: TextStyle(color: Color(0xFFED1C24)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFED1C24)),
                            ),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre adresse';
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
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Mot de Passe',
                        labelStyle: TextStyle(color: Color(0xFFED1C24)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFED1C24)),
                        ),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Confirmer le mot de passe',
                        labelStyle: TextStyle(color: Color(0xFFED1C24)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFED1C24)),
                        ),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez confirmer votre mot de passe';
                        }
                        if (value != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isVendor,
                          onChanged: (value) {
                            setState(() {
                              isVendor = value!;
                            });
                          },
                          activeColor: Color(0xFFED1C24),
                        ),
                        Text(
                          'Êtes-vous un Vendeur?',
                          style: TextStyle(
                            color: isVendor ? Color(0xFFED1C24) : Colors.black,
                          ),
                        ),
                      ],
                    ),
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
                          child: InkWell(
                            onTap: () => _showTermsAndConditions(context),
                            child: Text(
                              'J\'accepte vos conditions générales d\'utilisation',
                              style: TextStyle(
                                color: acceptTerms
                                    ? Color(0xFFED1C24)
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: acceptTerms ? _registerUser : null,
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text('S\'inscrire'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ou s\'inscrire avec'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/icons/Googleicon.png'),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Image.asset('assets/icons/Facebookicon.png'),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Image.asset('assets/icons/Appleicon.png'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Vous avez déjà un compte? '),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            'Se Connecter',
                            style: TextStyle(
                              color: Color(0xFFED1C24),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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

class _PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length <= 2) return newValue;
    StringBuffer newText = StringBuffer();
    for (int i = 0; i < text.length && i < 8; i++) {
      if (i != 0 && i % 2 == 0) newText.write('-');
      newText.write(text[i]);
    }
    return newValue.copyWith(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
