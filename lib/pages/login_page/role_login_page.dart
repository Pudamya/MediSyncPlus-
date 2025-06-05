
// // import 'package:flutter/material.dart';
// // import 'login_form.dart'; // Navigates to LoginForm with the selected role

// // class RoleLoginPage extends StatelessWidget {
// //   final List<String> roles = ['Doctor', 'Patient', 'Pharmacist'];

// //   RoleLoginPage({super.key}); // Added super.key

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Select Your Role"),
// //         automaticallyImplyLeading: false, // To remove back button if it's the first screen after splash
// //       ),
// //       body: Center(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.stretch, // Make buttons stretch
// //             children: roles.map((role) {
// //               return Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
// //                 child: ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     padding: const EdgeInsets.symmetric(vertical: 16.0),
// //                     textStyle: const TextStyle(fontSize: 18),
// //                   ),
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (_) => LoginForm(role: role)),
// //                     );
// //                   },
// //                   child: Text("Sign in as $role"),
// //                 ),
// //               );
// //             }).toList(),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }



// // import 'package:flutter/material.dart';
// // import 'package:medi_sync_plus_app/services/firestore_services.dart'; // Adjust import path
// // import 'login_form.dart';

// // class RoleLoginPage extends StatelessWidget {
// //   final List<String> roles = ['Doctor', 'Patient', 'Pharmacist'];

// //   RoleLoginPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Select Your Role"),
// //         automaticallyImplyLeading: false,
// //       ),
// //       body: Center(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               ...roles.map((role) {
// //                 return Padding(
// //                   padding: const EdgeInsets.symmetric(vertical: 8.0),
// //                   child: ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       padding: const EdgeInsets.symmetric(vertical: 16.0),
// //                       textStyle: const TextStyle(fontSize: 18),
// //                     ),
// //                     onPressed: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(builder: (_) => LoginForm(role: role)),
// //                       );
// //                     },
// //                     child: Text("Sign in as $role"),
// //                   ),
// //                 );
// //               }).toList(),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   final firestoreService = FirestoreService();
// //                   await firestoreService.initializeSampleData();
// //                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sample data initialized")));
// //                 },
// //                 child: const Text("Initialize Sample Data"),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }























// // import 'package:flutter/material.dart';
// // import 'package:medi_sync_plus_app/pages/login_page/login_form.dart'; // Adjust to your project name

// // class RoleLoginPage extends StatelessWidget {
// //   // It's good practice to type lists and make them const if their content won't change.
// //   static const List<String> _roles = ['Doctor', 'Patient', 'Pharmacist'];

// //   const RoleLoginPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Select Your Role"),
// //         automaticallyImplyLeading: false, // No back button on this initial role selection
// //         backgroundColor: Colors.green[700], // Consistent with other pages
// //         elevation: 2.0, // Optional: adds a slight shadow
// //       ),
// //       body: Center(
// //         child: Padding(
// //           padding: const EdgeInsets.all(24.0), // Increased padding for better spacing
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: _roles.map((role) {
// //               return Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 10.0), // Increased vertical padding
// //                 child: ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.green[600], // Button color
// //                     foregroundColor: Colors.white, // Text color
// //                     padding: const EdgeInsets.symmetric(
// //                         vertical: 16.0, horizontal: 24.0),
// //                     textStyle: const TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(8.0),
// //                     ),
// //                     elevation: 3.0,
// //                   ),
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => LoginForm(role: role),
// //                       ),
// //                     );
// //                   },
// //                   child: Text("Sign in as $role"),
// //                 ),
// //               );
// //             }).toList(),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }




















// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:medi_sync_plus_app/pages/login_page/login_form.dart'; // Adjust path
// // import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart'; // Updated to dashboard
// // import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart'; // Assume this exists
// // import 'package:provider/provider.dart';
// // import 'package:medi_sync_plus_app/providers/patient_provider.dart'; // Assume this exists

// // class RoleLoginPage extends StatefulWidget {
// //   const RoleLoginPage({super.key});

// //   @override
// //   State<RoleLoginPage> createState() => _RoleLoginPageState();
// // }

// // class _RoleLoginPageState extends State<RoleLoginPage> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final _formKey = GlobalKey<FormState>();
// //   String? _email, _password;

// //   void _handleLogin(String role) async {
// //     if (_formKey.currentState!.validate()) {
// //       _formKey.currentState!.save();
// //       try {
// //         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
// //           email: _email!,
// //           password: _password!,
// //         );

// //         // Fetch user role from Firestore (e.g., 'users' collection)
// //         DocumentSnapshot userDoc = await _firestore
// //             .collection('users')
// //             .doc(userCredential.user!.uid)
// //             .get();

// //         if (userDoc.exists) {
// //           String userRole = userDoc['role'] as String? ?? 'patient'; // Default to patient if not set

// //           if (userRole == role) {
// //             if (mounted) {
// //               if (role == 'patient') {
// //                 // Navigate to PatientHomeScreen with PatientProvider
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => ChangeNotifierProvider(
// //                       create: (_) => PatientProvider()..setPatientId(userCredential.user!.uid),
// //                       child: const PatientHomeScreen(),
// //                     ),
// //                   ),
// //                 );
// //               } else if (role == 'doctor') {
// //                 // Navigate to DoctorAppointmentsPage
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => DoctorAppointmentsPage(
// //                       doctorId: userCredential.user!.uid,
// //                       doctorName: userDoc['name'] as String? ?? 'Doctor',
// //                     ),
// //                   ),
// //                 );
// //               }
// //             }
// //           } else {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               const SnackBar(content: Text('Role mismatch. Please log in with the correct account.')),
// //             );
// //             await _auth.signOut();
// //           }
// //         }
// //       } catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Login failed: $e')),
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Login')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: [
// //               LoginForm(
// //                 onEmailSaved: (value) => _email = value,
// //                 onPasswordSaved: (value) => _password = value, role: '',
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: () => _handleLogin('patient'),
// //                 child: const Text('Login as Patient'),
// //               ),
// //               const SizedBox(height: 10),
// //               ElevatedButton(
// //                 onPressed: () => _handleLogin('doctor'),
// //                 child: const Text('Login as Doctor'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


























// // // role_login_page.dart
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:medi_sync_plus_app/pages/login_page/login_form.dart'; // We might not need this if fields are directly here
// // import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart';
// // import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart';
// // import 'package:provider/provider.dart';
// // import 'package:medi_sync_plus_app/providers/patient_provider.dart';
// // import 'dart:developer' as dev;


// // class RoleLoginPage extends StatefulWidget {
// //   const RoleLoginPage({super.key});

// //   @override
// //   State<RoleLoginPage> createState() => _RoleLoginPageState();
// // }

// // class _RoleLoginPageState extends State<RoleLoginPage> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final _formKey = GlobalKey<FormState>(); // This key is for THIS form

// //   // Controllers for email and password TextFormFields
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();

// //   bool _isLoading = false;

// //   @override
// //   void dispose() {
// //     _emailController.dispose();
// //     _passwordController.dispose();
// //     super.dispose();
// //   }

// //   void _handleLogin(String role) async {
// //     if (_formKey.currentState!.validate()) {
// //       // No need for _formKey.currentState!.save() if using controllers directly
// //       // The values are already in _emailController.text and _passwordController.text

// //       setState(() => _isLoading = true);
// //       dev.log("Attempting login for role: $role with email: ${_emailController.text}");

// //       try {
// //         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
// //           email: _emailController.text.trim(),
// //           password: _passwordController.text.trim(),
// //         );
// //         dev.log("Sign in successful. UID: ${userCredential.user?.uid}");

// //         if (userCredential.user == null) {
// //           throw Exception("User authentication failed unexpectedly.");
// //         }

// //         DocumentSnapshot userDoc = await _firestore
// //             .collection('users')
// //             .doc(userCredential.user!.uid)
// //             .get();
// //         dev.log("Fetched user document. Exists: ${userDoc.exists}");

// //         if (userDoc.exists) {
// //           String userRoleInDb = userDoc['role'] as String? ?? 'patient'; // Default
// //           dev.log("User role in DB: $userRoleInDb. Required role: $role");

// //           if (userRoleInDb == role) {
// //             if (mounted) {
// //               if (role == 'patient') {
// //                 dev.log("Navigating to PatientHomeScreen");
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => ChangeNotifierProvider(
// //                       create: (_) => PatientProvider()..setPatientId(userCredential.user!.uid),
// //                       child: const PatientHomeScreen(),
// //                     ),
// //                   ),
// //                 );
// //               } else if (role == 'doctor') {
// //                 dev.log("Navigating to DoctorAppointmentsPage");
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => DoctorAppointmentsPage(
// //                       doctorId: userCredential.user!.uid,
// //                       // Ensure 'name' field exists in your doctor's 'users' doc or fetch from 'doctors' collection
// //                       doctorName: (userDoc.data() as Map<String,dynamic>)['fullName'] as String? ?? 
// //                                   (userDoc.data() as Map<String,dynamic>)['name'] as String? ??
// //                                   'Doctor', 
// //                     ),
// //                   ),
// //                 );
// //               }
// //             }
// //           } else {
// //             dev.log("Role mismatch. DB role: $userRoleInDb, Attempted role: $role");
// //             if (mounted) {
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(content: Text('Role mismatch. Logged in as $userRoleInDb but attempted to access $role features.')),
// //               );
// //             }
// //             await _auth.signOut(); // Sign out if role mismatch
// //           }
// //         } else {
// //           dev.log("User document does not exist in 'users' collection for UID: ${userCredential.user!.uid}");
// //            if (mounted) {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               const SnackBar(content: Text('User profile not found. Please contact support.')),
// //             );
// //            }
// //            await _auth.signOut(); // Sign out if no user profile
// //         }
// //       } catch (e) {
// //         dev.log("Login failed: $e");
// //         if (mounted) {
// //           String errorMessage = "Login failed. Please check your credentials.";
// //           if (e is FirebaseAuthException) {
// //             if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
// //               errorMessage = 'Invalid email or password.';
// //             } else if (e.code == 'invalid-email') {
// //               errorMessage = 'The email address is badly formatted.';
// //             } else {
// //               errorMessage = 'An error occurred: ${e.message}';
// //             }
// //           }
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text(errorMessage)),
// //           );
// //         }
// //       } finally {
// //         if (mounted) {
// //           setState(() => _isLoading = false);
// //         }
// //       }
// //     } else {
// //       dev.log("Form validation failed.");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Login'),
// //         centerTitle: true,
// //       ),
// //       body: Center( // Center the content
// //         child: SingleChildScrollView( // Allow scrolling if content overflows
// //           padding: const EdgeInsets.all(24.0), // More padding
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center, // Center vertically
// //               crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch buttons
// //               children: [
// //                 Text(
// //                   'MediSync+',
// //                   textAlign: TextAlign.center,
// //                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
// //                         fontWeight: FontWeight.bold,
// //                         color: Theme.of(context).primaryColor,
// //                       ),
// //                 ),
// //                 const SizedBox(height: 30),
// //                 // Email TextFormField
// //                 TextFormField(
// //                   controller: _emailController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Email',
// //                     hintText: 'Enter your email',
// //                     prefixIcon: const Icon(Icons.email_outlined),
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8.0),
// //                     ),
// //                   ),
// //                   keyboardType: TextInputType.emailAddress,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter your email';
// //                     }
// //                     if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
// //                       return 'Please enter a valid email address';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 const SizedBox(height: 16),
// //                 // Password TextFormField
// //                 TextFormField(
// //                   controller: _passwordController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Password',
// //                     hintText: 'Enter your password',
// //                     prefixIcon: const Icon(Icons.lock_outline),
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8.0),
// //                     ),
// //                     // Add suffix icon for password visibility toggle if desired
// //                   ),
// //                   obscureText: true,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter your password';
// //                     }
// //                     if (value.length < 6) {
// //                       return 'Password must be at least 6 characters';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 const SizedBox(height: 24),
// //                 ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     padding: const EdgeInsets.symmetric(vertical: 12.0),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(8.0),
// //                     ),
// //                   ),
// //                   onPressed: _isLoading ? null : () => _handleLogin('patient'),
// //                   child: _isLoading 
// //                       ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
// //                       : const Text('Login as Patient'),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     padding: const EdgeInsets.symmetric(vertical: 12.0),
// //                      shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(8.0),
// //                     ),
// //                   ),
// //                   onPressed: _isLoading ? null : () => _handleLogin('doctor'),
// //                   child: _isLoading 
// //                       ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
// //                       : const Text('Login as Doctor'),
// //                 ),
// //                 // Add "Don't have an account? Sign Up" text/button if needed
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }



















// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:medi_sync_plus_app/pages/login_page/login_form.dart'; // Adjust path
// // import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart'; // Updated to dashboard
// // import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart'; // Assume this exists
// // import 'package:provider/provider.dart';
// // import 'package:medi_sync_plus_app/providers/patient_provider.dart'; // Assume this exists

// // class RoleLoginPage extends StatefulWidget {
// //   const RoleLoginPage({super.key});

// //   @override
// //   State<RoleLoginPage> createState() => _RoleLoginPageState();
// // }

// // class _RoleLoginPageState extends State<RoleLoginPage> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final _formKey = GlobalKey<FormState>();
// //   String? _email, _password;

// //   void _handleLogin(String role) async {
// //     if (_formKey.currentState!.validate()) {
// //       _formKey.currentState!.save();
// //       try {
// //         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
// //           email: _email!,
// //           password: _password!,
// //         );

// //         // Fetch user role from Firestore (e.g., 'users' collection)
// //         DocumentSnapshot userDoc = await _firestore
// //             .collection('users')
// //             .doc(userCredential.user!.uid)
// //             .get();

// //         if (userDoc.exists) {
// //           String userRole = userDoc['role'] as String? ?? 'patient'; // Default to patient if not set

// //           if (userRole == role) {
// //             if (mounted) {
// //               if (role == 'patient') {
// //                 // Navigate to PatientHomeScreen with PatientProvider
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => ChangeNotifierProvider(
// //                       create: (_) => PatientProvider()..setPatientId(userCredential.user!.uid),
// //                       child: const PatientHomeScreen(),
// //                     ),
// //                   ),
// //                 );
// //               } else if (role == 'doctor') {
// //                 // Navigate to DoctorAppointmentsPage
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => DoctorAppointmentsPage(
// //                       doctorId: userCredential.user!.uid,
// //                       doctorName: userDoc['name'] as String? ?? 'Doctor',
// //                     ),
// //                   ),
// //                 );
// //               }
// //             }
// //           } else {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               const SnackBar(content: Text('Role mismatch. Please log in with the correct account.')),
// //             );
// //             await _auth.signOut();
// //           }
// //         }
// //       } catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Login failed: $e')),
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Login')),
// //       body: SingleChildScrollView( // Add this to handle overflow
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min, // Prevent infinite height
// //               crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure children take full width
// //               children: [
// //                 LoginForm(
// //                   onEmailSaved: (value) => _email = value,
// //                   onPasswordSaved: (value) => _password = value,
// //                   role: '',
// //                 ),
// //                 const SizedBox(height: 20),
// //                 ElevatedButton(
// //                   onPressed: () => _handleLogin('patient'),
// //                   child: const Text('Login as Patient'),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 ElevatedButton(
// //                   onPressed: () => _handleLogin('doctor'),
// //                   child: const Text('Login as Doctor'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }






















// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:medi_sync_plus_app/pages/login_page/login_form.dart';
// // import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart';
// // import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart';
// // import 'package:provider/provider.dart';
// // import 'package:medi_sync_plus_app/providers/patient_provider.dart';
// // import 'package:medi_sync_plus_app/services/firestore_services.dart';

// // class RoleLoginPage extends StatefulWidget {
// //   const RoleLoginPage({super.key});

// //   @override
// //   State<RoleLoginPage> createState() => _RoleLoginPageState();
// // }

// // class _RoleLoginPageState extends State<RoleLoginPage> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final _formKey = GlobalKey<FormState>();
// //   String? _email, _password;
// //   bool _isLoading = false;
// //   String? _errorMessage;
// //   bool _isLogin = true; // Moved from LoginForm to here

// //   void _handleSubmit(String role) async {
// //     if (_formKey.currentState!.validate()) {
// //       _formKey.currentState!.save();
// //       setState(() {
// //         _isLoading = true;
// //         _errorMessage = null;
// //       });

// //       try {
// //         UserCredential userCredential;
// //         if (_isLogin) {
// //           userCredential = await _auth.signInWithEmailAndPassword(
// //             email: _email!,
// //             password: _password!,
// //           );
// //         } else {
// //           userCredential = await _auth.createUserWithEmailAndPassword(
// //             email: _email!,
// //             password: _password!,
// //           );

// //           // Sign-up: Add user to Firestore
// //           final String defaultNameFromEmail = _email!.split('@')[0];
// //           await _firestore.collection('users').doc(userCredential.user!.uid).set({
// //             'email': _email,
// //             'role': role,
// //             'name': defaultNameFromEmail,
// //             'createdAt': FieldValue.serverTimestamp(),
// //           });

// //           if (role == 'Doctor') {
// //             final firestoreService = FirestoreService();
// //             await firestoreService.addDoctor(
// //               userCredential.user!.uid,
// //               _email!,
// //               defaultNameFromEmail,
// //               'General Medicine',
// //               'hospital_1',
// //               'City General Hospital',
// //             );
// //           }
// //         }

// //         // Fetch user role from Firestore
// //         DocumentSnapshot userDoc = await _firestore
// //             .collection('users')
// //             .doc(userCredential.user!.uid)
// //             .get();

// //         if (userDoc.exists) {
// //           String userRole = userDoc['role'] as String? ?? 'patient';

// //           if (userRole != role) {
// //             await _auth.signOut();
// //             throw Exception('Role mismatch. Please log in with the correct account.');
// //           }

// //           if (mounted) {
// //             if (role == 'patient') {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => ChangeNotifierProvider(
// //                     create: (_) => PatientProvider()..setPatientId(userCredential.user!.uid),
// //                     child: const PatientHomeScreen(),
// //                   ),
// //                 ),
// //               );
// //             } else if (role == 'doctor') {
// //               final doctorQuery = await _firestore
// //                   .collection('doctors')
// //                   .where('email', isEqualTo: _email)
// //                   .limit(1)
// //                   .get();

// //               if (doctorQuery.docs.isEmpty) {
// //                 await _auth.signOut();
// //                 throw Exception('No doctor account found with this email.');
// //               }

// //               final doctorData = doctorQuery.docs.first.data();
// //               doctorData['uid'] ??= doctorQuery.docs.first.id;

// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => DoctorAppointmentsPage(
// //                     doctorId: doctorData['uid'] as String,
// //                     doctorName: doctorData['name'] as String? ?? 'Doctor',
// //                   ),
// //                 ),
// //               );
// //             }
// //           }
// //         } else {
// //           await _auth.signOut();
// //           throw Exception('User profile not found. Please sign up again.');
// //         }
// //       } on FirebaseAuthException catch (e) {
// //         setState(() {
// //           if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
// //             _errorMessage = 'Invalid email or password.';
// //           } else if (e.code == 'wrong-password') {
// //             _errorMessage = 'Invalid email or password.';
// //           } else if (e.code == 'email-already-in-use') {
// //             _errorMessage = 'An account already exists for that email.';
// //           } else if (e.code == 'weak-password') {
// //             _errorMessage = 'The password provided is too weak.';
// //           } else {
// //             _errorMessage = e.message ?? 'An authentication error occurred.';
// //           }
// //         });
// //       } catch (e) {
// //         setState(() {
// //           _errorMessage = 'An unexpected error occurred: $e';
// //         });
// //       } finally {
// //         if (mounted) {
// //           setState(() {
// //             _isLoading = false;
// //           });
// //         }
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Sign Up')),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               LoginForm(
// //                 role: '',
// //                 onEmailSaved: (value) => _email = value,
// //                 onPasswordSaved: (value) => _password = value,
// //               ),
// //               const SizedBox(height: 20),
// //               if (_errorMessage != null)
// //                 Padding(
// //                   padding: const EdgeInsets.only(bottom: 12.0),
// //                   child: Text(
// //                     _errorMessage!,
// //                     style: const TextStyle(color: Colors.red, fontSize: 14),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ),
// //               _isLoading
// //                   ? const Center(child: CircularProgressIndicator())
// //                   : Column(
// //                       children: [
// //                         ElevatedButton(
// //                           onPressed: () => _handleSubmit('patient'),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.teal[600],
// //                             foregroundColor: Colors.white,
// //                             padding: const EdgeInsets.symmetric(vertical: 14.0),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(8.0),
// //                             ),
// //                           ),
// //                           child: Text(_isLogin ? 'Login as Patient' : 'Sign Up as Patient'),
// //                         ),
// //                         const SizedBox(height: 10),
// //                         ElevatedButton(
// //                           onPressed: () => _handleSubmit('doctor'),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.teal[600],
// //                             foregroundColor: Colors.white,
// //                             padding: const EdgeInsets.symmetric(vertical: 14.0),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(8.0),
// //                             ),
// //                           ),
// //                           child: Text(_isLogin ? 'Login as Doctor' : 'Sign Up as Doctor'),
// //                         ),
// //                       ],
// //                     ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }




























// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:medi_sync_plus_app/pages/login_page/login_form.dart';
// // import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart';
// // import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart';
// // import 'package:provider/provider.dart';
// // import 'package:medi_sync_plus_app/providers/patient_provider.dart';
// // import 'package:medi_sync_plus_app/services/firestore_services.dart';
// // import 'dart:developer' as dev;

// // class RoleLoginPage extends StatefulWidget {
// //   const RoleLoginPage({super.key});

// //   @override
// //   State<RoleLoginPage> createState() => _RoleLoginPageState();
// // }

// // class _RoleLoginPageState extends State<RoleLoginPage> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final _formKey = GlobalKey<FormState>();
// //   String? _email, _password;
// //   bool _isLoading = false;
// //   String? _errorMessage;
// //   bool _isLogin = true; // Manage login/signup toggle state here

// //   void _handleSubmit() async {
// //     if (_formKey.currentState!.validate()) {
// //       _formKey.currentState!.save();
// //       setState(() {
// //         _isLoading = true;
// //         _errorMessage = null;
// //       });

// //       try {
// //         UserCredential userCredential;
// //         if (_isLogin) {
// //           dev.log("Attempting login with email: $_email");
// //           userCredential = await _auth.signInWithEmailAndPassword(
// //             email: _email!,
// //             password: _password!,
// //           );
// //         } else {
// //           dev.log("Attempting signup with email: $_email");
// //           userCredential = await _auth.createUserWithEmailAndPassword(
// //             email: _email!,
// //             password: _password!,
// //           );

// //           // Add user to Firestore on signup
// //           final String defaultNameFromEmail = _email!.split('@')[0];
// //           await _firestore.collection('users').doc(userCredential.user!.uid).set({
// //             'email': _email,
// //             'role': 'patient', // Default to patient; adjust based on role selection if needed
// //             'name': defaultNameFromEmail,
// //             'createdAt': FieldValue.serverTimestamp(),
// //           });

// //           if (userCredential.user!.uid == 'doctor') { // Adjust condition based on role
// //             final firestoreService = FirestoreService();
// //             await firestoreService.addDoctor(
// //               userCredential.user!.uid,
// //               _email!,
// //               defaultNameFromEmail,
// //               'General Medicine',
// //               'hospital_1',
// //               'City General Hospital',
// //             );
// //           }
// //         }

// //         // Fetch user role from Firestore
// //         DocumentSnapshot userDoc = await _firestore
// //             .collection('users')
// //             .doc(userCredential.user!.uid)
// //             .get();

// //         if (userDoc.exists) {
// //           String userRole = userDoc['role'] as String? ?? 'patient';
// //           dev.log("User role from Firestore: $userRole");

// //           if (userRole == 'patient') {
// //             if (mounted) {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => ChangeNotifierProvider(
// //                     create: (_) => PatientProvider()..setPatientId(userCredential.user!.uid),
// //                     child: const PatientHomeScreen(),
// //                   ),
// //                 ),
// //               );
// //             }
// //           } else if (userRole == 'doctor') {
// //             final doctorQuery = await _firestore
// //                 .collection('doctors')
// //                 .where('email', isEqualTo: _email)
// //                 .limit(1)
// //                 .get();

// //             if (doctorQuery.docs.isEmpty) {
// //               await _auth.signOut();
// //               throw Exception('No doctor account found with this email.');
// //             }

// //             final doctorData = doctorQuery.docs.first.data();
// //             doctorData['uid'] ??= doctorQuery.docs.first.id;

// //             if (mounted) {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => DoctorAppointmentsPage(
// //                     doctorId: doctorData['uid'] as String,
// //                     doctorName: doctorData['name'] as String? ?? 'Doctor',
// //                   ),
// //                 ),
// //               );
// //             }
// //           } else {
// //             await _auth.signOut();
// //             throw Exception('Unsupported role: $userRole');
// //           }
// //         } else {
// //           await _auth.signOut();
// //           throw Exception('User profile not found.');
// //         }
// //       } on FirebaseAuthException catch (e) {
// //         dev.log("FirebaseAuthException: ${e.code} - ${e.message}");
// //         setState(() {
// //           _errorMessage = e.code == 'user-not-found' || e.code == 'wrong-password'
// //               ? 'Invalid email or password.'
// //               : e.message ?? 'Authentication failed.';
// //         });
// //       } catch (e) {
// //         dev.log("General exception: $e");
// //         setState(() {
// //           _errorMessage = 'An unexpected error occurred: $e';
// //         });
// //       } finally {
// //         if (mounted) {
// //           setState(() {
// //             _isLoading = false;
// //           });
// //         }
// //       }
// //     }
// //   }

// //   void _toggleFormMode() {
// //     setState(() {
// //       _isLogin = !_isLogin;
// //       _email = null;
// //       _password = null; // Reset saved values
// //     });
// //     dev.log('Toggled to ${_isLogin ? "Login" : "Sign Up"} mode');
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Sign Up')),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: LoginForm(
// //           role: 'patient', // Adjust based on dynamic role selection if needed
// //           onEmailSaved: (value) => _email = value,
// //           onPasswordSaved: (value) => _password = value,
// //           onSubmit: _handleSubmit,
// //           isLoading: _isLoading,
// //           errorMessage: _errorMessage,
// //           isLogin: _isLogin,
// //         ),
// //     ),
// // );
// // }
// // }





















// // lib/pages/login_page/role_login_page.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:medi_sync_plus_app/pages/login_page/login_form.dart'; // Your LoginForm
// import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart'; // Ensure PatientHomeScreen is defined
// import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart';
// import 'package:provider/provider.dart';
// import 'package:medi_sync_plus_app/providers/patient_provider.dart';
// import 'package:medi_sync_plus_app/services/firestore_services.dart';
// import 'dart:developer' as dev;

// class RoleLoginPage extends StatefulWidget {
//   const RoleLoginPage({super.key});

//   @override
//   State<RoleLoginPage> createState() => _RoleLoginPageState();
// }

// class _RoleLoginPageState extends State<RoleLoginPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool _isLoading = false;
//   String? _errorMessage;
//   bool _isLoginMode = true; // True for Login, False for Sign Up
//   String _selectedRole = 'patient'; // Default role, can be changed by UI

//   // This function is called by LoginForm's onSubmitAttempt
//   Future<void> _performAuthOperation(String email, String password, bool isLoginAttempt) async {
//     // The 'role' is now taken from _selectedRole state variable
//     final String roleForAuth = _selectedRole;

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//     dev.log(
//         "RoleLoginPage: Auth attempt. Email: $email, Role: $roleForAuth, isLogin: $isLoginAttempt");

//     try {
//       UserCredential userCredential;
//       if (isLoginAttempt) {
//         dev.log("Attempting Sign In...");
//         userCredential = await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//       } else { // Sign Up
//         dev.log("Attempting Sign Up...");
//         userCredential = await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         dev.log("Sign Up successful, creating user document for UID: ${userCredential.user!.uid}");
//         final String defaultNameFromEmail = email.split('@')[0];
//         await _firestore.collection('users').doc(userCredential.user!.uid).set({
//           'email': email,
//           'role': roleForAuth,
//           'fullName': defaultNameFromEmail,
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//         dev.log("User document created in 'users' collection.");

//         if (roleForAuth == 'doctor') {
//           dev.log("Signing up as Doctor, adding to 'doctors' collection.");
//           final firestoreService = FirestoreService();
//           await firestoreService.addDoctor(
//             userCredential.user!.uid,
//             email,
//             defaultNameFromEmail,
//             'General Medicine', // Default
//             'hosp_000',         // Default (should be a valid ID from your hospitals)
//             'Default Clinic',   // Default
//           );
//           dev.log("Doctor added to 'doctors' collection.");
//         }
//       }

//       dev.log("Auth operation successful for UID: ${userCredential.user!.uid}. Fetching user document...");
//       DocumentSnapshot userDoc = await _firestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();

//       if (!userDoc.exists) {
//         dev.log("User document NOT FOUND after auth for UID: ${userCredential.user!.uid}.");
//         await _auth.signOut();
//         throw Exception('User profile not found. Please try signing up again or contact support.');
//       }

//       String userRoleInDb = userDoc['role'] as String? ?? 'patient';
//       dev.log("User role in DB: $userRoleInDb. Expected role: $roleForAuth");

//       if (isLoginAttempt && userRoleInDb != roleForAuth) {
//         await _auth.signOut();
//         throw Exception(
//             'Role mismatch. You are registered as $userRoleInDb. Please select the correct role to log in.');
//       }
//       dev.log("Role check passed. Navigating to dashboard...");

//       if (!mounted) {
//         dev.log("Widget not mounted after auth logic. Aborting navigation.");
//         return; // Explicit return for "body_might_complete_normally"
//       }

//       if (roleForAuth == 'patient') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChangeNotifierProvider(
//               create: (_) => PatientProvider()..setPatientId(userCredential.user!.uid),
//               child: const PatientHomeScreen(),
//             ),
//           ),
//         );
//       } else if (roleForAuth == 'doctor') {
//         String doctorDisplayName = (userDoc.data() as Map<String,dynamic>?)?['fullName'] as String? ??
//                                     (userDoc.data() as Map<String,dynamic>?)?['name'] as String? ??
//                                     'Doctor';
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DoctorAppointmentsPage(
//               doctorId: userCredential.user!.uid,
//               doctorName: doctorDisplayName,
//             ),
//           ),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       dev.log("FirebaseAuthException in RoleLoginPage: ${e.code} - ${e.message}");
//       if (mounted) {
//         setState(() {
//           if (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'wrong-password') {
//             _errorMessage = 'Invalid email or password.';
//           } else if (e.code == 'email-already-in-use') {
//             _errorMessage = 'An account already exists for that email.';
//           } else if (e.code == 'weak-password') {
//             _errorMessage = 'The password provided is too weak.';
//           } else {
//             _errorMessage = e.message ?? 'An authentication error occurred.';
//           }
//         });
//       }
//     } catch (e) {
//       dev.log("Generic Error in RoleLoginPage: $e");
//       if (mounted) {
//         setState(() {
//           _errorMessage = 'An unexpected error occurred: ${e.toString().replaceAll("Exception: ", "")}';
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   void _toggleLoginMode() {
//     setState(() {
//       _isLoginMode = !_isLoginMode;
//       _errorMessage = null;
//       // The LoginForm's internal _formKey will reset its fields if LoginForm has a ValueKey that changes.
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isLoginMode ? 'Login' : 'Create Account'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 'MediSync+',
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//               ),
//               const SizedBox(height: 20),
//               // Role Selection (Example: Segmented Button)
//               SegmentedButton<String>(
//                 segments: const <ButtonSegment<String>>[
//                   ButtonSegment<String>(value: 'patient', label: Text('Patient'), icon: Icon(Icons.person_outline)),
//                   ButtonSegment<String>(value: 'doctor', label: Text('Doctor'), icon: Icon(Icons.medical_services_outlined)),
//                 ],
//                 selected: <String>{_selectedRole},
//                 onSelectionChanged: (Set<String> newSelection) {
//                   setState(() {
//                     _selectedRole = newSelection.first;
//                     _errorMessage = null; // Clear error when role changes
//                   });
//                   dev.log("Role selected: $_selectedRole");
//                 },
//                 style: SegmentedButton.styleFrom(
//                   // backgroundColor: Colors.grey[200],
//                   selectedForegroundColor: Colors.white,
//                   selectedBackgroundColor: Theme.of(context).primaryColor,
//                   // foregroundColor: Theme.of(context).primaryColor,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // LoginForm now takes the onSubmitAttempt callback
//               LoginForm(
//                 key: ValueKey(_isLoginMode.toString() + _selectedRole), // Key to reset form state when mode or role changes
//                 isLoginMode: _isLoginMode,
//                 onSubmitAttempt: (email, password, isLoginAttemptFromForm) {
//                   // Call _performAuthOperation. The 'role' is taken from _selectedRole state.
//                   // isLoginAttemptFromForm is essentially _isLoginMode.
//                   _performAuthOperation(email, password, isLoginAttemptFromForm);
//                 },
//                 onToggleMode: _toggleLoginMode,
//               ),
//               const SizedBox(height: 12),
//               if (_errorMessage != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                   child: Text(
//                     _errorMessage!,
//                     style: const TextStyle(color: Colors.red, fontSize: 14),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               // The main submission is now handled by the button INSIDE LoginForm.
//               // The buttons "Login as Patient" and "Login as Doctor" are removed
//               // because the role selection is now handled by the SegmentedButton
//               // and the LoginForm has its own "Login/Sign Up" button.
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Dummy PatientHomeScreen for compilation
// class PatientHomeScreen extends StatelessWidget {
//   const PatientHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar(title: const Text('Patient Dashboard')), body: const Center(child: Text('Welcome Patient!')));
//   }
// }






























// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:medi_sync_plus_app/pages/login_page/login_form.dart';
// import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart'; // Assuming PatientHomeScreen is here
// import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart';
// import 'package:medi_sync_plus_app/pages/patient/appointment_booking_page.dart'; // For patient navigation after login
// import 'package:provider/provider.dart';
// import 'package:medi_sync_plus_app/providers/patient_provider.dart';
// import 'package:medi_sync_plus_app/services/firestore_services.dart';
// import 'dart:developer' as dev;

// class RoleLoginPage extends StatefulWidget {
//   const RoleLoginPage({super.key});

//   @override
//   State<RoleLoginPage> createState() => _RoleLoginPageState();
// }

// class _RoleLoginPageState extends State<RoleLoginPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool _isLoadingPage = false; // For overall page loading state (e.g., during auth)
//   String? _errorMessage;
//   bool _isLoginMode = true; // True for Login, False for Sign Up
//   String _selectedRole = 'patient'; // Default role, user can change this

//   // This function is called by LoginForm's `onSubmitAttempt` callback
//   Future<void> _performAuthOperation(String email, String password, bool isLoginAttemptFromForm) async {
//     // The 'roleForAuth' is taken from the _selectedRole state variable,
//     // which is controlled by the SegmentedButton in this widget.
//     final String roleForAuth = _selectedRole;

//     // The 'isLoginAttempt' is passed from LoginForm, which should align with '_isLoginMode' here.
//     // We use 'isLoginAttemptFromForm' for clarity.
//     if (!mounted) return;
//     setState(() {
//       _isLoadingPage = true;
//       _errorMessage = null;
//     });
//     dev.log("RoleLoginPage: Auth attempt. Email: $email, Role: $roleForAuth, isLogin: $isLoginAttemptFromForm");

//     try {
//       UserCredential userCredential;
//       if (isLoginAttemptFromForm) {
//         dev.log("Attempting Sign In for role $roleForAuth...");
//         userCredential = await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//       } else { // Sign Up
//         dev.log("Attempting Sign Up for role $roleForAuth...");
//         userCredential = await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         dev.log("Sign Up successful, creating user document for UID: ${userCredential.user!.uid}");
//         final String defaultNameFromEmail = email.split('@')[0]; // Simple default name
//         await _firestore.collection('users').doc(userCredential.user!.uid).set({
//           'email': email,
//           'role': roleForAuth, // Set the role selected by the user
//           'fullName': defaultNameFromEmail, // Use fullName for consistency
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//         dev.log("User document created in 'users' collection with role: $roleForAuth.");

//         if (roleForAuth == 'doctor') {
//           dev.log("Signing up as Doctor, adding to 'doctors' collection.");
//           final firestoreService = FirestoreService();
//           // Ensure addDoctor in FirestoreService is compatible with the new doctor structure
//           await firestoreService.addDoctor(
//             userCredential.user!.uid,
//             email,
//             defaultNameFromEmail, // This should be fullName
//             'General Medicine', // Default or prompt for actual specialty ID
//             'hosp_001',         // Placeholder: Ensure this is a valid ID from your 'hospitals'
//             'City General Hospital', // Placeholder: Name of the hospital
//           );
//           dev.log("Doctor added to 'doctors' collection.");
//         }
//       }

//       dev.log("Auth operation successful for UID: ${userCredential.user!.uid}. Fetching user document...");
//       DocumentSnapshot userDoc = await _firestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();

//       if (!userDoc.exists) {
//         dev.log("User document NOT FOUND after auth for UID: ${userCredential.user!.uid}. This is unexpected.");
//         await _auth.signOut(); // Clean up inconsistent state
//         throw Exception('User profile not found. Please try signing up again or contact support.');
//       }

//       String userRoleInDb = userDoc['role'] as String? ?? 'patient'; // Default if role field is missing
//       dev.log("User role in DB: $userRoleInDb. Expected role (from selection): $roleForAuth");

//       // This check is most crucial for login. For signup, role should match what was just written.
//       if (isLoginAttemptFromForm && userRoleInDb != roleForAuth) {
//         await _auth.signOut();
//         throw Exception(
//             'Role mismatch. You are registered as "$userRoleInDb". Please select "$userRoleInDb" to log in.');
//       }
//       dev.log("Role check passed. Navigating to appropriate dashboard...");

//       if (!mounted) {
//         dev.log("Widget not mounted after auth logic. Aborting navigation.");
//         return; // Explicit return
//       }

//       if (roleForAuth == 'patient') {
//         // Using Provider for patient state management
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChangeNotifierProvider(
//               create: (_) => PatientProvider()..setPatientId(userCredential.user!.uid),
//               // child: const PatientHomeScreen(), // Or directly to AppointmentBookingPage
//               child: const AppointmentBookingPage(), // Navigate patient directly to booking
//             ),
//           ),
//         );
//       } else if (roleForAuth == 'doctor') {
//         String doctorDisplayName = 
//             (userDoc.data() as Map<String,dynamic>?)?['fullName'] as String? ?? // Prefer fullName
//             (userDoc.data() as Map<String,dynamic>?)?['name'] as String? ??     // Fallback to name
//             'Doctor'; // Final fallback
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DoctorAppointmentsPage(
//               doctorId: userCredential.user!.uid, // Doctor's UID is the user's UID
//               doctorName: doctorDisplayName,
//             ),
//           ),
//         );
//       }
//       return; // Ensure all paths either navigate or return explicitly

//     } on FirebaseAuthException catch (e) {
//       dev.log("FirebaseAuthException in RoleLoginPage: ${e.code} - ${e.message}");
//       if (mounted) {
//         setState(() {
//           if (e.code == 'user-not-found' || 
//               e.code == 'invalid-credential' || 
//               e.code == 'wrong-password' ||
//               e.code == 'INVALID_LOGIN_CREDENTIALS' /* newer SDKs */) {
//             _errorMessage = 'Invalid email or password.';
//           } else if (e.code == 'email-already-in-use') {
//             _errorMessage = 'An account already exists for that email.';
//           } else if (e.code == 'weak-password') {
//             _errorMessage = 'The password provided is too weak (must be at least 6 characters).';
//           } else {
//             _errorMessage = e.message ?? 'An authentication error occurred. Please try again.';
//           }
//         });
//       }
//     } catch (e) {
//       dev.log("Generic Error in RoleLoginPage: $e");
//       if (mounted) {
//         setState(() {
//           _errorMessage = 'An unexpected error occurred: ${e.toString().replaceAll("Exception: ", "")}';
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingPage = false;
//         });
//       }
//     }
//   }

//   // Toggles between Login and Sign Up mode for the LoginForm
//   void _toggleLoginMode() {
//     if (!mounted) return;
//     setState(() {
//       _isLoginMode = !_isLoginMode;
//       _errorMessage = null; // Clear previous errors when mode changes
//     });
//     dev.log("Toggled login mode. isLoginMode: $_isLoginMode");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isLoginMode ? 'Login' : 'Create Account'),
//         centerTitle: true,
//       ),
//       body: Stack( // Use Stack to overlay a loading indicator for the whole page
//         children: [
//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     'MediSync+',
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Role Selection (e.g., Patient or Doctor)
//                   SegmentedButton<String>(
//                     segments: const <ButtonSegment<String>>[
//                       ButtonSegment<String>(value: 'patient', label: Text('Patient'), icon: Icon(Icons.person_outline)),
//                       ButtonSegment<String>(value: 'doctor', label: Text('Doctor'), icon: Icon(Icons.medical_services_outlined)),
//                     ],
//                     selected: <String>{_selectedRole}, // Must be a Set
//                     onSelectionChanged: (Set<String> newSelection) {
//                       if (_isLoadingPage) return; // Don't change role while an auth operation is in progress
//                       setState(() {
//                         _selectedRole = newSelection.first;
//                         _errorMessage = null; // Clear error when role changes
//                       });
//                       dev.log("Role selected: $_selectedRole");
//                     },
//                     style: SegmentedButton.styleFrom(
//                       selectedForegroundColor: Colors.white,
//                       selectedBackgroundColor: Theme.of(context).primaryColor,
//                       // Adjust other styling as needed from your theme
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // The LoginForm widget
//                   LoginForm(
//                     // Add a ValueKey that changes when _isLoginMode or _selectedRole changes.
//                     // This tells Flutter to rebuild (and thus reset the state of) LoginForm,
//                     // clearing its internal text fields and form state if desired.
//                     key: ValueKey(_isLoginMode.toString() + _selectedRole),
//                     isLoginMode: _isLoginMode,
//                     onSubmitAttempt: _performAuthOperation, // Pass the callback
//                     onToggleMode: _toggleLoginMode,         // Pass the callback
//                   ),
//                   const SizedBox(height: 12),
//                   // Display error messages from RoleLoginPage
//                   if (_errorMessage != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                       child: Text(
//                         _errorMessage!,
//                         style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//           // Full-page loading indicator, controlled by _isLoadingPage
//           if (_isLoadingPage)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black.withOpacity(0.1), // Semi-transparent overlay
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // Dummy PatientHomeScreen for compilation and basic navigation test
// // Replace this with your actual PatientHomeScreen if it's in a different file
// // or ensure 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart' defines it.
// class PatientHomeScreen extends StatelessWidget {
//   const PatientHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Patient Dashboard')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Welcome Patient! This is your Home Screen.'),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Example navigation to AppointmentBookingPage
//                 Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AppointmentBookingPage()));
//               },
//               child: const Text("Book New Appointment"),
//             ),
//              const SizedBox(height: 20),
//             ElevatedButton( // Example sign out
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//                 if (context.mounted) {
//                    Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (context) => const RoleLoginPage()),
//                     (Route<dynamic> route) => false,
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//               child: const Text("Sign Out"),
//             )
//           ],
//         ),
//       ));
//   }
// }

































import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medi_sync_plus_app/pages/login_page/login_form.dart';
import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart'; // Assuming PatientHomeScreen is here
import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart';
import 'package:medi_sync_plus_app/pages/patient/appointment_booking_page.dart';
import 'package:provider/provider.dart';
import 'package:medi_sync_plus_app/providers/patient_provider.dart';
import 'package:medi_sync_plus_app/services/firestore_services.dart';
import 'dart:developer' as dev;

class RoleLoginPage extends StatefulWidget {
  const RoleLoginPage({super.key});

  @override
  State<RoleLoginPage> createState() => _RoleLoginPageState();
}

class _RoleLoginPageState extends State<RoleLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoadingPage = false;
  String? _errorMessage;
  bool _isLoginMode = true;
  String _selectedRole = 'patient';

  Future<void> _performAuthOperation(String email, String password, bool isLoginAttemptFromForm) async {
    final String roleForAuth = _selectedRole.trim().toLowerCase(); // Ensure normalized role is used

    if (!mounted) return;
    setState(() {
      _isLoadingPage = true;
      _errorMessage = null;
    });
    dev.log(
        "RoleLoginPage: Auth attempt. Email: $email, Role: '$roleForAuth', isLogin: $isLoginAttemptFromForm");

    try {
      UserCredential userCredential;
      if (isLoginAttemptFromForm) {
        dev.log("Attempting Sign In for role '$roleForAuth'...");
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else { // Sign Up
        dev.log("Attempting Sign Up for role '$roleForAuth'...");
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        dev.log("Sign Up successful, creating user document for UID: ${userCredential.user!.uid}");
        final String defaultNameFromEmail = email.split('@')[0];
        
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'role': roleForAuth, // Already normalized
          'fullName': defaultNameFromEmail,
          'createdAt': FieldValue.serverTimestamp(),
        });
        dev.log("User document created in 'users' collection with role: '$roleForAuth'.");

        if (roleForAuth == 'doctor') {
          dev.log("Signing up as Doctor, adding to 'doctors' collection.");
          final firestoreService = FirestoreService();
          await firestoreService.addDoctor( // This method needs to be aligned with new doctor structure
            userCredential.user!.uid,
            email,
            defaultNameFromEmail,
            'generalMedicine', // Example: Use a valid specialtyId (lowercase, no spaces)
            'hosp_001',        // Example: Use a valid hospitalId from your seeded data
            'Metro Health Central', // Example: Name of the hospital
          );
          dev.log("Doctor added to 'doctors' collection.");
        }
      }

      dev.log("Auth operation successful for UID: ${userCredential.user!.uid}. Fetching user document...");
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        dev.log("User document NOT FOUND after auth for UID: ${userCredential.user!.uid}.");
        await _auth.signOut(); 
        throw Exception('User profile not found. Please try signing up again or contact support.');
      }

      String userRoleInDb = (userDoc['role'] as String? ?? 'patient').trim().toLowerCase();
      // roleForAuth is already normalized

      dev.log("User role in DB (normalized): '$userRoleInDb'. Expected role (normalized from selection): '$roleForAuth'");

      if (isLoginAttemptFromForm && userRoleInDb != roleForAuth) {
        await _auth.signOut();
        throw Exception(
            'Role mismatch. Account role is "$userRoleInDb". Please select "$roleForAuth" to log in.');
      }
      dev.log("Role check passed. Navigating to appropriate dashboard...");

      if (!mounted) {
        dev.log("Widget not mounted after auth logic. Aborting navigation.");
        return; 
      }

      if (roleForAuth == 'patient') {
        dev.log("Navigating to PatientHomeScreen for patient UID: ${userCredential.user!.uid}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => PatientProvider()..setPatientId(userCredential.user!.uid),
              child: const PatientHomeScreen(), // Navigate to dashboard
            ),
          ),
        );
      } else if (roleForAuth == 'doctor') {
        dev.log("Navigating to DoctorAppointmentsPage for doctor UID: ${userCredential.user!.uid}");
        String doctorDisplayName = 
            (userDoc.data() as Map<String,dynamic>?)?['fullName'] as String? ??
            (userDoc.data() as Map<String,dynamic>?)?['name'] as String? ??
            'Doctor';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorAppointmentsPage(
              doctorId: userCredential.user!.uid, 
              doctorName: doctorDisplayName,
            ),
          ),
        );
      }
      return; 

    } on FirebaseAuthException catch (e) {
      dev.log("FirebaseAuthException in RoleLoginPage: ${e.code} - ${e.message}");
      if (mounted) {
        setState(() {
          if (e.code == 'user-not-found' || 
              e.code == 'invalid-credential' || 
              e.code == 'wrong-password' ||
              e.code == 'INVALID_LOGIN_CREDENTIALS') {
            _errorMessage = 'Invalid email or password.';
          } else if (e.code == 'email-already-in-use') {
            _errorMessage = 'An account already exists for that email.';
          } else if (e.code == 'weak-password') {
            _errorMessage = 'The password provided is too weak (must be at least 6 characters).';
          } else {
            _errorMessage = e.message ?? 'An authentication error occurred. Please try again.';
          }
        });
      }
    } catch (e) {
      dev.log("Generic Error in RoleLoginPage: $e");
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

  void _toggleLoginMode() {
    if (!mounted) return;
    setState(() {
      _isLoginMode = !_isLoginMode;
      _errorMessage = null; 
    });
    dev.log("Toggled login mode. isLoginMode: $_isLoginMode");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Login' : 'Create Account'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'MediSync+',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 20),
                  SegmentedButton<String>(
                    segments: const <ButtonSegment<String>>[
                      ButtonSegment<String>(value: 'patient', label: Text('Patient'), icon: Icon(Icons.person_outline)),
                      ButtonSegment<String>(value: 'doctor', label: Text('Doctor'), icon: Icon(Icons.medical_services_outlined)),
                    ],
                    selected: <String>{_selectedRole},
                    onSelectionChanged: (Set<String> newSelection) {
                      if (_isLoadingPage) return;
                      setState(() {
                        _selectedRole = newSelection.first;
                        _errorMessage = null;
                      });
                      dev.log("Role selected: $_selectedRole");
                    },
                    style: SegmentedButton.styleFrom(
                      selectedForegroundColor: Colors.white,
                      selectedBackgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LoginForm(
                    key: ValueKey(_isLoginMode.toString() + _selectedRole),
                    isLoginMode: _isLoginMode,
                    onSubmitAttempt: _performAuthOperation,
                    onToggleMode: _toggleLoginMode,
                  ),
                  const SizedBox(height: 12),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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

