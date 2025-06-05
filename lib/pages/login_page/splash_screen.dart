
import 'dart:async';
import 'package:flutter/material.dart';
import 'role_login_page.dart'; // Navigates to RoleLoginPage

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () { // Splash screen duration
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RoleLoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 210, 156), // Slightly adjusted green
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Make sure 'assets/images/my_logo.png' exists and is in pubspec.yaml
            Image.asset(
              'assets/images/logo_full_size.png', // Replace with your actual image path
              width: 350, // Adjusted size
              height: 350,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image fails to load
                return Icon(Icons.local_hospital, size: 100, color: Colors.white.withOpacity(0.8));
              },
            ),


            //text medisynplus
            // const SizedBox(height: 24),
            // Text(
            //   'MediSyncPlus',
            //   style: TextStyle(
            //     fontSize: 28, // Adjusted size
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //     letterSpacing: 1.2,
            //   ),
            // ),

            const SizedBox(height: 16),
            Text(
              'Your Health, Synchronized.', // Example tagline
              style: TextStyle(
                fontSize: 16,
                color: const Color.fromARGB(255, 26, 25, 25).withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.9)),
              strokeWidth: 3.0,
            ),
          ],
        ),
      ),
    );
  }
}




