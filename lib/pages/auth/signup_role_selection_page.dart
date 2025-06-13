// lib/pages/auth/signup_role_selection_page.dart
import 'package:flutter/material.dart';
import 'package:medi_sync_plus_app/pages/auth/signup_form_page.dart';
import 'dart:developer' as dev;

class SignUpRoleSelectionPage extends StatefulWidget {
  const SignUpRoleSelectionPage({super.key});

  @override
  State<SignUpRoleSelectionPage> createState() => _SignUpRoleSelectionPageState();
}

class _SignUpRoleSelectionPageState extends State<SignUpRoleSelectionPage> {
  String _selectedRole = 'patient'; // Default role

  void _navigateToSignUpForm() {
    dev.log("SignUpRoleSelectionPage: Role '$_selectedRole' selected. Navigating to SignUpFormPage.");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SignUpFormPage(selectedRole: _selectedRole),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Account Type'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'I want to sign up as a...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment<String>(value: 'patient', label: Text('Patient'), icon: Icon(Icons.person_search_outlined)),
                  ButtonSegment<String>(value: 'doctor', label: Text('Doctor'), icon: Icon(Icons.medical_services_outlined)),
                  ButtonSegment<String>(value: 'pharmacist', label: Text('Pharmacist'), icon: Icon(Icons.local_pharmacy_outlined)),
                ],
                selected: <String>{_selectedRole},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedRole = newSelection.first;
                  });
                  dev.log("SignUpRoleSelectionPage: Role selected: $_selectedRole");
                },
                 style: SegmentedButton.styleFrom(
                    selectedForegroundColor: Colors.white,
                    selectedBackgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 10) // Added padding
                  ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _navigateToSignUpForm,
                child: const Text('Next'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Go back to AuthPage (Login)
                },
                child: const Text('Already have an account? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}