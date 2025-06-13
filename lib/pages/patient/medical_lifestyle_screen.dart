import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalLifestyleScreen extends StatefulWidget {
  const MedicalLifestyleScreen({super.key});

  @override
  State<MedicalLifestyleScreen> createState() => _MedicalLifestyleScreenState();
}

class _MedicalLifestyleScreenState extends State<MedicalLifestyleScreen> {
  final Color primaryGreen = const Color(0xFF4CAF50);

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  late TextEditingController _occupationController;

  // Lifestyle data
  Map<String, String> lifestyleData = {
    'Smoking Habits': 'Select',
    'Alcohol Consumption': 'Select',
    'Activity Level': 'Select',
    'Food Preference': 'Select',
    'Occupation': '',
    'Sleep Pattern': 'Select',
  };

  // Dropdown options
  final Map<String, List<String>> _dropdownOptions = {
    'Smoking Habits': ['Select', 'None', 'Occasionally', 'Regularly'],
    'Alcohol Consumption': ['Select', 'None', 'Occasionally', 'Regularly'],
    'Activity Level': ['Select', 'Sedentary', 'Light', 'Moderate', 'Active'],
    'Food Preference': ['Select', 'Vegetarian', 'Non-Vegetarian', 'Vegan'],
    'Sleep Pattern': ['Select', 'Normal', 'Irregular', 'Poor'],
  };

  @override
  void initState() {
    super.initState();
    _occupationController = TextEditingController(text: lifestyleData['Occupation']);
    _fetchLifestyleFromFirestore();
  }

  @override
  void dispose() {
    _occupationController.dispose();
    super.dispose();
  }

  // Fetch lifestyle data from Firestore
  Future<void> _fetchLifestyleFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc['lifestyle'] != null && mounted) {
        setState(() {
          Map<String, dynamic> fetchedData = doc['lifestyle'] as Map<String, dynamic>;
          lifestyleData = {
            'Smoking Habits': fetchedData['Smoking Habits'] ?? 'Select',
            'Alcohol Consumption': fetchedData['Alcohol Consumption'] ?? 'Select',
            'Activity Level': fetchedData['Activity Level'] ?? 'Select',
            'Food Preference': fetchedData['Food Preference'] ?? 'Select',
            'Occupation': fetchedData['Occupation'] ?? '',
            'Sleep Pattern': fetchedData['Sleep Pattern'] ?? 'Select',
          };
          _occupationController.text = lifestyleData['Occupation']!;
        });
      }
    }
  }

  // Save lifestyle data to Firestore
  Future<void> _saveLifestyleToFirestore() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please log in to save lifestyle data')),
            );
          }
          return;
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'lifestyle': lifestyleData,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lifestyle updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating lifestyle: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medical & Lifestyle',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Lifestyle',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: lifestyleData.entries.map((entry) {
                  return _buildLifestyleItem(entry.key, entry.value);
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _editLifestyle(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Edit Lifestyle',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifestyleItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value == 'Select' ? 'Not Set' : value,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: value == 'Select' ? Colors.grey[400] : Colors.grey[700],
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
        ],
      ),
    );
  }

  void _editLifestyle(BuildContext context) {
    // Update occupation controller
    _occupationController.text = lifestyleData['Occupation']!;

    // Create a local copy of lifestyle data for editing
    Map<String, String> tempLifestyleData = Map.from(lifestyleData);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Lifestyle',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: lifestyleData.keys.map((key) {
                if (key == 'Occupation') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: _occupationController,
                      decoration: InputDecoration(
                        labelText: key,
                        hintText: 'Enter your occupation',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryGreen, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                      style: GoogleFonts.nunito(fontSize: 16),
                      validator: (value) => value!.isEmpty ? 'Please enter your occupation' : null,
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DropdownButtonFormField<String>(
                      value: tempLifestyleData[key],
                      items: _dropdownOptions[key]!
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    color: item == 'Select' ? Colors.grey[400] : Colors.black,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        tempLifestyleData[key] = value!;
                      },
                      decoration: InputDecoration(
                        labelText: key,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryGreen, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                      validator: (value) => value == 'Select' ? 'Please select an option' : null,
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    ),
                  );
                }
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.nunito()),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  lifestyleData = Map.from(tempLifestyleData);
                  lifestyleData['Occupation'] = _occupationController.text;
                });
                Navigator.pop(context);
                _saveLifestyleToFirestore();
              }
            },
            child: Text('Save', style: GoogleFonts.nunito(color: primaryGreen)),
          ),
        ],
      ),
    );
  }
}