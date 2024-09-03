import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final bool isVendor;
  final String verificationId;

  OtpVerificationPage({
    required this.phoneNumber,
    required this.isVendor,
    required this.verificationId,
  });

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isVerifying = false;
  bool _otpSent = true;

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer le code OTP.')),
      );
      return;
    }

    try {
      setState(() {
        _isVerifying = true;
      });

      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text.trim(),
      );

      await _auth.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie')),
      );

      // Rediriger vers une autre page après la vérification réussie
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Erreur de vérification OTP')),
      );
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  Future<void> _sendOtp() async {
    setState(() {
      _otpSent = false;
      _isVerifying = true;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-sign in si le code est automatiquement détecté
        await _auth.signInWithCredential(credential);
        setState(() {
          _isVerifying = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isVerifying = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Erreur inconnue')));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          widget.verificationId;
          _otpSent = true;
          _isVerifying = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          widget.verificationId;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFED1C24),
        title: Text('Vérification OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nous avons envoyé le code de vérification à votre numéro de téléphone portable.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              widget.phoneNumber,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _otpSent
                ? TextField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Entrez le code OTP',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            _isVerifying
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    child: Text('Vérifiez'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFED1C24),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
            TextButton(
              onPressed: _sendOtp,
              child: Text(
                'Vous n\'avez pas reçu le code ? Renvoyez le code',
                style: TextStyle(color: Color(0xFFED1C24)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
