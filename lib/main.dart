import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'firebase_options.dart';
import 'otp_verification_page.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OTP Verification',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
      // Custom route to pass the verificationId dynamically to OTPVerificationPage
      onGenerateRoute: (settings) {
        if (settings.name == '/otp-verification') {
          final verificationId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => OTPVerificationPage(verificationId: verificationId),
          );
        }
        return null;
      },
    );
  }
}
