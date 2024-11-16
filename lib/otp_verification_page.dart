import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;

  const OTPVerificationPage({Key? key, required this.verificationId}) : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false; // Track loading state

  // Function to verify OTP
  void _verifyOTP() async {
    String otp = _otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    try {
      // Sign in the user with the OTP credential
      await _auth.signInWithCredential(credential);
      setState(() {
        _isLoading = false; // Stop loading
      });
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: "Enter OTP"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator() // Show loading spinner
                : ElevatedButton(
              onPressed: _verifyOTP,
              child: const Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
