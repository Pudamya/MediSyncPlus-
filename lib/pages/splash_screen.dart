// lib/pages/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medi_sync_plus_app/pages/auth/auth_page.dart'; // Navigate to new AuthPage
// Import your dashboard pages if you do direct navigation from splash
import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart';
import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart';
// import 'package:medi_sync_plus_app/pages/pharmacist/pharmacist_dashboard.dart';
import 'package:provider/provider.dart';
import 'package:medi_sync_plus_app/providers/patient_provider.dart';
import 'dart:developer' as dev;


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Your splash delay

    if (!mounted) return;

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      dev.log("SplashScreen: User already logged in: ${currentUser.uid}. Fetching role...");
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          var userData = userDoc.data() as Map<String, dynamic>;
          String role = (userData['role'] as String? ?? 'patient').trim().toLowerCase();
          dev.log("SplashScreen: User role from DB: '$role'. Navigating to dashboard.");
           _navigateToDashboard(role, currentUser.uid, userData);
        } else {
          dev.log("SplashScreen: User document not found for already logged-in user. Navigating to AuthPage.");
          // User might have been deleted from DB but auth session still active
          await FirebaseAuth.instance.signOut(); // Clear inconsistent state
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const AuthPage()));
        }
      } catch (e) {
        dev.log("SplashScreen: Error fetching user role for already logged-in user: $e. Navigating to AuthPage.");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const AuthPage()));
      }
    } else {
      dev.log("SplashScreen: No user logged in. Navigating to AuthPage.");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AuthPage()));
    }
  }

  void _navigateToDashboard(String role, String uid, Map<String, dynamic> userData) {
    Widget nextPage;
    String userName = userData['fullName'] as String? ?? userData['name'] as String? ?? uid;

    switch (role) {
      case 'patient':
        nextPage = ChangeNotifierProvider(
          create: (_) => PatientProvider()..setPatientId(uid),
          child: const PatientHomeScreen(),
        );
        break;
      case 'doctor':
        nextPage = DoctorAppointmentsPage(
          doctorId: uid,
          doctorName: userName,
        );
        break;
      case 'pharmacist':
        nextPage = Scaffold(body: Center(child: Text('Pharmacist Dashboard for $userName (UID: $uid)')));
        break;
      default:
        // Fallback to login page if role is somehow unknown after signup
        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => const AuthPage()));
        return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => nextPage));
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Theme.of(context).colorScheme.primaryContainer, // Or your desired splash background
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           // Replace with your logo or splash image
  //           Icon(Icons.medical_services, size: 100, color: Theme.of(context).primaryColor),
  //           const SizedBox(height: 20),
  //           Text(
  //             'MediSync+',
  //             style: TextStyle(
  //               fontSize: 32,
  //               fontWeight: FontWeight.bold,
  //               color: Theme.of(context).primaryColor,
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           const Text(
  //             'Your Health, Synchronized.',
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.black54,
  //             ),
  //           ),
  //           const SizedBox(height: 40),
  //           CircularProgressIndicator(
  //             valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }



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