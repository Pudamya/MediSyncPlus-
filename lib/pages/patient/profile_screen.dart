// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isEditing = false;

//   // Form data
//   String _name = 'Priya Sharma';
//   String _email = 'priya@example.com';
//   String _phone = '+91 98765 43210';
//   DateTime _dob = DateTime(1995, 3, 15); // Default DOB from hardcoded data
//   String _address = '123, Green Lane, Mumbai, India';
//   String _gender = 'Female';
//   String _emergencyContact = '+91 91234 56789';
//   String _insuranceProvider = 'MediCare Plus';
//   String _policyNumber = 'MC123456789';
//   String _preferredLanguage = 'English'; // Added for language management

//   void _saveForm() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       setState(() {
//         _isEditing = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile saved successfully!')),
//       );
//     }
//   }

//   void _changePassword() {
//     final currentPasswordController = TextEditingController();
//     final newPasswordController = TextEditingController();
//     final confirmPasswordController = TextEditingController();

//     // Hardcoded current password for simulation
//     const String hardcodedPassword = 'password123';

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Change Password', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: currentPasswordController,
//               decoration: const InputDecoration(labelText: 'Current Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: newPasswordController,
//               decoration: const InputDecoration(labelText: 'New Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: confirmPasswordController,
//               decoration: const InputDecoration(labelText: 'Confirm New Password'),
//               obscureText: true,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel', style: GoogleFonts.nunito()),
//           ),
//           TextButton(
//             onPressed: () {
//               if (currentPasswordController.text != hardcodedPassword) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Incorrect current password')),
//                 );
//                 return;
//               }
//               if (newPasswordController.text != confirmPasswordController.text) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('New passwords do not match')),
//                 );
//                 return;
//               }
//               if (newPasswordController.text.length < 6) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('New password must be at least 6 characters')),
//                 );
//                 return;
//               }
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Password changed successfully!')),
//               );
//             },
//             child: Text('Save', style: GoogleFonts.nunito()),
//           ),
//         ],
//       ),
//     );
//   }

//   void _manageLanguages() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Manage Languages', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
//         content: DropdownButton<String>(
//           value: _preferredLanguage,
//           items: const [
//             DropdownMenuItem(value: 'English', child: Text('English')),
//             DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
//             DropdownMenuItem(value: 'Tamil', child: Text('Tamil')),
//           ],
//           onChanged: (value) {
//             if (value != null) {
//               setState(() {
//                 _preferredLanguage = value;
//               });
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Language updated successfully!')),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 76, 175, 80),
//         title: Text(
//           'Profile',
//           style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Profile Header
//             Container(
//               padding: const EdgeInsets.all(16),
//               color: const Color.fromARGB(255, 76, 175, 80),
//               child: Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.white,
//                     child: Icon(
//                       Icons.person,
//                       size: 40,
//                       color: Color.fromARGB(255, 76, 175, 80),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _name,
//                         style: GoogleFonts.nunito(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         _email,
//                         style: GoogleFonts.nunito(
//                           fontSize: 16,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Edit/Save Button
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _isEditing = !_isEditing;
//                     });
//                     if (!_isEditing) _saveForm();
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 76, 175, 80)),
//                   child: Text(
//                     _isEditing ? 'Save' : 'Edit',
//                     style: GoogleFonts.nunito(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//             // User Information Section
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 'User Information',
//                 style: GoogleFonts.nunito(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 76, 175, 80),
//                 ),
//               ),
//             ),
//             _buildInfoCard(
//               context,
//               children: [
//                 _buildTextField(
//                   label: 'Name',
//                   initialValue: _name,
//                   onSaved: (value) => _name = value!,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Please enter your name';
//                     return null;
//                   },
//                 ),
//                 _buildTextField(
//                   label: 'Email',
//                   initialValue: _email,
//                   onSaved: (value) => _email = value!,
//                   validator: (value) {
//                     if (value == null || !value.contains('@')) return 'Please enter a valid email';
//                     return null;
//                   },
//                 ),
//                 _buildTextField(
//                   label: 'Phone Number',
//                   initialValue: _phone,
//                   onSaved: (value) => _phone = value!,
//                   validator: (value) {
//                     if (value == null || value.length < 10) return 'Please enter a valid phone number';
//                     return null;
//                   },
//                 ),
//                 _buildDateField(
//                   label: 'Date of Birth',
//                   selectedDate: _dob,
//                   onChanged: (value) => setState(() => _dob = value),
//                 ),
//                 _buildTextField(
//                   label: 'Address',
//                   initialValue: _address,
//                   onSaved: (value) => _address = value!,
//                 ),
//               ],
//             ),
//             // Personal Details Section
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 'Personal Details',
//                 style: GoogleFonts.nunito(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 76, 175, 80),
//                 ),
//               ),
//             ),
//             _buildInfoCard(
//               context,
//               children: [
//                 _buildDropdownField(
//                   label: 'Gender',
//                   value: _gender,
//                   items: const ['Female', 'Male', 'Other'],
//                   onChanged: (value) => setState(() => _gender = value!),
//                 ),
//                 _buildTextField(
//                   label: 'Emergency Contact',
//                   initialValue: _emergencyContact,
//                   onSaved: (value) => _emergencyContact = value!,
//                   validator: (value) {
//                     if (value != null && value.length < 10) return 'Please enter a valid phone number';
//                     return null;
//                   },
//                 ),
//               ],
//             ),
//             // Insurance Info Section
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 'Insurance Info',
//                 style: GoogleFonts.nunito(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 76, 175, 80),
//                 ),
//               ),
//             ),
//             _buildInfoCard(
//               context,
//               children: [
//                 _buildDropdownField(
//                   label: 'Insurance Provider',
//                   value: _insuranceProvider,
//                   items: const ['MediCare Plus', 'HealthGuard', 'InsureLife'],
//                   onChanged: (value) => setState(() => _insuranceProvider = value!),
//                 ),
//                 _buildTextField(
//                   label: 'Policy Number',
//                   initialValue: _policyNumber,
//                   onSaved: (value) => _policyNumber = value!,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Please enter a policy number';
//                     return null;
//                   },
//                 ),
//               ],
//             ),
//             // Settings & Security Section
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 'Settings & Security',
//                 style: GoogleFonts.nunito(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 76, 175, 80),
//                 ),
//               ),
//             ),
//             _buildInfoCard(
//               context,
//               children: [
//                 const Divider(height: 1, color: Colors.grey),
//                 _buildSettingsItem(
//                   context,
//                   icon: Icons.lock,
//                   title: 'Change Password',
//                   onTap: _changePassword,
//                 ),
//                 const Divider(height: 1, color: Colors.grey),
//                 _buildSettingsItem(
//                   context,
//                   icon: Icons.language,
//                   title: 'Manage Languages',
//                   onTap: _manageLanguages,
//                 ),
//                 const Divider(height: 1, color: Colors.grey),
//                 _buildSettingsItem(
//                   context,
//                   icon: Icons.devices,
//                   title: 'Device Access Logs',
//                   onTap: () {
//                     // TODO: Implement Device Access Logs
//                   },
//                 ),
//                 const Divider(height: 1, color: Colors.grey),
//                 _buildSettingsItem(
//                   context,
//                   icon: Icons.download,
//                   title: 'Export Health Record (ZIP/PDF)',
//                   onTap: () {
//                     // TODO: Implement Export Health Record
//                   },
//                 ),
//                 const Divider(height: 1, color: Colors.grey),
//                 _buildSettingsItem(
//                   context,
//                   icon: Icons.logout,
//                   title: 'Logout',
//                   onTap: () {
//                     // TODO: Implement Logout
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard(BuildContext context, {required List<Widget> children}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withAlpha(51),
//             spreadRadius: 2,
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: children,
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     String? initialValue,
//     String? Function(String?)? validator,
//     void Function(String?)? onSaved,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         initialValue: _isEditing ? initialValue : null,
//         enabled: _isEditing,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         validator: validator,
//         onSaved: onSaved,
//       ),
//     );
//   }

//   Widget _buildDateField({
//     required String label,
//     required DateTime selectedDate,
//     required ValueChanged<DateTime> onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         child: Row(
//           children: [
//             Text(
//               '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
//               style: GoogleFonts.nunito(),
//             ),
//             IconButton(
//               icon: const Icon(Icons.calendar_today),
//               onPressed: _isEditing
//                   ? () async {
//                       if (!mounted) return;
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: selectedDate,
//                         firstDate: DateTime(1900),
//                         lastDate: DateTime.now(),
//                       );
//                       if (picked != null && mounted) {
//                         onChanged(picked);
//                       }
//                     }
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownField({
//     required String label,
//     required String value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: _isEditing ? value : null,
//             items: items.map((String item) {
//               return DropdownMenuItem<String>(
//                 value: item,
//                 child: Text(item, style: GoogleFonts.nunito()),
//               );
//             }).toList(),
//             onChanged: _isEditing ? onChanged : null,
//             isExpanded: true,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingsItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         child: Row(
//           children: [
//             Icon(icon, size: 24, color: const Color.fromARGB(255, 76, 175, 80)),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: GoogleFonts.nunito(
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//     ),
// );
// }
// }































// // lib/pages/profile/profile_screen.dart (or your chosen path)
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';
// import 'dart:developer' as dev; // For logging

// // Assuming AuthPage is in this path, adjust if necessary
// import 'package:medi_sync_plus_app/pages/auth/auth_page.dart'; 
// // Assuming MedicalLifestyleScreen is in this path, adjust if necessary
// // import 'medical_lifestyle_screen.dart'; // You had this, ensure path is correct

// // Placeholder for MedicalLifestyleScreen if not fully implemented yet or path is different
// class MedicalLifestyleScreen extends StatelessWidget {
//   const MedicalLifestyleScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar(title: const Text('Medical & Lifestyle')), body: const Center(child: Text('Medical & Lifestyle Screen Content')));
//   }
// }


// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final Color primaryGreen = const Color(0xFF4CAF50); // Or your theme's primary color
//   // bool _showProfileDetails = false; // This variable doesn't seem to be used in your new UI logic for toggling view
//   bool _showGuardianFields = false;

//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _mobileController;
//   late TextEditingController _emailController; // Will be read-only from Auth
//   late TextEditingController _dobController;
//   late TextEditingController _emergencyContactController;
//   late TextEditingController _nicController;
//   late TextEditingController _addressController;
  
//   late TextEditingController _guardianFirstNameController;
//   late TextEditingController _guardianLastNameController;
//   late TextEditingController _guardianMobileController;
//   late TextEditingController _guardianNicController;
//   late TextEditingController _guardianAddressController;
//   // Removed _guardianRelationshipController, as it's handled by _guardianRelationship string state

//   String _gender = 'Select';
//   String _maritalStatus = 'Select';
//   String _location = 'Select';
//   String? _profileImageUrl;
  
//   String _guardianRelationship = 'Select';
//   String _guardianGender = 'Select';

//   File? _profileImage;

//   final List<String> _genderOptions = ['Select', 'Male', 'Female', 'Other'];
//   final List<String> _maritalStatusOptions = ['Select', 'Single', 'Married', 'Divorced', 'Widowed'];
//   final List<String> _relationshipOptions = ['Select', 'Parent', 'Guardian', 'Sibling', 'Other'];
//   final List<String> _locationOptions = [
//     'Select', 'Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo', 
//     'Galle', 'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara', 'Kandy', 'Kegalle', 
//     'Kilinochchi', 'Kurunegala', 'Mannar', 'Matale', 'Matara', 'Monaragala', 
//     'Mullaitivu', 'Nuwara Eliya', 'Polonnaruwa', 'Puttalam', 'Ratnapura', 
//     'Trincomalee', 'Vavuniya'
//   ];

//   bool _isLoading = true; // For initial data fetch

//   @override
//   void initState() {
//     super.initState();
//     _firstNameController = TextEditingController();
//     _lastNameController = TextEditingController();
//     _mobileController = TextEditingController();
//     _emailController = TextEditingController();
//     _dobController = TextEditingController();
//     _emergencyContactController = TextEditingController();
//     _nicController = TextEditingController();
//     _addressController = TextEditingController();
    
//     _guardianFirstNameController = TextEditingController();
//     _guardianLastNameController = TextEditingController();
//     _guardianMobileController = TextEditingController();
//     _guardianNicController = TextEditingController();
//     _guardianAddressController = TextEditingController();
//     // _guardianRelationshipController was removed, direct string state _guardianRelationship is used
    
//     _fetchProfileFromFirestore();
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _dobController.dispose();
//     _emergencyContactController.dispose();
//     _nicController.dispose();
//     _addressController.dispose();
//     _guardianFirstNameController.dispose();
//     _guardianLastNameController.dispose();
//     _guardianMobileController.dispose();
//     _guardianNicController.dispose();
//     _guardianAddressController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchProfileFromFirestore() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//         if (doc.exists && mounted) {
//           final data = doc.data() as Map<String, dynamic>;
//           setState(() {
//             _firstNameController.text = data['firstName'] ?? '';
//             _lastNameController.text = data['lastName'] ?? '';
//             _mobileController.text = data['mobile'] ?? '';
//             _emailController.text = data['email'] ?? user.email ?? ''; // Prioritize DB, then Auth email
//             _dobController.text = data['dob'] ?? '';
//             _emergencyContactController.text = data['emergencyContact'] ?? '';
//             _nicController.text = data['nic'] ?? '';
//             _addressController.text = data['address'] ?? '';
//             _gender = data['gender'] ?? 'Select';
//             _maritalStatus = data['maritalStatus'] ?? 'Select';
//             _location = data['location'] ?? 'Select';
//             _profileImageUrl = data['profileImageUrl'];
            
//             _guardianFirstNameController.text = data['guardianFirstName'] ?? '';
//             _guardianLastNameController.text = data['guardianLastName'] ?? '';
//             _guardianMobileController.text = data['guardianMobile'] ?? '';
//             _guardianNicController.text = data['guardianNic'] ?? '';
//             _guardianAddressController.text = data['guardianAddress'] ?? '';
//             _guardianRelationship = data['guardianRelationship'] ?? 'Select';
//             _guardianGender = data['guardianGender'] ?? 'Select';
            
//             if (data['dob'] != null && (data['dob'] as String).isNotEmpty) {
//               try {
//                   DateTime dobDate = DateFormat('dd/MM/yyyy').parse(data['dob']);
//                   DateTime now = DateTime.now();
//                   int age = now.year - dobDate.year;
//                   if (now.month < dobDate.month || (now.month == dobDate.month && now.day < dobDate.day)) {
//                     age--;
//                   }
//                   _showGuardianFields = age < 18;
//               } catch (e) {
//                   dev.log("Error parsing DOB from Firestore: ${data['dob']} - $e");
//                   _showGuardianFields = false; // Default if DOB is invalid
//               }
//             } else {
//                 _showGuardianFields = false; // Default if DOB is not set
//             }
//           });
//         } else {
//            dev.log("User document does not exist for UID: ${user.uid}");
//            // Set email from Auth if document doesn't exist yet (e.g., new Google Sign-In)
//            if(mounted) {
//              setState(() {
//                 _emailController.text = user.email ?? '';
//              });
//            }
//         }
//       } catch (e) {
//         dev.log("Error fetching profile: $e");
//         if(mounted) _showSnackBar("Error loading profile: $e", isError: true);
//       }
//     } else {
//       dev.log("No current user found for fetching profile.");
//        if(mounted) _showSnackBar("Not logged in. Cannot load profile.", isError: true);
//     }
//     if (mounted) setState(() => _isLoading = false);
//   }

//   Future<void> _pickImage() async {
//     // ... (Your existing _pickImage logic is good)
//     final picker = ImagePicker();
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Select Image Source',
//           style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: Text('Gallery', style: GoogleFonts.nunito()),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//                 if (pickedFile != null && mounted) {
//                   setState(() {
//                     _profileImage = File(pickedFile.path);
//                   });
//                 }
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: Text('Camera', style: GoogleFonts.nunito()),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final pickedFile = await picker.pickImage(source: ImageSource.camera);
//                 if (pickedFile != null && mounted) {
//                   setState(() {
//                     _profileImage = File(pickedFile.path);
//                   });
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<String?> _uploadImageToStorage() async {
//     // ... (Your existing _uploadImageToStorage logic is good)
//     if (_profileImage == null) return _profileImageUrl; // Return current if no new image
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) return _profileImageUrl; // Cannot upload if not logged in

//     try {
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('profile_pics')
//           .child('${user.uid}.jpg'); // Use user UID for unique image name
//       await ref.putFile(_profileImage!);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       dev.log("Error uploading image: $e");
//       if (mounted) _showSnackBar('Error uploading image: $e', isError: true);
//       return _profileImageUrl; // Return old URL on error
//     }
//   }

//   Future<void> _saveProfileToFirestore() async {
//     if (!_formKey.currentState!.validate()) {
//       _showSnackBar('Please correct the errors in the form.', isError: true);
//       return;
//     }
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       _showSnackBar('Please log in to save profile.', isError: true);
//       return;
//     }

//     setState(() => _isLoading = true); // Show loading indicator

//     try {
//       String? imageUrl = await _uploadImageToStorage(); // Upload image first

//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//         'firstName': _firstNameController.text.trim(),
//         'lastName': _lastNameController.text.trim(),
//         'mobile': _mobileController.text.trim(),
//         'email': _emailController.text.trim(), // Usually not editable here, fetched from Auth
//         'dob': _dobController.text.trim(),
//         'gender': _gender == 'Select' ? null : _gender,
//         'maritalStatus': _maritalStatus == 'Select' ? null : _maritalStatus,
//         'emergencyContact': _emergencyContactController.text.trim(),
//         'nic': _nicController.text.trim(),
//         'address': _addressController.text.trim(),
//         'location': _location == 'Select' ? null : _location,
//         'profileImageUrl': imageUrl, // Updated image URL
        
//         'guardianFirstName': _showGuardianFields ? _guardianFirstNameController.text.trim() : null,
//         'guardianLastName': _showGuardianFields ? _guardianLastNameController.text.trim() : null,
//         'guardianMobile': _showGuardianFields ? _guardianMobileController.text.trim() : null,
//         'guardianNic': _showGuardianFields ? _guardianNicController.text.trim() : null,
//         'guardianAddress': _showGuardianFields ? _guardianAddressController.text.trim() : null,
//         'guardianRelationship': _showGuardianFields && _guardianRelationship != 'Select' ? _guardianRelationship : null,
//         'guardianGender': _showGuardianFields && _guardianGender != 'Select' ? _guardianGender : null,
        
//         'updatedAt': FieldValue.serverTimestamp(),
//         // Keep role and createdAt, don't overwrite them if they exist
//         'role': (await FirebaseFirestore.instance.collection('users').doc(user.uid).get()).data()?['role'],
//         'createdAt': (await FirebaseFirestore.instance.collection('users').doc(user.uid).get()).data()?['createdAt'],

//       }, SetOptions(merge: true)); // Merge to avoid overwriting fields like 'role' or 'createdAt'

//       if (mounted) {
//         // No need to setState for individual string variables if controllers are source of truth for display
//          _profileImageUrl = imageUrl; // Update local state for image URL
//         _showSnackBar('Profile updated successfully');
//       }
//     } catch (e) {
//       dev.log("Error saving profile: $e");
//       if (mounted) _showSnackBar('Error updating profile: $e', isError: true);
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _selectDate() async {
//     // ... (Your existing _selectDate logic is good)
//     DateTime initial;
//     try {
//       initial = _dobController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_dobController.text) : DateTime.now();
//     } catch (e) {
//       initial = DateTime.now();
//     }

//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(
//               primary: primaryGreen,
//               onPrimary: Colors.white, // Text on primary color
//             ),
//              dialogBackgroundColor: Colors.white, // Background of the dialog
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && mounted) {
//       setState(() {
//         _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
//         DateTime now = DateTime.now();
//         int age = now.year - picked.year;
//         if (now.month < picked.month || (now.month == picked.month && now.day < picked.day)) {
//           age--;
//         }
//         _showGuardianFields = age < 18;
//       });
//     }
//   }

//   void _toggleProfileView() { // This shows the detailed form
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: Text('Edit Your Profile', style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.bold)),
//             backgroundColor: Colors.white,
//             elevation: 1,
//             iconTheme: const IconThemeData(color: Colors.black),
//           ),
//           body: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildProfileDetailsForm(),
//         ),
//       ),
//     );
//   }
  
//   // --- FIREBASE INTEGRATED CHANGE PASSWORD ---
//   Future<void> _firebaseChangePassword(BuildContext dialogContext, String currentPassword, String newPassword) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null || user.email == null) {
//         _showSnackBar("Not logged in or email not available.", isError: true, contextForSnackBar: dialogContext);
//         return;
//     }

//     // Dismiss keyboard
//     FocusScope.of(dialogContext).unfocus();
    
//     // Show loading indicator within the dialog or page if preferred
//     // For simplicity, just using snackbars for feedback here.

//     try {
//         AuthCredential credential = EmailAuthProvider.credential(
//             email: user.email!, password: currentPassword);
//         await user.reauthenticateWithCredential(credential);

//         await user.updatePassword(newPassword);
//         if (mounted) {
//           Navigator.pop(dialogContext); // Close dialog
//           _showSnackBar("Password changed successfully!");
//         }
//     } on FirebaseAuthException catch (e) {
//         String errorMessage = "Error changing password.";
//         if (e.code == 'wrong-password' || e.code == 'INVALID_LOGIN_CREDENTIALS') {
//             errorMessage = 'Incorrect current password.';
//         } else if (e.code == 'weak-password') {
//             errorMessage = 'New password is too weak (min 6 characters).';
//         } else {
//             errorMessage = e.message ?? errorMessage;
//         }
//          if (mounted) _showSnackBar(errorMessage, isError: true, contextForSnackBar: dialogContext);
//          dev.log("Change Password Error: ${e.code} - ${e.message}");
//     } catch (e) {
//         if (mounted) _showSnackBar('An unexpected error occurred: $e', isError: true, contextForSnackBar: dialogContext);
//         dev.log("Change Password Unexpected Error: $e");
//     }
//   }


//   void _showChangePasswordDialog() {
//     final currentPasswordController = TextEditingController();
//     final newPasswordController = TextEditingController();
//     final confirmPasswordController = TextEditingController();
//     final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();


//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: Text('Change Password', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
//         content: Form(
//           key: dialogFormKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: currentPasswordController,
//                 decoration: const InputDecoration(labelText: 'Current Password'),
//                 obscureText: true,
//                 validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
//               ),
//               TextFormField(
//                 controller: newPasswordController,
//                 decoration: const InputDecoration(labelText: 'New Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Required';
//                   if (value.length < 6) return 'Min 6 characters';
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: confirmPasswordController,
//                 decoration: const InputDecoration(labelText: 'Confirm New Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Required';
//                   if (newPasswordController.text != value) return 'Passwords do not match';
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: Text('Cancel', style: GoogleFonts.nunito()),
//           ),
//           TextButton(
//             onPressed: () {
//               if (dialogFormKey.currentState!.validate()) {
//                  // Pass dialogContext for showing snackbar within the dialog's context if needed
//                 _firebaseChangePassword(dialogContext, currentPasswordController.text, newPasswordController.text);
//               }
//             },
//             child: Text('Save', style: GoogleFonts.nunito()),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- FIREBASE INTEGRATED LOGOUT ---
//   Future<void> _performLogout() async {
//     try {
//         await FirebaseAuth.instance.signOut();
//         // Clear any local user state/providers if necessary
//         if (mounted) {
//             Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => const AuthPage()), // Navigate to your main login page
//                 (Route<dynamic> route) => false,
//             );
//         }
//     } catch (e) {
//         dev.log("Error during logout: $e");
//         if (mounted) _showSnackBar('Error logging out: $e', isError: true);
//     }
//   }

//   void _showLogoutConfirmation() {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog( // Use dialogContext
//         title: Text('Logout', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
//         content: Text('Are you sure you want to logout?', style: GoogleFonts.nunito()),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: Text('Cancel', style: GoogleFonts.nunito(color: Colors.grey)),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(dialogContext); // Close dialog first
//               _performLogout();
//             },
//             child: Text('Yes, Logout', style: GoogleFonts.nunito(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteAccountConfirmation() {
//     // ... (Your existing _showDeleteAccountConfirmation logic is good)
//     // Make sure _deleteAccount navigates appropriately after deletion
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Delete Account',
//           style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
//         ),
//         content: Text(
//           'This action is permanent and cannot be undone. Are you sure you want to delete your account?',
//           style: GoogleFonts.nunito(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'Cancel',
//               style: GoogleFonts.nunito(color: Colors.grey),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _deleteAccount();
//             },
//             child: Text(
//               'Yes, Delete My Account',
//               style: GoogleFonts.nunito(color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _deleteAccount() async {
//     // ... (Your existing _deleteAccount logic is good, ensure navigation to AuthPage)
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       _showSnackBar('Not logged in.', isError: true);
//       return;
//     }
    
//     // Optional: Re-authenticate user before sensitive operation
//     // This requires getting their password securely. For simplicity, skipping for now.

//     try {
//       // Delete Firestore document first
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
//       // Then delete Firebase Auth user
//       await user.delete();
      
//       if (mounted) {
//         _showSnackBar('Account deleted successfully.');
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const AuthPage()), // Navigate to login
//           (route) => false
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       dev.log("Error deleting account (Auth): ${e.code} - ${e.message}");
//       String message = "Error deleting account.";
//       if (e.code == 'requires-recent-login') {
//         message = "This operation is sensitive and requires recent authentication. Please log out and log back in before trying again.";
//       } else {
//         message = e.message ?? message;
//       }
//       if (mounted) _showSnackBar(message, isError: true);
//     } catch (e) {
//       dev.log("Error deleting account (Firestore/Other): $e");
//       if (mounted) _showSnackBar('Error deleting account: $e', isError: true);
//     }
//   }

//   void _showSnackBar(String message, {bool isError = false, BuildContext? contextForSnackBar}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(contextForSnackBar ?? context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.redAccent : Colors.green,
//       ),
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     // This outer Scaffold is for the main list of profile options
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Profile', style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: _isLoading 
//             ? const Center(child: CircularProgressIndicator()) 
//             : _buildProfileOptionsList(),
//     );
//   }

//   Widget _buildProfileOptionsList() {
//     // This builds the list of options like "Your Profile", "Settings", etc.
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: _pickImage, // Allow changing image from here too if desired, or only in edit form
//                   child: Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.grey[200],
//                         backgroundImage: _profileImage != null
//                             ? FileImage(_profileImage!)
//                             : _profileImageUrl != null && _profileImageUrl!.isNotEmpty
//                                 ? NetworkImage(_profileImageUrl!) as ImageProvider
//                                 : null,
//                         child: (_profileImage == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty))
//                             ? Icon(Icons.person, size: 40, color: Colors.grey[400])
//                             : null,
//                       ),
//                        Positioned( // Edit icon always visible on the summary page for image
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
//                           child: const Icon(Icons.edit, size: 16, color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded( // Use Expanded to prevent overflow if name/email is long
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                     Text(
//                       (_firstNameController.text.isEmpty && _lastNameController.text.isEmpty)
//                           ? (FirebaseAuth.instance.currentUser?.displayName ?? 'Welcome, User!') // Use Firebase display name if available
//                           : '${_firstNameController.text} ${_lastNameController.text}'.trim(),
//                       style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                       const SizedBox(height: 4),
//                       Text(
//                         _emailController.text.isEmpty 
//                           ? (FirebaseAuth.instance.currentUser?.email ?? 'No email set') 
//                           : _emailController.text,
//                         style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[600]),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1, thickness: 1),
//           _buildProfileOptionItem(
//             icon: Icons.edit_note_outlined, // Changed icon
//             title: 'Edit Profile Details',
//             onTap: _toggleProfileView, // This navigates to the detailed form
//           ),
//           _buildProfileOptionItem(
//             icon: Icons.medical_services_outlined,
//             title: 'Medical & Lifestyle',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const MedicalLifestyleScreen()),
//               );
//             },
//           ),
//            _buildProfileOptionItem(
//             icon: Icons.lock_reset_outlined, // Changed icon
//             title: 'Change Password',
//             onTap: _showChangePasswordDialog,
//           ),
//           // _buildProfileOptionItem(
//           //   icon: Icons.money_outlined,
//           //   title: 'Refunds',
//           //   onTap: () { /* TODO */ },
//           // ),
//           // _buildProfileOptionItem(
//           //   icon: Icons.settings_outlined,
//           //   title: 'Settings',
//           //   onTap: () { /* TODO */ },
//           // ),
//           // _buildProfileOptionItem(
//           //   icon: Icons.help_outline,
//           //   title: 'Help Center',
//           //   onTap: () { /* TODO */ },
//           // ),
//           // _buildProfileOptionItem(
//           //   icon: Icons.favorite_outline,
//           //   title: 'Favourites',
//           //   onTap: () { /* TODO */ },
//           // ),
//            const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Colors.black12,),
//           _buildProfileOptionItem(
//             icon: Icons.logout,
//             title: 'Log Out',
//             onTap: _showLogoutConfirmation,
//             isDestructive: true, // Optional flag for different styling
//           ),
//            _buildProfileOptionItem(
//             icon: Icons.delete_forever_outlined, // Changed icon
//             title: 'Delete Account',
//             onTap: _showDeleteAccountConfirmation,
//             isDestructive: true, // Optional flag for different styling
//           ),
//         ],
//       ),
//     );
//   }

//   // This is the detailed form page's content
//   Widget _buildProfileDetailsForm() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 60, // Larger for edit page
//                     backgroundColor: Colors.grey[200],
//                     backgroundImage: _profileImage != null
//                         ? FileImage(_profileImage!)
//                         : _profileImageUrl != null && _profileImageUrl!.isNotEmpty
//                             ? NetworkImage(_profileImageUrl!) as ImageProvider
//                             : null,
//                     child: (_profileImage == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty))
//                         ? Icon(Icons.person_add_alt_outlined, size: 60, color: Colors.grey[400])
//                         : null,
//                   ),
//                   if (_profileImage == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty))
//                     Positioned.fill(
//                       child: Center(
//                         child: Text(
//                           "Tap to add photo",
//                           style: GoogleFonts.nunito(color: Colors.grey[600], fontSize: 12),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   Positioned(
//                     bottom: 0,
//                     right: 70, // Adjust for larger avatar
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
//                       child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
            
//             _buildTextFormField('First Name', _firstNameController, TextInputType.text, hintText: 'Enter your first name', validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildTextFormField('Last Name', _lastNameController, TextInputType.text, hintText: 'Enter your last name', validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildTextFormField('Mobile Number', _mobileController, TextInputType.phone, hintText: '07XXXXXXXX', maxLength: 10, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => v!.length != 10 ? 'Valid 10-digit number required' : null),
//             _buildTextFormField('Email Address', _emailController, TextInputType.emailAddress, hintText: 'your.email@example.com', readOnly: true), // Email should be read-only
//             _buildTextFormField('Date Of Birth', _dobController, TextInputType.datetime, hintText: 'DD/MM/YYYY', readOnly: true, onTap: _selectDate, validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildDropdownFormField('Gender', _gender, _genderOptions, (v) => setState(() => _gender = v!), validator: (v) => v == 'Select' ? 'Required' : null),
//             _buildDropdownFormField('Marital Status', _maritalStatus, _maritalStatusOptions, (v) => setState(() => _maritalStatus = v!), validator: (v) => v == 'Select' ? 'Required' : null),
//             _buildTextFormField('NIC Number', _nicController, TextInputType.text, hintText: 'Enter your NIC number', validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildTextFormField('Emergency Contact', _emergencyContactController, TextInputType.phone, hintText: '07XXXXXXXX', maxLength: 10, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildTextFormField('Address', _addressController, TextInputType.streetAddress, hintText: 'Enter your address', maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildDropdownFormField('District', _location, _locationOptions, (v) => setState(() => _location = v!), validator: (v) => v == 'Select' ? 'Required' : null),
            
//             if (_showGuardianFields) ...[
//               const SizedBox(height: 24),
//               Text('Guardian Details', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen)),
//               const SizedBox(height: 16),
//               _buildTextFormField('Guardian First Name', _guardianFirstNameController, TextInputType.text, hintText: 'Guardian first name', validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null),
//               _buildTextFormField('Guardian Last Name', _guardianLastNameController, TextInputType.text, hintText: 'Guardian last name', validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null),
//               _buildTextFormField('Guardian Mobile', _guardianMobileController, TextInputType.phone, hintText: '07XXXXXXXX', maxLength: 10, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null),
//               _buildTextFormField('Guardian NIC', _guardianNicController, TextInputType.text, hintText: 'Guardian NIC', validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null),
//               _buildTextFormField('Guardian Address', _guardianAddressController, TextInputType.streetAddress, hintText: 'Guardian address', maxLines: 3, validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null),
//               _buildDropdownFormField('Relationship to Guardian', _guardianRelationship, _relationshipOptions, (v) => setState(() => _guardianRelationship = v!), validator: (v) => _showGuardianFields && v == 'Select' ? 'Required' : null),
//               _buildDropdownFormField('Guardian Gender', _guardianGender, _genderOptions, (v) => setState(() => _guardianGender = v!), validator: (v) => _showGuardianFields && v == 'Select' ? 'Required' : null),
//             ],
            
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _saveProfileToFirestore,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryGreen,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: _isLoading 
//                       ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,))
//                       : Text('Update Profile', style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//               ),
//             ),
//             const SizedBox(height: 20), // Space at the bottom
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileOptionItem({ // Renamed from _buildProfileOption
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool isDestructive = false, // For logout/delete
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Adjusted padding
//         child: Row(
//           children: [
//             Icon(icon, color: isDestructive ? Colors.redAccent : primaryGreen, size: 24),
//             const SizedBox(width: 16),
//             Text(title, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w500, color: isDestructive ? Colors.redAccent : Colors.black87)),
//             const Spacer(),
//             Icon(Icons.chevron_right, color: Colors.grey[500], size: 28),
//           ],
//         ),
//       ),
//     );
//   }

//   // Reusable TextFormField builder for the details form
//   Widget _buildTextFormField(
//     String label,
//     TextEditingController controller,
//     TextInputType keyboardType, {
//     String? hintText,
//     bool readOnly = false,
//     VoidCallback? onTap,
//     int? maxLength,
//     int maxLines = 1,
//     List<TextInputFormatter>? inputFormatters,
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600)),
//           const SizedBox(height: 8),
//           TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             readOnly: readOnly,
//             maxLength: maxLength,
//             maxLines: maxLines,
//             inputFormatters: inputFormatters,
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: GoogleFonts.nunito(color: Colors.grey[400], fontSize: 16),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
//               enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[350]!)),
//               focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryGreen, width: 1.5)),
//               contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//               counterText: "", // Hides the character counter if maxLength is set
//             ),
//             style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w500),
//             validator: validator,
//             onTap: onTap,
//           ),
//         ],
//       ),
//     );
//   }

//   // Reusable DropdownButtonFormField builder for the details form
//   Widget _buildDropdownFormField(
//     String label,
//     String currentValue, // The state variable holding the selected value
//     List<String> items,
//     ValueChanged<String?> onChanged, {
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600)),
//           const SizedBox(height: 8),
//           DropdownButtonFormField<String>(
//             value: items.contains(currentValue) ? currentValue : items.firstWhere((item) => item == 'Select', orElse: () => items.first), // Ensure value is in items or default
//             items: items.map((item) => DropdownMenuItem(
//                       value: item,
//                       child: Text(item, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w500, color: item == 'Select' ? Colors.grey[500] : Colors.black87)),
//                     )).toList(),
//             onChanged: onChanged,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
//               enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[350]!)),
//               focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryGreen, width: 1.5)),
//               contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//             ),
//             validator: validator,
//             dropdownColor: Colors.white,
//             icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[700]),
//             isExpanded: true,
//           ),
//         ],
//       ),
//     );
//   }
// }























// // lib/pages/profile/profile_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'dart:developer' as dev;

// // Conditional imports for dart:io. File type will only be available on non-web.
// // ADJUST THE PATH TO stub_file.dart if it's not in lib/ when profile_screen.dart is in lib/pages/patient/
// import 'dart:io' if (dart.library.html) '../../stub_file.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// // Assuming AuthPage and MedicalLifestyleScreen are correctly pathed
// import 'package:medi_sync_plus_app/pages/auth/auth_page.dart';

// // Placeholder for MedicalLifestyleScreen - ensure this is correctly implemented or remove if not used
// class MedicalLifestyleScreen extends StatelessWidget {
//   const MedicalLifestyleScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('Medical & Lifestyle')),
//         body: const Center(child: Text('Medical & Lifestyle Screen Content')));
//   }
// }

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   // Define primaryGreen as a member of the State class
//   // Or, you can use Theme.of(context).primaryColor directly in your build methods
//   final Color _primaryGreen = const Color(0xFF4CAF50); 

//   bool _showGuardianFields = false;
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _mobileController;
//   late TextEditingController _emailController;
//   late TextEditingController _dobController;
//   late TextEditingController _emergencyContactController;
//   late TextEditingController _nicController;
//   late TextEditingController _addressController;
//   late TextEditingController _guardianFirstNameController;
//   late TextEditingController _guardianLastNameController;
//   late TextEditingController _guardianMobileController;
//   late TextEditingController _guardianNicController;
//   late TextEditingController _guardianAddressController;

//   String _gender = 'Select';
//   String _maritalStatus = 'Select';
//   String _location = 'Select';
//   String? _profileImageUrl;
//   String _guardianRelationship = 'Select';
//   String _guardianGender = 'Select';

//   dynamic _pickedImageFile;
//   bool _isLoading = true;

//   final List<String> _genderOptions = ['Select', 'Male', 'Female', 'Other'];
//   final List<String> _maritalStatusOptions = ['Select', 'Single', 'Married', 'Divorced', 'Widowed'];
//   final List<String> _relationshipOptions = ['Select', 'Parent', 'Guardian', 'Sibling', 'Spouse', 'Other'];
//   final List<String> _locationOptions = [
//     'Select', 'Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo', 'Galle', 
//     'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara', 'Kandy', 'Kegalle', 'Kilinochchi', 
//     'Kurunegala', 'Mannar', 'Matale', 'Matara', 'Monaragala', 'Mullaitivu', 
//     'Nuwara Eliya', 'Polonnaruwa', 'Puttalam', 'Ratnapura', 'Trincomalee', 'Vavuniya'
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     _fetchProfileFromFirestore();
//   }

//   void _initializeControllers() {
//     _firstNameController = TextEditingController();
//     _lastNameController = TextEditingController();
//     _mobileController = TextEditingController();
//     _emailController = TextEditingController();
//     _dobController = TextEditingController();
//     _emergencyContactController = TextEditingController();
//     _nicController = TextEditingController();
//     _addressController = TextEditingController();
//     _guardianFirstNameController = TextEditingController();
//     _guardianLastNameController = TextEditingController();
//     _guardianMobileController = TextEditingController();
//     _guardianNicController = TextEditingController();
//     _guardianAddressController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _dobController.dispose();
//     _emergencyContactController.dispose();
//     _nicController.dispose();
//     _addressController.dispose();
//     _guardianFirstNameController.dispose();
//     _guardianLastNameController.dispose();
//     _guardianMobileController.dispose();
//     _guardianNicController.dispose();
//     _guardianAddressController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchProfileFromFirestore() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       try {
//         DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//         if (doc.exists && mounted) {
//           final data = doc.data() as Map<String, dynamic>;
//           setState(() {
//             _firstNameController.text = data['firstName'] ?? '';
//             _lastNameController.text = data['lastName'] ?? '';
//             _mobileController.text = data['mobile'] ?? '';
//             _emailController.text = data['email'] ?? user.email ?? '';
//             _dobController.text = data['dob'] ?? '';
//             _emergencyContactController.text = data['emergencyContact'] ?? '';
//             _nicController.text = data['nic'] ?? '';
//             _addressController.text = data['address'] ?? '';
//             _gender = data['gender'] ?? 'Select';
//             _maritalStatus = data['maritalStatus'] ?? 'Select';
//             _location = data['location'] ?? 'Select';
//             _profileImageUrl = data['profileImageUrl'];
//             _guardianFirstNameController.text = data['guardianFirstName'] ?? '';
//             _guardianLastNameController.text = data['guardianLastName'] ?? '';
//             _guardianMobileController.text = data['guardianMobile'] ?? '';
//             _guardianNicController.text = data['guardianNic'] ?? '';
//             _guardianAddressController.text = data['guardianAddress'] ?? '';
//             _guardianRelationship = data['guardianRelationship'] ?? 'Select';
//             _guardianGender = data['guardianGender'] ?? 'Select';
//             _updateGuardianFieldsVisibility(data['dob'] as String?);
//           });
//         } else {
//            dev.log("ProfileScreen: User document does not exist for UID: ${user.uid}. Initializing email.");
//            if(mounted) { // Guard setState with mounted
//              setState(() => _emailController.text = user.email ?? '');
//            }
//         }
//       } catch (e) {
//         dev.log("ProfileScreen: Error fetching profile: $e");
//         if(mounted) { _showSnackBar("Error loading profile details.", isError: true); }
//       }
//     } else {
//       dev.log("ProfileScreen: No current user found.");
//        if(mounted) { _showSnackBar("Not logged in. Cannot load profile.", isError: true); }
//     }
//     if (mounted) { setState(() => _isLoading = false); }
//   }

//   void _updateGuardianFieldsVisibility(String? dobString) {
//     if (dobString != null && dobString.isNotEmpty) {
//       try {
//           DateTime dobDate = DateFormat('dd/MM/yyyy').parse(dobString);
//           DateTime now = DateTime.now();
//           int age = now.year - dobDate.year;
//           if (now.month < dobDate.month || (now.month == dobDate.month && now.day < dobDate.day)) {
//             age--;
//           }
//           if(mounted){
//             setState(() {
//               _showGuardianFields = age < 18;
//               if (!_showGuardianFields) { _clearGuardianFieldsUIData(); }
//             });
//           }
//       } catch (e) {
//           dev.log("Error parsing DOB for guardian visibility: $dobString - $e");
//           if(mounted) { setState(() => _showGuardianFields = false); }
//       }
//     } else {
//         if(mounted) { setState(() => _showGuardianFields = false); }
//     }
//   }

//   void _clearGuardianFieldsUIData() {
//     _guardianFirstNameController.clear();
//     _guardianLastNameController.clear();
//     _guardianMobileController.clear();
//     _guardianNicController.clear();
//     _guardianAddressController.clear();
//     if(mounted) {
//       setState(() {
//         _guardianRelationship = 'Select';
//         _guardianGender = 'Select';
//       });
//     }
//     dev.log("Guardian fields UI data cleared.");
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     XFile? pickedXFileLocal;
//     try {
//       ImageSource? source;
//       if (kIsWeb) {
//         source = ImageSource.gallery;
//       } else {
//         // Guard context use
//         if (!mounted) return;
//         source = await showDialog<ImageSource>(
//           context: context, // Context is valid here
//           builder: (context) => AlertDialog( /* ... */ ),
//         );
//       }
//       if (source == null) return;
//       pickedXFileLocal = await picker.pickImage(source: source, imageQuality: 70, maxWidth: 800);
//       if (pickedXFileLocal != null && mounted) {
//         if (kIsWeb) {
//           final bytes = await pickedXFileLocal.readAsBytes();
//           setState(() => _pickedImageFile = bytes);
//         } else {
//           setState(() => _pickedImageFile = File(pickedXFileLocal!.path));
//         }
//       }
//     } catch (e) {
//       dev.log("Error picking image: $e");
//       if (mounted) { _showSnackBar("Error picking image.", isError: true); }
//     }
//   }

//   Future<String?> _uploadImageToStorage() async {
//     if (_pickedImageFile == null) return _profileImageUrl;
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) return _profileImageUrl;
//     String fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     try {
//       final ref = FirebaseStorage.instance.ref().child('profile_pics').child(fileName);
//       UploadTask uploadTask;
//       if (kIsWeb && _pickedImageFile is Uint8List) {
//         uploadTask = ref.putData(_pickedImageFile as Uint8List, SettableMetadata(contentType: 'image/jpeg'));
//       } else if (!kIsWeb && _pickedImageFile is File) {
//         uploadTask = ref.putFile(_pickedImageFile as File);
//       } else {
//         return _profileImageUrl;
//       }
//       final snapshot = await uploadTask;
//       return await snapshot.ref.getDownloadURL();
//     } catch (e) {
//       dev.log("Error uploading image: $e");
//       if (mounted) { _showSnackBar('Error uploading image.', isError: true); }
//       return _profileImageUrl;
//     }
//   }

//   Future<void> _saveProfileToFirestore() async {
//     if (!_formKey.currentState!.validate()) {
//       if (mounted) { _showSnackBar('Please correct the errors in the form.', isError: true); }
//       return;
//     }
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       if (mounted) { _showSnackBar('Please log in to save profile.', isError: true); }
//       return;
//     }
//     if (mounted) { setState(() => _isLoading = true); }
//     try {
//       String? newImageUrl = await _uploadImageToStorage();
//       DocumentSnapshot existingUserDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       Map<String, dynamic> existingUserData = existingUserDoc.exists ? existingUserDoc.data() as Map<String, dynamic> : {};
//       Map<String, dynamic> profileData = {
//         'firstName': _firstNameController.text.trim(), 'lastName': _lastNameController.text.trim(),
//         'mobile': _mobileController.text.trim(), 'email': _emailController.text.trim(),
//         'dob': _dobController.text.trim(), 'gender': _gender == 'Select' ? null : _gender,
//         'maritalStatus': _maritalStatus == 'Select' ? null : _maritalStatus,
//         'emergencyContact': _emergencyContactController.text.trim(),
//         'nic': _nicController.text.trim(), 'address': _addressController.text.trim(),
//         'location': _location == 'Select' ? null : _location, 'profileImageUrl': newImageUrl,
//         'guardianFirstName': _showGuardianFields ? _guardianFirstNameController.text.trim() : FieldValue.delete(),
//         'guardianLastName': _showGuardianFields ? _guardianLastNameController.text.trim() : FieldValue.delete(),
//         'guardianMobile': _showGuardianFields ? _guardianMobileController.text.trim() : FieldValue.delete(),
//         'guardianNic': _showGuardianFields ? _guardianNicController.text.trim() : FieldValue.delete(),
//         'guardianAddress': _showGuardianFields ? _guardianAddressController.text.trim() : FieldValue.delete(),
//         'guardianRelationship': _showGuardianFields && _guardianRelationship != 'Select' ? _guardianRelationship : FieldValue.delete(),
//         'guardianGender': _showGuardianFields && _guardianGender != 'Select' ? _guardianGender : FieldValue.delete(),
//         'profileSetupComplete': true, 'updatedAt': FieldValue.serverTimestamp(),
//         'role': existingUserData['role'] ?? 'patient', 'createdAt': existingUserData['createdAt'], 'uid': user.uid,
//       };
//       profileData.removeWhere((key, value) => value == FieldValue.delete());
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set(profileData, SetOptions(merge: true));
//       if (mounted) {
//         setState(() { _profileImageUrl = newImageUrl; _pickedImageFile = null; });
//         _showSnackBar('Profile updated successfully!');
//         // Check if this screen was pushed with arguments indicating it's a new user setup
//         final arguments = ModalRoute.of(context)?.settings.arguments;
//         if (arguments == true || (ModalRoute.of(context)!.settings.name == '/profile_setup_after_signup')) {
//              // Navigate to the main part of the app, replacing this profile setup screen
//             // This assumes your AuthPage or SplashScreen handles routing to the correct dashboard
//             if (mounted) { // Check mounted again before navigation
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (context) => const AuthPage()), // Or directly to dashboard if auth state is managed
//                     (route) => false
//                 );
//             }
//         } else if (Navigator.canPop(context)) {
//             if (mounted) Navigator.pop(context, true); // Indicate save was successful
//         }
//       }
//     } catch (e) {
//       dev.log("Error saving profile: $e");
//       if (mounted) { _showSnackBar('Error updating profile.', isError: true); }
//     } finally {
//       if (mounted) { setState(() => _isLoading = false); }
//     }
//   }

//   Future<void> _selectDate() async {
//     DateTime initialDate;
//     try {
//       initialDate = _dobController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_dobController.text) : DateTime.now();
//     } catch (_) { initialDate = DateTime.now(); }
//     // Guard context use
//     if (!mounted) return;
//     DateTime? picked = await showDatePicker(
//       context: context, initialDate: initialDate, firstDate: DateTime(1900), lastDate: DateTime.now(),
//       builder: (context, child) { 
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(primary: _primaryGreen, onPrimary: Colors.white),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && mounted) {
//       setState(() {
//         _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
//         _updateGuardianFieldsVisibility(_dobController.text);
//       });
//     }
//   }

//   void _navigateToEditProfileForm() {
//     // Guard context use
//     if (!mounted) return;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         settings: const RouteSettings(name: '/edit_profile_form'),
//         builder: (context) => Scaffold(
//           appBar: AppBar(title: Text('Edit Your Profile', style: GoogleFonts.nunito(fontWeight: FontWeight.bold))),
//           body: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildProfileDetailsForm(),
//         ),
//       ),
//     ).then((savedSuccessfully) {
//         if (savedSuccessfully == true && mounted) {
//              _fetchProfileFromFirestore();
//         }
//     });
//   }
  
//   Future<void> _firebaseChangePassword(BuildContext dialogContext, String currentPassword, String newPassword) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     final localContext = dialogContext; // Capture context

//     if (user == null || user.email == null) {
//         // Check if dialog's context is still valid before showing snackbar
//         if (Navigator.of(localContext).canPop()) { // A way to check if dialog context might still be around
//           _showSnackBar("Not logged in or email not available.", isError: true, contextForSnackBar: localContext);
//         } else if (mounted) { // Fallback to main screen context
//           _showSnackBar("Not logged in or email not available.", isError: true);
//         }
//         return;
//     }
//     FocusScope.of(localContext).unfocus();
//     try {
//         AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
//         await user.reauthenticateWithCredential(credential);
//         await user.updatePassword(newPassword);
        
//         if (Navigator.of(localContext).canPop()) { Navigator.pop(localContext); } // Close dialog
//         if (mounted) { _showSnackBar("Password changed successfully!"); } // Show on main screen

//     } on FirebaseAuthException catch (e) {
//         String errorMessage = "Error changing password.";
//         if (e.code == 'wrong-password' || e.code == 'INVALID_LOGIN_CREDENTIALS') { errorMessage = 'Incorrect current password.'; }
//         else if (e.code == 'weak-password') { errorMessage = 'New password is too weak (min 6 characters).';}
//         else { errorMessage = e.message ?? errorMessage; }
//         if (Navigator.of(localContext).canPop()) { // If dialog still there, show error in it or main
//             _showSnackBar(errorMessage, isError: true, contextForSnackBar: localContext);
//         } else if (mounted) {
//             _showSnackBar(errorMessage, isError: true);
//         }
//     } catch (e) { 
//         if (Navigator.of(localContext).canPop()) {
//             _showSnackBar('An unexpected error occurred: $e', isError: true, contextForSnackBar: localContext);
//         } else if (mounted) {
//             _showSnackBar('An unexpected error occurred: $e', isError: true);
//         }
//     }
//   }

//   void _showChangePasswordDialog() {
//     final currentPasswordController = TextEditingController();
//     final newPasswordController = TextEditingController();
//     final confirmPasswordController = TextEditingController();
//     final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
//     // Guard context use
//     if (!mounted) return;
//     showDialog(context: context, builder: (dialogContext) => AlertDialog( /* ... (Content as before, calls _firebaseChangePassword) ... */ ));
//   }

//   Future<void> _performLogout() async {
//     try { await FirebaseAuth.instance.signOut();
//       if (!mounted) return; // Check mounted BEFORE using context
//       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthPage()), (Route<dynamic> route) => false);
//     } catch (e) { if (mounted) { _showSnackBar('Error logging out: $e', isError: true); } }
//   }

//   void _showLogoutConfirmation() {
//     if (!mounted) return; // Guard context use
//     showDialog(context: context, builder: (dialogContext) => AlertDialog( /* ... (Content as before, calls _performLogout) ... */ ));
//   }

//   void _showDeleteAccountConfirmation() {
//     if (!mounted) return; // Guard context use
//     showDialog(context: context, builder: (dialogContext) => AlertDialog( /* ... (Content as before, calls _deleteAccount) ... */ ));
//   }

//   Future<void> _deleteAccount() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) { if (mounted) { _showSnackBar('Not logged in.', isError: true); } return; }
//     try {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
//       await user.delete();
//       if (!mounted) return;
//       _showSnackBar('Account deleted successfully.');
//       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthPage()), (route) => false);
//     } on FirebaseAuthException catch (e) {
//       String message = "Error deleting account.";
//       if (e.code == 'requires-recent-login') { message = "This operation is sensitive. Please log out and log back in before trying again."; }
//       else { message = e.message ?? message; }
//       if (mounted) { _showSnackBar(message, isError: true); }
//     } catch (e) { if (mounted) { _showSnackBar('Error deleting account: $e', isError: true); } }
//   }

//   void _showSnackBar(String message, {bool isError = false, BuildContext? contextForSnackBar}) {
//     final targetContext = contextForSnackBar ?? (mounted ? context : null);
//     if (targetContext == null || !Navigator.of(targetContext).mounted) { // Check if context is still valid
//         dev.log("Snackbar not shown: context not mounted or invalid.");
//         return;
//     }
//     ScaffoldMessenger.of(targetContext).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: isError ? Colors.redAccent : Colors.green),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('My Profile', style: GoogleFonts.nunito(fontWeight: FontWeight.bold))),
//       body: _isLoading 
//             ? const Center(child: CircularProgressIndicator()) 
//             : _buildProfileOptionsList(),
//     );
//   }

//   Widget _buildProfileOptionsList() {
//     String displayName = (_firstNameController.text.isEmpty && _lastNameController.text.isEmpty)
//         ? (FirebaseAuth.instance.currentUser?.displayName ?? 'Welcome, User!')
//         : '${_firstNameController.text} ${_lastNameController.text}'.trim();
//     String displayEmail = _emailController.text.isEmpty 
//         ? (FirebaseAuth.instance.currentUser?.email ?? 'No email set') 
//         : _emailController.text;
//     ImageProvider? displayImage;
//     if (_pickedImageFile != null) {
//       if (kIsWeb && _pickedImageFile is Uint8List) { displayImage = MemoryImage(_pickedImageFile as Uint8List); }
//       else if (!kIsWeb && _pickedImageFile is File) { displayImage = FileImage(_pickedImageFile as File); }
//     } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) { displayImage = NetworkImage(_profileImageUrl!); }

//     return RefreshIndicator( onRefresh: _fetchProfileFromFirestore, child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(), child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Padding( padding: const EdgeInsets.all(16.0), child: Row(children: [
//                 GestureDetector( onTap: _navigateToEditProfileForm, child: Stack(children: [
//                     CircleAvatar(radius: 40, backgroundColor: Colors.grey[200], backgroundImage: displayImage,
//                       child: displayImage == null ? Icon(Icons.person, size: 40, color: Colors.grey[400]) : null),
//                     Positioned( bottom: 0, right: 0, child: Container( padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: _primaryGreen, shape: BoxShape.circle), // Used _primaryGreen
//                         child: const Icon(Icons.edit, size: 16, color: Colors.white))),
//                 ])),
//                 const SizedBox(width: 16),
//                 Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(displayName, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
//                   const SizedBox(height: 4),
//                   Text(displayEmail, style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[600]), overflow: TextOverflow.ellipsis),
//                 ])),
//             ])),
//             const Divider(height: 1, thickness: 1),
//             _buildProfileOptionItem(icon: Icons.edit_note_outlined, title: 'Edit Profile Details', onTap: _navigateToEditProfileForm),
//             _buildProfileOptionItem(icon: Icons.healing_outlined, title: 'Medical & Lifestyle', onTap: () { if(mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalLifestyleScreen())); }),
//             _buildProfileOptionItem(icon: Icons.lock_reset_outlined, title: 'Change Password', onTap: _showChangePasswordDialog),
//             const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Colors.black12,),
//             _buildProfileOptionItem(icon: Icons.logout, title: 'Log Out', onTap: _showLogoutConfirmation, isDestructive: true),
//             _buildProfileOptionItem(icon: Icons.delete_forever_outlined, title: 'Delete Account', onTap: _showDeleteAccountConfirmation, isDestructive: true),
//         ],),
//     ));
//   }

//   Widget _buildProfileDetailsForm() {
//     ImageProvider? detailFormDisplayImage;
//     if (_pickedImageFile != null) {
//       if (kIsWeb && _pickedImageFile is Uint8List) { detailFormDisplayImage = MemoryImage(_pickedImageFile as Uint8List); }
//       else if (!kIsWeb && _pickedImageFile is File) { detailFormDisplayImage = FileImage(_pickedImageFile as File); }
//     } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) { detailFormDisplayImage = NetworkImage(_profileImageUrl!); }

//     return SingleChildScrollView( padding: const EdgeInsets.all(16), child: Form( key: _formKey, child: Column( children: [
//             GestureDetector( onTap: _pickImage, child: Stack( alignment: Alignment.center, children: [
//                 CircleAvatar(radius: 60, backgroundColor: Colors.grey[200], backgroundImage: detailFormDisplayImage,
//                   child: detailFormDisplayImage == null ? Icon(Icons.add_a_photo_outlined, size: 60, color: Colors.grey[400]) : null), // Corrected icon
//                 if (detailFormDisplayImage == null) Positioned.fill(child: Center(child: Text("Tap to add photo", style: GoogleFonts.nunito(color: Colors.grey[600], fontSize: 12), textAlign: TextAlign.center))),
//                 Positioned( bottom: 0, right: 70, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _primaryGreen, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), // Used _primaryGreen
//                     child: const Icon(Icons.camera_alt, size: 20, color: Colors.white))),
//             ])),
//             const SizedBox(height: 24),
//             _buildTextFormField('First Name', _firstNameController, TextInputType.text, hintText: 'Enter your first name', validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildTextFormField('Last Name', _lastNameController, TextInputType.text, hintText: 'Enter your last name', validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildTextFormField('Mobile Number', _mobileController, TextInputType.phone, hintText: '07XXXXXXXX', maxLength: 10, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => v!.length != 10 ? 'Valid 10-digit number required' : null),
//             _buildTextFormField('Email Address', _emailController, TextInputType.emailAddress, hintText: 'your.email@example.com', readOnly: true),
//             _buildTextFormField('Date Of Birth', _dobController, TextInputType.datetime, hintText: 'DD/MM/YYYY', readOnly: true, onTap: _selectDate, validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildDropdownFormField('Gender', _gender, _genderOptions, (v) => setState(() => _gender = v!), validator: (v) => v == 'Select' ? 'Required' : null),
//             _buildDropdownFormField('Marital Status', _maritalStatus, _maritalStatusOptions, (v) => setState(() => _maritalStatus = v!), validator: (v) => v == 'Select' ? 'Required' : null),
//             _buildTextFormField('NIC Number', _nicController, TextInputType.text, hintText: 'Enter your NIC number', validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildTextFormField('Emergency Contact', _emergencyContactController, TextInputType.phone, hintText: '07XXXXXXXX', maxLength: 10, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildTextFormField('Address', _addressController, TextInputType.streetAddress, hintText: 'Enter your address', maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
//             _buildDropdownFormField('District', _location, _locationOptions, (v) => setState(() => _location = v!), validator: (v) => v == 'Select' ? 'Required' : null),
//             if (_showGuardianFields) ...[
//               const SizedBox(height: 24),
//               Text('Guardian Details', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryGreen)), // Used _primaryGreen
//               const SizedBox(height: 16),
//               _buildTextFormField('Guardian First Name', _guardianFirstNameController, TextInputType.text, hintText: 'Guardian first name', validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null),
//               _buildTextFormField('Guardian Last Name', _guardianLastNameController, TextInputType.text, hintText: 'Guardian last name', validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null),
//               _buildTextFormField('Guardian Mobile', _guardianMobileController, TextInputType.phone, hintText: '07XXXXXXXX', maxLength: 10, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null),
//               _buildTextFormField('Guardian NIC', _guardianNicController, TextInputType.text, hintText: 'Guardian NIC', validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null),
//               _buildTextFormField('Guardian Address', _guardianAddressController, TextInputType.streetAddress, hintText: 'Guardian address', maxLines: 3, validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null),
//               _buildDropdownFormField('Relationship to Guardian', _guardianRelationship, _relationshipOptions, (v) => setState(() => _guardianRelationship = v!), validator: (v) => _showGuardianFields && v == 'Select' ? 'Required' : null),
//               _buildDropdownFormField('Guardian Gender', _guardianGender, _genderOptions, (v) => setState(() => _guardianGender = v!), validator: (v) => _showGuardianFields && v == 'Select' ? 'Required' : null),
//             ],
//             const SizedBox(height: 24),
//             SizedBox( width: double.infinity, child: ElevatedButton( onPressed: _isLoading ? null : _saveProfileToFirestore,
//                 style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), // Used _primaryGreen
//                 child: _isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,))
//                       : Text('Update Profile', style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//             )),
//             const SizedBox(height: 20),
//     ])));
//   }

//   Widget _buildProfileOptionItem({required IconData icon, required String title, required VoidCallback onTap, bool isDestructive = false}) {
//     return InkWell( onTap: onTap, child: Padding( padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         child: Row( children: [
//             Icon(icon, color: isDestructive ? Colors.redAccent : _primaryGreen, size: 24), // Used _primaryGreen
//             const SizedBox(width: 16),
//             Text(title, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w500, color: isDestructive ? Colors.redAccent : Colors.black87)),
//             const Spacer(),
//             Icon(Icons.chevron_right, color: Colors.grey[500], size: 28),
//         ],),
//     ));
//   }
  
//   Widget _buildTextFormField( String label, TextEditingController controller, TextInputType keyboardType, {
//     String? hintText, bool readOnly = false, VoidCallback? onTap, int? maxLength, int maxLines = 1,
//     List<TextInputFormatter>? inputFormatters, String? Function(String?)? validator,
//   }) {
//     return Padding( padding: const EdgeInsets.only(bottom: 16), child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(label, style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600)),
//           const SizedBox(height: 8),
//           TextFormField(
//             controller: controller, keyboardType: keyboardType, readOnly: readOnly,
//             maxLength: maxLength, maxLines: maxLines, inputFormatters: inputFormatters,
//             decoration: InputDecoration(
//               hintText: hintText, hintStyle: GoogleFonts.nunito(color: Colors.grey[400], fontSize: 16),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
//               enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[350]!)),
//               focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _primaryGreen, width: 1.5)), // Used _primaryGreen
//               contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16), counterText: "",
//             ),
//             style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w500),
//             validator: validator, onTap: onTap,
//           ),
//     ]));
//   }

//   Widget _buildDropdownFormField( String label, String currentValue, List<String> items, ValueChanged<String?> onChanged, {
//     String? Function(String?)? validator,
//   }) {
//      return Padding( padding: const EdgeInsets.only(bottom: 16), child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(label, style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600)),
//           const SizedBox(height: 8),
//           DropdownButtonFormField<String>(
//             value: items.contains(currentValue) ? currentValue : items.firstWhere((item) => item == 'Select', orElse: () => items.first),
//             items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w500, color: item == 'Select' ? Colors.grey[500] : Colors.black87)))).toList(),
//             onChanged: onChanged,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
//               enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[350]!)),
//               focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _primaryGreen, width: 1.5)), // Used _primaryGreen
//               contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//             ),
//             validator: validator, dropdownColor: Colors.white, icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[700]), isExpanded: true,
//           ),
//      ]));
//   }
// } // End of _ProfileScreenState class - NO STRAY CHARACTERS AFTER THIS

















// // lib/pages/profile/profile_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'dart:developer' as dev;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:io' if (dart.library.html) '../../stub_file.dart';
// import 'dart:typed_data';

// // Assuming AuthPage is correctly pathed
// import 'package:medi_sync_plus_app/pages/auth/auth_page.dart';

// // Placeholder for MedicalLifestyleScreen
// class MedicalLifestyleScreen extends StatelessWidget {
//   const MedicalLifestyleScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Medical & Lifestyle')),
//       body: const Center(child: Text('Medical & Lifestyle Screen Content')),
//     );
//   }
// }

// class ProfileScreen extends StatefulWidget {
//   final bool isInitialSetup; // Indicates if this is post-signup flow
//   const ProfileScreen({super.key, this.isInitialSetup = false});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final Color _primaryGreen = const Color(0xFF4CAF50);
//   final _formKey = GlobalKey<FormState>();
//   bool _showGuardianFields = false;
//   bool _isLoading = true;

//   // Controllers
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _mobileController;
//   late TextEditingController _emailController;
//   late TextEditingController _dobController;
//   late TextEditingController _emergencyContactController;
//   late TextEditingController _nicController;
//   late TextEditingController _addressController;
//   late TextEditingController _guardianFirstNameController;
//   late TextEditingController _guardianLastNameController;
//   late TextEditingController _guardianMobileController;
//   late TextEditingController _guardianNicController;
//   late TextEditingController _guardianAddressController;

//   // State variables
//   String _gender = 'Select';
//   String _maritalStatus = 'Select';
//   String _location = 'Select';
//   String? _profileImageUrl;
//   String _guardianRelationship = 'Select';
//   String _guardianGender = 'Select';
//   dynamic _pickedImageFile;

//   // Options
//   final List<String> _genderOptions = ['Select', 'Male', 'Female', 'Other'];
//   final List<String> _maritalStatusOptions = ['Select', 'Single', 'Married', 'Divorced', 'Widowed'];
//   final List<String> _relationshipOptions = ['Select', 'Parent', 'Guardian', 'Sibling', 'Spouse', 'Other'];
//   final List<String> _locationOptions = [
//     'Select', 'Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo', 'Galle',
//     'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara', 'Kandy', 'Kegalle', 'Kilinochchi',
//     'Kurunegala', 'Mannar', 'Matale', 'Matara', 'Monaragala', 'Mullaitivu',
//     'Nuwara Eliya', 'Polonnaruwa', 'Puttalam', 'Ratnapura', 'Trincomalee', 'Vavuniya'
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     _fetchProfileFromFirestore();
//   }

//   void _initializeControllers() {
//     _firstNameController = TextEditingController();
//     _lastNameController = TextEditingController();
//     _mobileController = TextEditingController();
//     _emailController = TextEditingController();
//     _dobController = TextEditingController();
//     _emergencyContactController = TextEditingController();
//     _nicController = TextEditingController();
//     _addressController = TextEditingController();
//     _guardianFirstNameController = TextEditingController();
//     _guardianLastNameController = TextEditingController();
//     _guardianMobileController = TextEditingController();
//     _guardianNicController = TextEditingController();
//     _guardianAddressController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _dobController.dispose();
//     _emergencyContactController.dispose();
//     _nicController.dispose();
//     _addressController.dispose();
//     _guardianFirstNameController.dispose();
//     _guardianLastNameController.dispose();
//     _guardianMobileController.dispose();
//     _guardianNicController.dispose();
//     _guardianAddressController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchProfileFromFirestore() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         _showSnackBar('Not logged in. Cannot load profile.', isError: true);
//         return;
//       }
//       DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       if (doc.exists && mounted) {
//         final data = doc.data() as Map<String, dynamic>;
//         setState(() {
//           _firstNameController.text = data['firstName'] ?? '';
//           _lastNameController.text = data['lastName'] ?? '';
//           _mobileController.text = data['mobile'] ?? '';
//           _emailController.text = data['email'] ?? user.email ?? '';
//           _dobController.text = data['dob'] ?? '';
//           _emergencyContactController.text = data['emergencyContact'] ?? '';
//           _nicController.text = data['nic'] ?? '';
//           _addressController.text = data['address'] ?? '';
//           _gender = data['gender'] ?? 'Select';
//           _maritalStatus = data['maritalStatus'] ?? 'Select';
//           _location = data['location'] ?? 'Select';
//           _profileImageUrl = data['profileImageUrl'];
//           _guardianFirstNameController.text = data['guardianFirstName'] ?? '';
//           _guardianLastNameController.text = data['guardianLastName'] ?? '';
//           _guardianMobileController.text = data['guardianMobile'] ?? '';
//           _guardianNicController.text = data['guardianNic'] ?? '';
//           _guardianAddressController.text = data['guardianAddress'] ?? '';
//           _guardianRelationship = data['guardianRelationship'] ?? 'Select';
//           _guardianGender = data['guardianGender'] ?? 'Select';
//           _updateGuardianFieldsVisibility(data['dob']);
//         });
//       } else {
//         dev.log("ProfileScreen: User document does not exist for UID: ${user.uid}");
//         if (mounted) setState(() => _emailController.text = user.email ?? '');
//       }
//     } catch (e) {
//       dev.log("ProfileScreen: Error fetching profile: $e");
//       if (mounted) _showSnackBar('Error loading profile: $e', isError: true);
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   void _updateGuardianFieldsVisibility(String? dobString) {
//     if (dobString == null || dobString.isEmpty) {
//       if (mounted) setState(() => _showGuardianFields = false);
//       return;
//     }
//     try {
//       DateTime dobDate = DateFormat('dd/MM/yyyy').parse(dobString);
//       DateTime now = DateTime.now();
//       int age = now.year - dobDate.year;
//       if (now.month < dobDate.month || (now.month == dobDate.month && now.day < dobDate.day)) {
//         age--;
//       }
//       if (mounted) {
//         setState(() {
//           _showGuardianFields = age < 18;
//           if (!_showGuardianFields) _clearGuardianFieldsUIData();
//         });
//       }
//     } catch (e) {
//       dev.log("ProfileScreen: Error parsing DOB: $dobString - $e");
//       if (mounted) setState(() => _showGuardianFields = false);
//     }
//   }

//   void _clearGuardianFieldsUIData() {
//     _guardianFirstNameController.clear();
//     _guardianLastNameController.clear();
//     _guardianMobileController.clear();
//     _guardianNicController.clear();
//     _guardianAddressController.clear();
//     if (mounted) {
//       setState(() {
//         _guardianRelationship = 'Select';
//         _guardianGender = 'Select';
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     if (!mounted) return;
//     final picker = ImagePicker();
//     try {
//       ImageSource? source;
//       if (kIsWeb) {
//         source = ImageSource.gallery;
//       } else {
//         source = await showDialog<ImageSource>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Select Image Source', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.photo_library),
//                   title: Text('Gallery', style: GoogleFonts.nunito()),
//                   onTap: () => Navigator.pop(context, ImageSource.gallery),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.camera_alt),
//                   title: Text('Camera', style: GoogleFonts.nunito()),
//                   onTap: () => Navigator.pop(context, ImageSource.camera),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//       if (source == null) return;
//       final pickedFile = await picker.pickImage(source: source, imageQuality: 70, maxWidth: 800);
//       if (pickedFile != null && mounted) {
//         setState(() {
//           if (kIsWeb) {
//             pickedFile.readAsBytes().then((bytes) => setState(() => _pickedImageFile = bytes));
//           } else {
//             _pickedImageFile = File(pickedFile.path);
//           }
//         });
//       }
//     } catch (e) {
//       dev.log("ProfileScreen: Error picking image: $e");
//       if (mounted) _showSnackBar('Error picking image.', isError: true);
//     }
//   }

//   Future<String?> _uploadImageToStorage() async {
//     if (_pickedImageFile == null) return _profileImageUrl;
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       if (mounted) _showSnackBar('Not logged in.', isError: true);
//       return _profileImageUrl;
//     }
//     try {
//       final ref = FirebaseStorage.instance.ref().child('profile_pics').child('${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
//       UploadTask uploadTask;
//       if (kIsWeb && _pickedImageFile is Uint8List) {
//         uploadTask = ref.putData(_pickedImageFile, SettableMetadata(contentType: 'image/jpeg'));
//       } else if (!kIsWeb && _pickedImageFile is File) {
//         uploadTask = ref.putFile(_pickedImageFile);
//       } else {
//         return _profileImageUrl;
//       }
//       final snapshot = await uploadTask;
//       return await snapshot.ref.getDownloadURL();
//     } catch (e) {
//       dev.log("ProfileScreen: Error uploading image: $e");
//       if (mounted) _showSnackBar('Error uploading image.', isError: true);
//       return _profileImageUrl;
//     }
//   }

//   Future<void> _saveProfileToFirestore() async {
//     if (!mounted || !_formKey.currentState!.validate()) {
//       if (mounted) _showSnackBar('Please correct the errors in the form.', isError: true);
//       return;
//     }
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       if (mounted) _showSnackBar('Please log in to save profile.', isError: true);
//       return;
//     }
//     setState(() => _isLoading = true);
//     try {
//       String? newImageUrl = await _uploadImageToStorage();
//       DocumentSnapshot existingDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       Map<String, dynamic> existingData = existingDoc.exists ? existingDoc.data() as Map<String, dynamic> : {};
//       Map<String, dynamic> profileData = {
//         'firstName': _firstNameController.text.trim(),
//         'lastName': _lastNameController.text.trim(),
//         'mobile': _mobileController.text.trim(),
//         'email': _emailController.text.trim(),
//         'dob': _dobController.text.trim(),
//         'gender': _gender == 'Select' ? null : _gender,
//         'maritalStatus': _maritalStatus == 'Select' ? null : _maritalStatus,
//         'emergencyContact': _emergencyContactController.text.trim(),
//         'nic': _nicController.text.trim(),
//         'address': _addressController.text.trim(),
//         'location': _location == 'Select' ? null : _location,
//         'profileImageUrl': newImageUrl,
//         'profileSetupComplete': true,
//         'updatedAt': FieldValue.serverTimestamp(),
//         'role': existingData['role'] ?? 'patient',
//         'createdAt': existingData['createdAt'] ?? FieldValue.serverTimestamp(),
//         'uid': user.uid,
//       };
//       if (_showGuardianFields) {
//         profileData.addAll({
//           'guardianFirstName': _guardianFirstNameController.text.trim(),
//           'guardianLastName': _guardianLastNameController.text.trim(),
//           'guardianMobile': _guardianMobileController.text.trim(),
//           'guardianNic': _guardianNicController.text.trim(),
//           'guardianAddress': _guardianAddressController.text.trim(),
//           'guardianRelationship': _guardianRelationship == 'Select' ? null : _guardianRelationship,
//           'guardianGender': _guardianGender == 'Select' ? null : _guardianGender,
//         });
//       } else {
//         profileData.addAll({
//           'guardianFirstName': FieldValue.delete(),
//           'guardianLastName': FieldValue.delete(),
//           'guardianMobile': FieldValue.delete(),
//           'guardianNic': FieldValue.delete(),
//           'guardianAddress': FieldValue.delete(),
//           'guardianRelationship': FieldValue.delete(),
//           'guardianGender': FieldValue.delete(),
//         });
//       }
//       profileData.removeWhere((key, value) => value == null || value == FieldValue.delete());
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set(profileData, SetOptions(merge: true));
//       if (mounted) {
//         setState(() {
//           _profileImageUrl = newImageUrl;
//           _pickedImageFile = null;
//         });
//         _showSnackBar('Profile updated successfully!');
//         if (widget.isInitialSetup) {
//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => const AuthPage()),
//             (route) => false,
//           );
//         } else if (Navigator.canPop(context)) {
//           Navigator.pop(context, true);
//         }
//       }
//     } catch (e) {
//       dev.log("ProfileScreen: Error saving profile: $e");
//       if (mounted) _showSnackBar('Error updating profile.', isError: true);
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _selectDate() async {
//     if (!mounted) return;
//     DateTime initialDate;
//     try {
//       initialDate = _dobController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_dobController.text) : DateTime.now();
//     } catch (_) {
//       initialDate = DateTime.now();
//     }
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(primary: _primaryGreen, onPrimary: Colors.white),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && mounted) {
//       setState(() {
//         _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
//         _updateGuardianFieldsVisibility(_dobController.text);
//       });
//     }
//   }

//   void _navigateToEditProfileForm() {
//     if (!mounted) return;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         settings: const RouteSettings(name: '/edit_profile_form'),
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: Text('Edit Your Profile', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
//             backgroundColor: Colors.white,
//             elevation: 1,
//             iconTheme: const IconThemeData(color: Colors.black),
//           ),
//           body: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildProfileDetailsForm(),
//         ),
//       ),
//     ).then((savedSuccessfully) {
//       if (savedSuccessfully == true && mounted) {
//         _fetchProfileFromFirestore();
//       }
//     });
//   }

//   Future<void> _firebaseChangePassword(BuildContext dialogContext, String currentPassword, String newPassword) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null || user.email == null) {
//       _showSnackBar('Not logged in or email not available.', isError: true, contextForSnackBar: dialogContext);
//       return;
//     }
//     try {
//       AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
//       await user.reauthenticateWithCredential(credential);
//       await user.updatePassword(newPassword);
//       if (mounted) {
//         Navigator.pop(dialogContext);
//         _showSnackBar('Password changed successfully!');
//       }
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = 'Error changing password.';
//       if (e.code == 'wrong-password' || e.code == 'INVALID_LOGIN_CREDENTIALS') {
//         errorMessage = 'Incorrect current password.';
//       } else if (e.code == 'weak-password') {
//         errorMessage = 'New password is too weak (min 6 characters).';
//       } else {
//         errorMessage = e.message ?? errorMessage;
//       }
//       if (mounted) _showSnackBar(errorMessage, isError: true, contextForSnackBar: dialogContext);
//       dev.log("ProfileScreen: Change Password Error: ${e.code} - ${e.message}");
//     } catch (e) {
//       if (mounted) _showSnackBar('An unexpected error occurred.', isError: true, contextForSnackBar: dialogContext);
//       dev.log("ProfileScreen: Change Password Unexpected Error: $e");
//     }
//   }

//   void _showChangePasswordDialog() {
//     if (!mounted) return;
//     final currentPasswordController = TextEditingController();
//     final newPasswordController = TextEditingController();
//     final confirmPasswordController = TextEditingController();
//     final dialogFormKey = GlobalKey<FormState>();

//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: Text('Change Password', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
//         content: Form(
//           key: dialogFormKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: currentPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'Current Password',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 obscureText: true,
//                 validator: (value) => value == null || value.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: newPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'New Password',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Required';
//                   if (value.length < 6) return 'Min 6 characters';
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: confirmPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm New Password',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Required';
//                   if (value != newPasswordController.text) return 'Passwords do not match';
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: Text('Cancel', style: GoogleFonts.nunito()),
//           ),
//           TextButton(
//             onPressed: () {
//               if (dialogFormKey.currentState!.validate()) {
//                 _firebaseChangePassword(dialogContext, currentPasswordController.text, newPasswordController.text);
//               }
//             },
//             child: Text('Save', style: GoogleFonts.nunito()),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _performLogout() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       if (mounted) {
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const AuthPage()),
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       dev.log("ProfileScreen: Error logging out: $e");
//       if (mounted) _showSnackBar('Error logging out.', isError: true);
//     }
//   }

//   void _showLogoutConfirmation() {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: Text('Logout', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
//         content: Text('Are you sure you want to logout?', style: GoogleFonts.nunito()),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: Text('Cancel', style: GoogleFonts.nunito(color: Colors.grey)),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(dialogContext);
//               _performLogout();
//             },
//             child: Text('Yes, Logout', style: GoogleFonts.nunito(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _deleteAccount() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       if (mounted) _showSnackBar('Not logged in.', isError: true);
//       return;
//     }
//     try {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
//       await user.delete();
//       if (mounted) {
//         _showSnackBar('Account deleted successfully.');
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const AuthPage()),
//           (route) => false,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       String message = 'Error deleting account.';
//       if (e.code == 'requires-recent-login') {
//         message = 'Please log out and log back in before trying again.';
//       } else {
//         message = e.message ?? message;
//       }
//       if (mounted) _showSnackBar(message, isError: true);
//       dev.log("ProfileScreen: Error deleting account: ${e.code} - ${e.message}");
//     } catch (e) {
//       if (mounted) _showSnackBar('Error deleting account.', isError: true);
//       dev.log("ProfileScreen: Error deleting account: $e");
//     }
//   }

//   void _showDeleteAccountConfirmation() {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete Account', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
//         content: Text(
//           'This action is permanent and cannot be undone. Are you sure?',
//           style: GoogleFonts.nunito(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel', style: GoogleFonts.nunito(color: Colors.grey)),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _deleteAccount();
//             },
//             child: Text(
//               'Yes, Delete My Account',
//               style: GoogleFonts.nunito(color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSnackBar(String message, {bool isError = false, BuildContext? contextForSnackBar}) {
//     if (!mounted) return;
//     final targetContext = contextForSnackBar ?? context;
//     if (!Navigator.of(targetContext).mounted) {
//       dev.log("ProfileScreen: Snackbar not shown: context not mounted.");
//       return;
//     }
//     ScaffoldMessenger.of(targetContext).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.redAccent : Colors.green,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Profile', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _buildProfileOptionsList(),
//     );
//   }

//   Widget _buildProfileOptionsList() {
//     String displayName = (_firstNameController.text.isEmpty && _lastNameController.text.isEmpty)
//         ? (FirebaseAuth.instance.currentUser?.displayName ?? 'Welcome, User!')
//         : '${_firstNameController.text} ${_lastNameController.text}'.trim();
//     String displayEmail = _emailController.text.isEmpty
//         ? (FirebaseAuth.instance.currentUser?.email ?? 'No email set')
//         : _emailController.text;
//     ImageProvider? displayImage;
//     if (_pickedImageFile != null) {
//       if (kIsWeb && _pickedImageFile is Uint8List) {
//         displayImage = MemoryImage(_pickedImageFile);
//       } else if (!kIsWeb && _pickedImageFile is File) {
//         displayImage = FileImage(_pickedImageFile);
//       }
//     } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
//       displayImage = NetworkImage(_profileImageUrl!);
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchProfileFromFirestore,
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: _navigateToEditProfileForm,
//                     child: Stack(
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundColor: Colors.grey[200],
//                           backgroundImage: displayImage,
//                           child: displayImage == null
//                               ? Icon(Icons.person, size: 40, color: Colors.grey[400])
//                               : null,
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(color: _primaryGreen, shape: BoxShape.circle),
//                             child: const Icon(Icons.edit, size: 16, color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           displayName,
//                           style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           displayEmail,
//                           style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[600]),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(height: 1, thickness: 1),
//             _buildProfileOptionItem(
//               icon: Icons.edit_note_outlined,
//               title: 'Edit Profile Details',
//               onTap: _navigateToEditProfileForm,
//             ),
//             _buildProfileOptionItem(
//               icon: Icons.healing_outlined,
//               title: 'Medical & Lifestyle',
//               onTap: () {
//                 if (mounted) {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalLifestyleScreen()));
//                 }
//               },
//             ),
//             _buildProfileOptionItem(
//               icon: Icons.lock_reset_outlined,
//               title: 'Change Password',
//               onTap: _showChangePasswordDialog,
//             ),
//             const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Colors.black12),
//             _buildProfileOptionItem(
//               icon: Icons.logout,
//               title: 'Log Out',
//               onTap: _showLogoutConfirmation,
//               isDestructive: true,
//             ),
//             _buildProfileOptionItem(
//               icon: Icons.delete_forever_outlined,
//               title: 'Delete Account',
//               onTap: _showDeleteAccountConfirmation,
//               isDestructive: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileDetailsForm() {
//     ImageProvider? detailFormDisplayImage;
//     if (_pickedImageFile != null) {
//       if (kIsWeb && _pickedImageFile is Uint8List) {
//         detailFormDisplayImage = MemoryImage(_pickedImageFile);
//       } else if (!kIsWeb && _pickedImageFile is File) {
//         detailFormDisplayImage = FileImage(_pickedImageFile);
//       }
//     } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
//       detailFormDisplayImage = NetworkImage(_profileImageUrl!);
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 60,
//                     backgroundColor: Colors.grey[200],
//                     backgroundImage: detailFormDisplayImage,
//                     child: detailFormDisplayImage == null
//                         ? Icon(Icons.add_a_photo_outlined, size: 60, color: Colors.grey[400])
//                         : null,
//                   ),
//                   if (detailFormDisplayImage == null)
//                     Positioned.fill(
//                       child: Center(
//                         child: Text(
//                           'Tap to add photo',
//                           style: GoogleFonts.nunito(color: Colors.grey[600], fontSize: 12),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   Positioned(
//                     bottom: 0,
//                     right: 70,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: _primaryGreen,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildTextFormField(
//               'First Name',
//               _firstNameController,
//               TextInputType.text,
//               hintText: 'Enter your first name',
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             _buildTextFormField(
//               'Last Name',
//               _lastNameController,
//               TextInputType.text,
//               hintText: 'Enter your last name',
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             _buildTextFormField(
//               'Mobile Number',
//               _mobileController,
//               TextInputType.phone,
//               hintText: '07XXXXXXXX',
//               maxLength: 10,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               validator: (v) => v!.length != 10 ? 'Valid 10-digit number required' : null,
//             ),
//             _buildTextFormField(
//               'Email Address',
//               _emailController,
//               TextInputType.emailAddress,
//               hintText: 'your.email@example.com',
//               readOnly: true,
//             ),
//             _buildTextFormField(
//               'Date Of Birth',
//               _dobController,
//               TextInputType.datetime,
//               hintText: 'DD/MM/YYYY',
//               readOnly: true,
//               onTap: _selectDate,
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             _buildDropdownFormField(
//               'Gender',
//               _gender,
//               _genderOptions,
//               (v) => setState(() => _gender = v!),
//               validator: (v) => v == 'Select' ? 'Required' : null,
//             ),
//             _buildDropdownFormField(
//               'Marital Status',
//               _maritalStatus,
//               _maritalStatusOptions,
//               (v) => setState(() => _maritalStatus = v!),
//               validator: (v) => v == 'Select' ? 'Required' : null,
//             ),
//             _buildTextFormField(
//               'NIC Number',
//               _nicController,
//               TextInputType.text,
//               hintText: 'Enter your NIC number',
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             _buildTextFormField(
//               'Emergency Contact',
//               _emergencyContactController,
//               TextInputType.phone,
//               hintText: '07XXXXXXXX',
//               maxLength: 10,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             _buildTextFormField(
//               'Address',
//               _addressController,
//               TextInputType.streetAddress,
//               hintText: 'Enter your address',
//               maxLines: 3,
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             _buildDropdownFormField(
//               'District',
//               _location,
//               _locationOptions,
//               (v) => setState(() => _location = v!),
//               validator: (v) => v == 'Select' ? 'Required' : null,
//             ),
//             if (_showGuardianFields) ...[
//               const SizedBox(height: 24),
//               Text(
//                 'Guardian Details',
//                 style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryGreen),
//               ),
//               const SizedBox(height: 16),
//               _buildTextFormField(
//                 'Guardian First Name',
//                 _guardianFirstNameController,
//                 TextInputType.text,
//                 hintText: 'Guardian first name',
//                 validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null,
//               ),
//               _buildTextFormField(
//                 'Guardian Last Name',
//                 _guardianLastNameController,
//                 TextInputType.text,
//                 hintText: 'Guardian last name',
//                 validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null,
//               ),
//               _buildTextFormField(
//                 'Guardian Mobile',
//                 _guardianMobileController,
//                 TextInputType.phone,
//                 hintText: '07XXXXXXXX',
//                 maxLength: 10,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null,
//               ),
//               _buildTextFormField(
//                 'Guardian NIC',
//                 _guardianNicController,
//                 TextInputType.text,
//                 hintText: 'Guardian NIC',
//                 validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null,
//               ),
//               _buildTextFormField(
//                 'Guardian Address',
//                 _guardianAddressController,
//                 TextInputType.streetAddress,
//                 hintText: 'Guardian address',
//                 maxLines: 3,
//                 validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null,
//               ),
//               _buildDropdownFormField(
//                 'Relationship to Guardian',
//                 _guardianRelationship,
//                 _relationshipOptions,
//                 (v) => setState(() => _guardianRelationship = v!),
//                 validator: (v) => _showGuardianFields && v == 'Select' ? 'Required' : null,
//               ),
//               _buildDropdownFormField(
//                 'Guardian Gender',
//                 _guardianGender,
//                 _genderOptions,
//                 (v) => setState(() => _guardianGender = v!),
//                 validator: (v) => _showGuardianFields && v == 'Select' ? 'Required' : null,
//               ),
//             ],
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _saveProfileToFirestore,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _primaryGreen,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: _isLoading
//                     ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
//                       )
//                     : Text(
//                         'Update Profile',
//                         style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileOptionItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool isDestructive = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         child: Row(
//           children: [
//             Icon(icon, color: isDestructive ? Colors.redAccent : _primaryGreen, size: 24),
//             const SizedBox(width: 16),
//             Text(
//               title,
//               style: GoogleFonts.nunito(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: isDestructive ? Colors.redAccent : Colors.black87,
//               ),
//             ),
//             const Spacer(),
//             Icon(Icons.chevron_right, color: Colors.grey[500], size: 28),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextFormField(
//     String label,
//     TextEditingController controller,
//     TextInputType keyboardType, {
//     String? hintText,
//     bool readOnly = false,
//     VoidCallback? onTap,
//     int? maxLength,
//     int maxLines = 1,
//     List<TextInputFormatter>? inputFormatters,
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 8),
//           TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             readOnly: readOnly,
//             maxLength: maxLength,
//             maxLines: maxLines,
//             inputFormatters: inputFormatters,
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: GoogleFonts.nunito(color: Colors.grey[400], fontSize: 16),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.grey[350]!),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: _primaryGreen, width: 1.5),
//               ),
//               contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//               counterText: '',
//             ),
//             style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w500),
//             validator: validator,
//             onTap: onTap,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdownFormField(
//     String label,
//     String currentValue,
//     List<String> items,
//     ValueChanged<String?> onChanged, {
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 8),
//           DropdownButtonFormField<String>(
//             value: items.contains(currentValue) ? currentValue : items.first,
//             items: items
//                 .map((item) => DropdownMenuItem(
//                       value: item,
//                       child: Text(
//                         item,
//                         style: GoogleFonts.nunito(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: item == 'Select' ? Colors.grey[500] : Colors.black87,
//                         ),
//                       ),
//                     ))
//                 .toList(),
//             onChanged: onChanged,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.grey[350]!),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: _primaryGreen, width: 1.5),
//               ),
//               contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//             ),
//             validator: validator,
//             dropdownColor: Colors.white,
//             icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[700]),
//             isExpanded: true,
//           ),
//         ],
//       ),
//     );
//   }
// }






















// lib/pages/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' if (dart.library.html) '../../stub_file.dart';
import 'dart:typed_data';

// Assuming AuthPage and MedicalLifestyleScreen are correctly pathed
import 'package:medi_sync_plus_app/pages/auth/auth_page.dart';
import 'package:medi_sync_plus_app/pages/patient/medical_lifestyle_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isInitialSetup; // Indicates if this is post-signup flow
  const ProfileScreen({super.key, this.isInitialSetup = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color _primaryGreen = const Color(0xFF4CAF50);
  final _formKey = GlobalKey<FormState>();
  bool _showGuardianFields = false;
  bool _isLoading = true;

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _nicController;
  late TextEditingController _addressController;
  late TextEditingController _guardianFirstNameController;
  late TextEditingController _guardianLastNameController;
  late TextEditingController _guardianMobileController;
  late TextEditingController _guardianNicController;
  late TextEditingController _guardianAddressController;

  // State variables
  String _gender = 'Select';
  String _maritalStatus = 'Select';
  String _location = 'Select';
  String? _profileImageUrl;
  String _guardianRelationship = 'Select';
  String _guardianGender = 'Select';
  dynamic _pickedImageFile;

  // Options
  final List<String> _genderOptions = ['Select', 'Male', 'Female', 'Other'];
  final List<String> _maritalStatusOptions = ['Select', 'Single', 'Married', 'Divorced', 'Widowed'];
  final List<String> _relationshipOptions = ['Select', 'Parent', 'Guardian', 'Sibling', 'Spouse', 'Other'];
  final List<String> _locationOptions = [
    'Select', 'Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo', 'Galle',
    'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara', 'Kandy', 'Kegalle', 'Kilinochchi',
    'Kurunegala', 'Mannar', 'Matale', 'Matara', 'Monaragala', 'Mullaitivu',
    'Nuwara Eliya', 'Polonnaruwa', 'Puttalam', 'Ratnapura', 'Trincomalee', 'Vavuniya'
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchProfileFromFirestore();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _mobileController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
    _emergencyContactController = TextEditingController();
    _nicController = TextEditingController();
    _addressController = TextEditingController();
    _guardianFirstNameController = TextEditingController();
    _guardianLastNameController = TextEditingController();
    _guardianMobileController = TextEditingController();
    _guardianNicController = TextEditingController();
    _guardianAddressController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _emergencyContactController.dispose();
    _nicController.dispose();
    _addressController.dispose();
    _guardianFirstNameController.dispose();
    _guardianLastNameController.dispose();
    _guardianMobileController.dispose();
    _guardianNicController.dispose();
    _guardianAddressController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfileFromFirestore() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnackBar('Not logged in. Cannot load profile.', isError: true);
        return;
      }
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && mounted) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _firstNameController.text = data['firstName'] ?? '';
          _lastNameController.text = data['lastName'] ?? '';
          _mobileController.text = data['mobile'] ?? '';
          _emailController.text = data['email'] ?? user.email ?? '';
          _dobController.text = data['dob'] ?? '';
          _emergencyContactController.text = data['emergencyContact'] ?? '';
          _nicController.text = data['nic'] ?? '';
          _addressController.text = data['address'] ?? '';
          _gender = data['gender'] ?? 'Select';
          _maritalStatus = data['maritalStatus'] ?? 'Select';
          _location = data['location'] ?? 'Select';
          _profileImageUrl = data['profileImageUrl'];
          _guardianFirstNameController.text = data['guardianFirstName'] ?? '';
          _guardianLastNameController.text = data['guardianLastName'] ?? '';
          _guardianMobileController.text = data['guardianMobile'] ?? '';
          _guardianNicController.text = data['guardianNic'] ?? '';
          _guardianAddressController.text = data['guardianAddress'] ?? '';
          _guardianRelationship = data['guardianRelationship'] ?? 'Select';
          _guardianGender = data['guardianGender'] ?? 'Select';
          _updateGuardianFieldsVisibility(data['dob']);
        });
      } else {
        dev.log("ProfileScreen: User document does not exist for UID: ${user.uid}");
        if (mounted) setState(() => _emailController.text = user.email ?? '');
      }
    } catch (e) {
      dev.log("ProfileScreen: Error fetching profile: $e");
      if (mounted) _showSnackBar('Error loading profile: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _updateGuardianFieldsVisibility(String? dobString) {
    if (dobString == null || dobString.isEmpty) {
      if (mounted) setState(() => _showGuardianFields = false);
      return;
    }
    try {
      DateTime dobDate = DateFormat('dd/MM/yyyy').parse(dobString);
      DateTime now = DateTime.now();
      int age = now.year - dobDate.year;
      if (now.month < dobDate.month || (now.month == dobDate.month && now.day < dobDate.day)) {
        age--;
      }
      if (mounted) {
        setState(() {
          _showGuardianFields = age < 18;
          if (!_showGuardianFields) _clearGuardianFieldsUIData();
        });
      }
    } catch (e) {
      dev.log("ProfileScreen: Error parsing DOB: $dobString - $e");
      if (mounted) setState(() => _showGuardianFields = false);
    }
  }

  void _clearGuardianFieldsUIData() {
    _guardianFirstNameController.clear();
    _guardianLastNameController.clear();
    _guardianMobileController.clear();
    _guardianNicController.clear();
    _guardianAddressController.clear();
    if (mounted) {
      setState(() {
        _guardianRelationship = 'Select';
        _guardianGender = 'Select';
      });
    }
  }

  Future<void> _pickImage() async {
    if (!mounted) return;
    final picker = ImagePicker();
    try {
      ImageSource? source;
      if (kIsWeb) {
        source = ImageSource.gallery;
      } else {
        source = await showDialog<ImageSource>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Select Image Source', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text('Gallery', style: GoogleFonts.openSans()),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text('Camera', style: GoogleFonts.openSans()),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      }
      if (source == null) return;
      final pickedFile = await picker.pickImage(source: source, imageQuality: 70, maxWidth: 800);
      if (pickedFile != null && mounted) {
        setState(() {
          if (kIsWeb) {
            pickedFile.readAsBytes().then((bytes) => setState(() => _pickedImageFile = bytes));
          } else {
            _pickedImageFile = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      dev.log("ProfileScreen: Error picking image: $e");
      if (mounted) _showSnackBar('Error picking image.', isError: true);
    }
  }

  Future<String?> _uploadImageToStorage() async {
    if (_pickedImageFile == null) return _profileImageUrl;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) _showSnackBar('Not logged in.', isError: true);
      return _profileImageUrl;
    }
    try {
      final ref = FirebaseStorage.instance.ref().child('profile_pics').child('${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask;
      if (kIsWeb && _pickedImageFile is Uint8List) {
        uploadTask = ref.putData(_pickedImageFile, SettableMetadata(contentType: 'image/jpeg'));
      } else if (!kIsWeb && _pickedImageFile is File) {
        uploadTask = ref.putFile(_pickedImageFile);
      } else {
        return _profileImageUrl;
      }
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      dev.log("ProfileScreen: Error uploading image: $e");
      if (mounted) _showSnackBar('Error uploading image.', isError: true);
      return _profileImageUrl;
    }
  }

  Future<void> _saveProfileToFirestore() async {
    if (!mounted || !_formKey.currentState!.validate()) {
      if (mounted) _showSnackBar('Please correct the errors in the form.', isError: true);
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) _showSnackBar('Please log in to save profile.', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      String? newImageUrl = await _uploadImageToStorage();
      DocumentSnapshot existingDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      Map<String, dynamic> existingData = existingDoc.exists ? existingDoc.data() as Map<String, dynamic> : {};
      Map<String, dynamic> profileData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'email': _emailController.text.trim(),
        'dob': _dobController.text.trim(),
        'gender': _gender == 'Select' ? null : _gender,
        'maritalStatus': _maritalStatus == 'Select' ? null : _maritalStatus,
        'emergencyContact': _emergencyContactController.text.trim(),
        'nic': _nicController.text.trim(),
        'address': _addressController.text.trim(),
        'location': _location == 'Select' ? null : _location,
        'profileImageUrl': newImageUrl,
        'profileSetupComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
        'role': existingData['role'] ?? 'patient',
        'createdAt': existingData['createdAt'] ?? FieldValue.serverTimestamp(),
        'uid': user.uid,
      };
      if (_showGuardianFields) {
        profileData.addAll({
          'guardianFirstName': _guardianFirstNameController.text.trim(),
          'guardianLastName': _guardianLastNameController.text.trim(),
          'guardianMobile': _guardianMobileController.text.trim(),
          'guardianNic': _guardianNicController.text.trim(),
          'guardianAddress': _guardianAddressController.text.trim(),
          'guardianRelationship': _guardianRelationship == 'Select' ? null : _guardianRelationship,
          'guardianGender': _guardianGender == 'Select' ? null : _guardianGender,
        });
      } else {
        profileData.addAll({
          'guardianFirstName': FieldValue.delete(),
          'guardianLastName': FieldValue.delete(),
          'guardianMobile': FieldValue.delete(),
          'guardianNic': FieldValue.delete(),
          'guardianAddress': FieldValue.delete(),
          'guardianRelationship': FieldValue.delete(),
          'guardianGender': FieldValue.delete(),
        });
      }
      profileData.removeWhere((key, value) => value == null || value == FieldValue.delete());
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(profileData, SetOptions(merge: true));
      if (mounted) {
        setState(() {
          _profileImageUrl = newImageUrl;
          _pickedImageFile = null;
        });
        _showSnackBar('Profile updated successfully!');
        if (widget.isInitialSetup) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthPage()),
            (route) => false,
          );
        } else if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      dev.log("ProfileScreen: Error saving profile: $e");
      if (mounted) _showSnackBar('Error updating profile.', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    if (!mounted) return;
    DateTime initialDate;
    try {
      initialDate = _dobController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_dobController.text) : DateTime.now();
    } catch (_) {
      initialDate = DateTime.now();
    }
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: _primaryGreen, onPrimary: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
        _updateGuardianFieldsVisibility(_dobController.text);
      });
    }
  }

  void _navigateToEditProfileForm() {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: '/edit_profile_form'),
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Edit Your Profile', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildProfileDetailsForm(),
        ),
      ),
    ).then((savedSuccessfully) {
      if (savedSuccessfully == true && mounted) {
        _fetchProfileFromFirestore();
      }
    });
  }

  Future<void> _firebaseChangePassword(BuildContext dialogContext, String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      _showSnackBar('Not logged in or email not available.', isError: true, contextForSnackBar: dialogContext);
      return;
    }
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      if (mounted) {
        Navigator.pop(dialogContext);
        _showSnackBar('Password changed successfully!');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error changing password.';
      if (e.code == 'wrong-password' || e.code == 'INVALID_LOGIN_CREDENTIALS') {
        errorMessage = 'Incorrect current password.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'New password is too weak (min 6 characters).';
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      if (mounted) _showSnackBar(errorMessage, isError: true, contextForSnackBar: dialogContext);
      dev.log("ProfileScreen: Change Password Error: ${e.code} - ${e.message}");
    } catch (e) {
      if (mounted) _showSnackBar('An unexpected error occurred.', isError: true, contextForSnackBar: dialogContext);
      dev.log("ProfileScreen: Change Password Unexpected Error: $e");
    }
  }

  void _showChangePasswordDialog() {
    if (!mounted) return;
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Change Password', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        content: Form(
          key: dialogFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length < 6) return 'Min 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value != newPasswordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: GoogleFonts.openSans()),
          ),
          TextButton(
            onPressed: () {
              if (dialogFormKey.currentState!.validate()) {
                _firebaseChangePassword(dialogContext, currentPasswordController.text, newPasswordController.text);
              }
            },
            child: Text('Save', style: GoogleFonts.openSans()),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthPage()),
          (route) => false,
        );
      }
    } catch (e) {
      dev.log("ProfileScreen: Error logging out: $e");
      if (mounted) _showSnackBar('Error logging out.', isError: true);
    }
  }

  void _showLogoutConfirmation() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Logout', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to logout?', style: GoogleFonts.openSans()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: GoogleFonts.openSans(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _performLogout();
            },
            child: Text('Yes, Logout', style: GoogleFonts.openSans(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) _showSnackBar('Not logged in.', isError: true);
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      await user.delete();
      if (mounted) {
        _showSnackBar('Account deleted successfully.');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthPage()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Error deleting account.';
      if (e.code == 'requires-recent-login') {
        message = 'Please log out and log back in before trying again.';
      } else {
        message = e.message ?? message;
      }
      if (mounted) _showSnackBar(message, isError: true);
      dev.log("ProfileScreen: Error deleting account: ${e.code} - ${e.message}");
    } catch (e) {
      if (mounted) _showSnackBar('Error deleting account.', isError: true);
      dev.log("ProfileScreen: Error deleting account: $e");
    }
  }

  void _showDeleteAccountConfirmation() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        content: Text(
          'This action is permanent and cannot be undone. Are you sure?',
          style: GoogleFonts.openSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.openSans(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: Text(
              'Yes, Delete My Account',
              style: GoogleFonts.openSans(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false, BuildContext? contextForSnackBar}) {
    if (!mounted) return;
    final targetContext = contextForSnackBar ?? context;
    if (!Navigator.of(targetContext).mounted) {
      dev.log("ProfileScreen: Snackbar not shown: context not mounted.");
      return;
    }
    ScaffoldMessenger.of(targetContext).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildProfileOptionsList(),
    );
  }

  Widget _buildProfileOptionsList() {
    String displayName = (_firstNameController.text.isEmpty && _lastNameController.text.isEmpty)
        ? (FirebaseAuth.instance.currentUser?.displayName ?? 'Welcome, User!')
        : '${_firstNameController.text} ${_lastNameController.text}'.trim();
    String displayEmail = _emailController.text.isEmpty
        ? (FirebaseAuth.instance.currentUser?.email ?? 'No email set')
        : _emailController.text;
    ImageProvider? displayImage;
    if (_pickedImageFile != null) {
      if (kIsWeb && _pickedImageFile is Uint8List) {
        displayImage = MemoryImage(_pickedImageFile);
      } else if (!kIsWeb && _pickedImageFile is File) {
        displayImage = FileImage(_pickedImageFile);
      }
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      displayImage = NetworkImage(_profileImageUrl!);
    }

    return RefreshIndicator(
      onRefresh: _fetchProfileFromFirestore,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _navigateToEditProfileForm,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: displayImage,
                          child: displayImage == null
                              ? Icon(Icons.person, size: 40, color: Colors.grey[400])
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: _primaryGreen, shape: BoxShape.circle),
                            child: const Icon(Icons.edit, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayEmail,
                          style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            _buildProfileOptionItem(
              icon: Icons.edit_note_outlined,
              title: 'Edit Profile Details',
              onTap: _navigateToEditProfileForm,
            ),
            _buildProfileOptionItem(
              icon: Icons.healing_outlined,
              title: 'Medical & Lifestyle',
              onTap: () {
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MedicalLifestyleScreen()),
                  );
                }
              },
            ),
            _buildProfileOptionItem(
              icon: Icons.lock_reset_outlined,
              title: 'Change Password',
              onTap: _showChangePasswordDialog,
            ),
            const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Colors.black12),
            _buildProfileOptionItem(
              icon: Icons.logout,
              title: 'Log Out',
              onTap: _showLogoutConfirmation,
              isDestructive: true,
            ),
            _buildProfileOptionItem(
              icon: Icons.delete_forever_outlined,
              title: 'Delete Account',
              onTap: _showDeleteAccountConfirmation,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailsForm() {
    ImageProvider? detailFormDisplayImage;
    if (_pickedImageFile != null) {
      if (kIsWeb && _pickedImageFile is Uint8List) {
        detailFormDisplayImage = MemoryImage(_pickedImageFile);
      } else if (!kIsWeb && _pickedImageFile is File) {
        detailFormDisplayImage = FileImage(_pickedImageFile);
      }
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      detailFormDisplayImage = NetworkImage(_profileImageUrl!);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: detailFormDisplayImage,
                    child: detailFormDisplayImage == null
                        ? Icon(Icons.add_a_photo_outlined, size: 60, color: Colors.grey[400])
                        : null,
                  ),
                  if (detailFormDisplayImage == null)
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          'Tap to add photo',
                          style: GoogleFonts.openSans(color: Colors.grey[600], fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 70,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildTextFormField(
              'First Name',
              _firstNameController,
              TextInputType.text,
              hintText: 'Enter your first name',
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            _buildTextFormField(
              'Last Name',
              _lastNameController,
              TextInputType.text,
              hintText: 'Enter your last name',
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            _buildTextFormField(
              'Mobile Number',
              _mobileController,
              TextInputType.phone,
              hintText: '07XXXXXXXX',
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => v!.length != 10 ? 'Valid 10-digit number required' : null,
            ),
            _buildTextFormField(
              'Email Address',
              _emailController,
              TextInputType.emailAddress,
              hintText: 'your.email@example.com',
              readOnly: true,
            ),
            _buildTextFormField(
              'Date Of Birth',
              _dobController,
              TextInputType.datetime,
              hintText: 'DD/MM/YYYY',
              readOnly: true,
              onTap: _selectDate,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            _buildDropdownFormField(
              'Gender',
              _gender,
              _genderOptions,
              (v) => setState(() => _gender = v!),
              validator: (v) => v == 'Select' ? 'Required' : null,
            ),
            _buildDropdownFormField(
              'Marital Status',
              _maritalStatus,
              _maritalStatusOptions,
              (v) => setState(() => _maritalStatus = v!),
              validator: (v) => v == 'Select' ? 'Required' : null,
            ),
            _buildTextFormField(
              'NIC Number',
              _nicController,
              TextInputType.text,
              hintText: 'Enter your NIC number',
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            _buildTextFormField(
              'Emergency Contact',
              _emergencyContactController,
              TextInputType.phone,
              hintText: '07XXXXXXXX',
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            _buildTextFormField(
              'Address',
              _addressController,
              TextInputType.streetAddress,
              hintText: 'Enter your address',
              maxLines: 3,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            _buildDropdownFormField(
              'District',
              _location,
              _locationOptions,
              (v) => setState(() => _location = v!),
              validator: (v) => v == 'Select' ? 'Required' : null,
            ),
            if (_showGuardianFields) ...[
              const SizedBox(height: 24),
              Text(
                'Guardian Details',
                style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryGreen),
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                'Guardian First Name',
                _guardianFirstNameController,
                TextInputType.text,
                hintText: 'Guardian first name',
                validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null,
              ),
              _buildTextFormField(
                'Guardian Last Name',
                _guardianLastNameController,
                TextInputType.text,
                hintText: 'Guardian last name',
                validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null,
              ),
              _buildTextFormField(
                'Guardian Mobile',
                _guardianMobileController,
                TextInputType.phone,
                hintText: '07XXXXXXXX',
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null,
              ),
              _buildTextFormField(
                'Guardian NIC',
                _guardianNicController,
                TextInputType.text,
                hintText: 'Guardian NIC',
                validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null,
              ),
              _buildTextFormField(
                'Guardian Address',
                _guardianAddressController,
                TextInputType.streetAddress,
                hintText: 'Guardian address',
                maxLines: 3,
                validator: (v) => _showGuardianFields && v!.isEmpty ? 'Required' : null,
              ),
              _buildDropdownFormField(
                'Relationship to Guardian',
                _guardianRelationship,
                _relationshipOptions,
                (v) => setState(() => _guardianRelationship = v!),
                validator: (v) => _showGuardianFields && v == 'Select' ? 'Required' : null,
              ),
              _buildDropdownFormField(
                'Guardian Gender',
                _guardianGender,
                _genderOptions,
                (v) => setState(() => _guardianGender = v!),
                validator: (v) => _showGuardianFields && v == 'Select' ? 'Required' : null,
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfileToFirestore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : Text(
                        'Update Profile',
                        style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? Colors.redAccent : _primaryGreen, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.redAccent : Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey[500], size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType, {
    String? hintText,
    bool readOnly = false,
    VoidCallback? onTap,
    int? maxLength,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            maxLength: maxLength,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.openSans(color: Colors.grey[400], fontSize: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[350]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _primaryGreen, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              counterText: '',
            ),
            style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w500),
            validator: validator,
            onTap: onTap,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFormField(
    String label,
    String currentValue,
    List<String> items,
    ValueChanged<String?> onChanged, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: items.contains(currentValue) ? currentValue : items.first,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: item == 'Select' ? Colors.grey[500] : Colors.black87,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[350]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _primaryGreen, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
            validator: validator,
            dropdownColor: Colors.white,
            icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[600]),
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}