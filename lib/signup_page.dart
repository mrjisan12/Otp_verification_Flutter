import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false; // Track loading state

  // Function to send OTP
  void _sendOTP() async {
    String phoneNumber = _phoneController.text.trim();

    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+$phoneNumber'; // Add "+" if not present
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto sign-in if OTP arrives on the same phone
          await _auth.signInWithCredential(credential);
          setState(() {
            _isLoading = false; // Stop loading
          });
          Navigator.pushReplacementNamed(context, '/home');
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false; // Stop loading
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false; // Stop loading
          });
          Navigator.pushNamed(
            context,
            '/otp-verification',
            arguments: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _isLoading = false; // Stop loading
          });
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixText: "+",
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator() // Show loading spinner
                : ElevatedButton(
              onPressed: _sendOTP,
              child: const Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
