// lib/pages/auth/signup_form_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medi_sync_plus_app/pages/auth/login_form_widget.dart';
import 'package:medi_sync_plus_app/services/firestore_services.dart'; // Assuming your addDoctor etc. are here
import 'package:medi_sync_plus_app/pages/auth/auth_page.dart'; // To navigate back to login after signup
// Import dashboard pages for navigation after successful signup
import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart';
import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart';
// import 'package:medi_sync_plus_app/pages/pharmacist/pharmacist_dashboard.dart';
import 'package:provider/provider.dart';
import 'package:medi_sync_plus_app/providers/patient_provider.dart';
import 'dart:developer' as dev;


class SignUpFormPage extends StatefulWidget {
  final String selectedRole;
  const SignUpFormPage({super.key, required this.selectedRole});

  @override
  State<SignUpFormPage> createState() => _SignUpFormPageState();
}

class _SignUpFormPageState extends State<SignUpFormPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoadingPage = false;
  String? _errorMessage;

  Future<void> _handleSignUp(String email, String password) async {
    final String roleForAuth = widget.selectedRole.trim().toLowerCase();

    if (!mounted) return;
    setState(() {
      _isLoadingPage = true;
      _errorMessage = null;
    });
    dev.log("SignUpFormPage: Sign Up attempt. Email: $email, Role: '$roleForAuth'");

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      dev.log("SignUpFormPage: Sign Up successful, creating user document for UID: ${userCredential.user!.uid}");
      final String defaultNameFromEmail = email.split('@')[0];
      
      Map<String, dynamic> userData = {
        'email': email,
        'role': roleForAuth,
        'fullName': defaultNameFromEmail, // Users can update this later in their profile
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);
      dev.log("SignUpFormPage: User document created in 'users' collection with role: '$roleForAuth'.");

      // Additional setup based on role
      if (roleForAuth == 'doctor') {
        dev.log("SignUpFormPage: Signing up as Doctor, adding to 'doctors' collection.");
        final firestoreService = FirestoreService(); // Ensure this service is correctly implemented
        await firestoreService.addDoctor(
          userCredential.user!.uid, // This UID should be the doctorId
          email,
          defaultNameFromEmail, // Initial full name
          'generalMedicine', // TODO: Allow doctor to select specialty later or provide a default
          '', // Placeholder for phone number
          '', // Placeholder for affiliatedHospitals (empty string)
        );
        dev.log("SignUpFormPage: Doctor placeholder added to 'doctors' collection.");
      } else if (roleForAuth == 'pharmacist') {
        // TODO: Add similar logic for pharmacist collection if needed
        dev.log("SignUpFormPage: Placeholder for Pharmacist specific collection setup.");
      }

      if (!mounted) return;

      // Show success and navigate to login or directly to dashboard
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully for $email as a $roleForAuth! Please login.'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate back to the main AuthPage (login screen) after successful signup
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthPage()),
        (route) => false, // Remove all previous routes
      );
      // Alternatively, you could navigate them directly to their dashboard:
      // _navigateToDashboard(roleForAuth, userCredential.user!.uid, userData);


    } on FirebaseAuthException catch (e) {
      dev.log("SignUpFormPage: FirebaseAuthException during sign up: ${e.code} - ${e.message}");
      if (mounted) {
        setState(() {
          if (e.code == 'email-already-in-use') {
            _errorMessage = 'An account already exists for that email.';
          } else if (e.code == 'weak-password') {
            _errorMessage = 'Password must be at least 6 characters long.';
          } else {
            _errorMessage = e.message ?? 'An error occurred during sign up.';
          }
        });
      }
    } catch (e) {
      dev.log("SignUpFormPage: Generic error during sign up: $e");
      if (mounted) {
        setState(() {
          _errorMessage = 'An unexpected error occurred: ${e.toString().replaceAll("Exception: ", "")}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingPage = false;
        });
      }
    }
  }

  // Optional: If you want to navigate directly to dashboard after signup
  void _navigateToDashboard(String role, String uid, Map<String, dynamic> userData) {
    dev.log("SignUpFormPage: Navigating to dashboard for role '$role', UID: $uid");
    Widget nextPage;
    String userName = userData['fullName'] as String? ?? uid;

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
        Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => const AuthPage()), (route) => false);
        return;
    }
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => nextPage), (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up as ${widget.selectedRole.capitalize()}'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    'Create your ${widget.selectedRole.capitalize()} account',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  LoginFormWidget( // Reusing for the form fields
                    isLoginMode: false, // This is for Sign Up
                    onSubmit: _handleSignUp,
                    // No onToggleToSignUp needed here
                    onToggleToLogin: () { // Option to go back to main login page
                       Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const AuthPage()),
                        (route) => false,
                      );
                    }
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
           if (_isLoadingPage)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.1),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

// Helper extension for capitalizing strings
extension StringExtension on String {
    String capitalize() {
      if (isEmpty) return this;
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}