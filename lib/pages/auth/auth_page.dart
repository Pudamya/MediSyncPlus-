// // lib/pages/auth/auth_page.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:medi_sync_plus_app/pages/auth/login_form_widget.dart';
// import 'package:medi_sync_plus_app/pages/auth/signup_role_selection_page.dart';
// import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart';
// import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart';
// // Import PharmacistDashboard when ready
// // import 'package:medi_sync_plus_app/pages/pharmacist/pharmacist_dashboard.dart';
// import 'package:provider/provider.dart';
// import 'package:medi_sync_plus_app/providers/patient_provider.dart';
// import 'dart:developer' as dev;

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool _isLoadingPage = false;
//   String? _errorMessage;

//   Future<void> _handleLogin(String email, String password) async {
//     if (!mounted) return;
//     setState(() {
//       _isLoadingPage = true;
//       _errorMessage = null;
//     });
//     dev.log("AuthPage: Login attempt. Email: $email");

//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       dev.log("AuthPage: Login successful for UID: ${userCredential.user!.uid}. Fetching user document...");

//       DocumentSnapshot userDoc = await _firestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();

//       if (!userDoc.exists || userDoc.data() == null) {
//         dev.log("AuthPage: User document NOT FOUND after login for UID: ${userCredential.user!.uid}.");
//         await _auth.signOut();
//         throw Exception('User profile not found. Please contact support.');
//       }

//       var userData = userDoc.data() as Map<String, dynamic>;
//       String userRoleInDb = (userData['role'] as String? ?? 'patient').trim().toLowerCase();
//       dev.log("AuthPage: User role from DB: '$userRoleInDb'");

//       if (!mounted) return;

//       _navigateToDashboard(userRoleInDb, userCredential.user!.uid, userData);

//     } on FirebaseAuthException catch (e) {
//       dev.log("AuthPage: FirebaseAuthException during login: ${e.code} - ${e.message}");
//       if (mounted) {
//         setState(() {
//           if (e.code == 'user-not-found' ||
//               e.code == 'invalid-credential' ||
//               e.code == 'wrong-password' ||
//               e.code == 'INVALID_LOGIN_CREDENTIALS') { // For newer SDK versions
//             _errorMessage = 'Invalid email or password.';
//           } else {
//             _errorMessage = e.message ?? 'An authentication error occurred.';
//           }
//         });
//       }
//     } catch (e) {
//       dev.log("AuthPage: Generic error during login: $e");
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

//   void _navigateToDashboard(String role, String uid, Map<String, dynamic> userData) {
//     dev.log("AuthPage: Navigating to dashboard for role '$role', UID: $uid");
//     Widget nextPage;
//     String userName = userData['fullName'] as String? ?? userData['name'] as String? ?? uid;

//     switch (role) {
//       case 'patient':
//         nextPage = ChangeNotifierProvider(
//           create: (_) => PatientProvider()..setPatientId(uid),
//           child: const PatientHomeScreen(),
//         );
//         break;
//       case 'doctor':
//         nextPage = DoctorAppointmentsPage(
//           doctorId: uid,
//           doctorName: userName,
//         );
//         break;
//       case 'pharmacist':
//       // TODO: Replace with actual PharmacistDashboard
//         nextPage = Scaffold(body: Center(child: Text('Pharmacist Dashboard for $userName (UID: $uid)')));
//         dev.log("AuthPage: Placeholder for Pharmacist Dashboard.");
//         break;
//       default:
//         dev.log("AuthPage: Unknown role '$role'. Defaulting to login with error.");
//         _auth.signOut(); // Sign out user with unknown role
//          if (mounted) {
//             setState(() {
//                 _errorMessage = "Unknown user role '$role'. Please contact support.";
//                 _isLoadingPage = false;
//             });
//         }
//         return; // Do not navigate
//     }

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => nextPage),
//     );
//   }


//   void _goToSignUpRoleSelection() {
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignUpRoleSelectionPage()));
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         centerTitle: true,
//       ),
//       body: Stack(
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
//                   const SizedBox(height: 30), // Increased spacing
//                   LoginFormWidget( // Use the renamed widget
//                     isLoginMode: true, // Always login mode here
//                     onSubmit: _handleLogin,
//                     onToggleToSignUp: _goToSignUpRoleSelection,
//                   ),
//                   const SizedBox(height: 12),
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
//           if (_isLoadingPage)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black.withOpacity(0.1),
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }









// // lib/pages/auth/auth_page.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In
// import 'package:medi_sync_plus_app/pages/auth/login_form_widget.dart';
// import 'package:medi_sync_plus_app/pages/auth/signup_role_selection_page.dart';
// import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart';
// import 'package:medi_sync_plus_app/pages/doctor/doctor_appointments_page.dart';
// // Import PharmacistDashboard when ready
// import 'package:provider/provider.dart';
// import 'package:medi_sync_plus_app/providers/patient_provider.dart';
// import 'dart:developer' as dev;

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn(); // Add GoogleSignIn instance

//   bool _isLoadingPage = false;
//   String? _errorMessage;

//   // ... _handleLogin and _navigateToDashboard remain the same ...
//   Future<void> _handleLogin(String email, String password) async {
//     // ... (existing code for email/password login)
//      if (!mounted) return;
//     setState(() {
//       _isLoadingPage = true;
//       _errorMessage = null;
//     });
//     dev.log("AuthPage: Login attempt. Email: $email");

//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       dev.log("AuthPage: Login successful for UID: ${userCredential.user!.uid}. Fetching user document...");

//       DocumentSnapshot userDoc = await _firestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();

//       if (!userDoc.exists || userDoc.data() == null) {
//         dev.log("AuthPage: User document NOT FOUND after login for UID: ${userCredential.user!.uid}.");
//         await _auth.signOut();
//         throw Exception('User profile not found. Please contact support.');
//       }

//       var userData = userDoc.data() as Map<String, dynamic>;
//       String userRoleInDb = (userData['role'] as String? ?? 'patient').trim().toLowerCase();
//       dev.log("AuthPage: User role from DB: '$userRoleInDb'");

//       if (!mounted) return;

//       _navigateToDashboard(userRoleInDb, userCredential.user!.uid, userData);

//     } on FirebaseAuthException catch (e) {
//       dev.log("AuthPage: FirebaseAuthException during login: ${e.code} - ${e.message}");
//       if (mounted) {
//         setState(() {
//           if (e.code == 'user-not-found' ||
//               e.code == 'invalid-credential' ||
//               e.code == 'wrong-password' ||
//               e.code == 'INVALID_LOGIN_CREDENTIALS') { 
//             _errorMessage = 'Invalid email or password.';
//           } else {
//             _errorMessage = e.message ?? 'An authentication error occurred.';
//           }
//         });
//       }
//     } catch (e) {
//       dev.log("AuthPage: Generic error during login: $e");
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

//   void _navigateToDashboard(String role, String uid, Map<String, dynamic> userData) {
//     // ... (existing code)
//     dev.log("AuthPage: Navigating to dashboard for role '$role', UID: $uid");
//     Widget nextPage;
//     String userName = userData['fullName'] as String? ?? userData['name'] as String? ?? uid;

//     switch (role) {
//       case 'patient':
//         nextPage = ChangeNotifierProvider(
//           create: (_) => PatientProvider()..setPatientId(uid),
//           child: const PatientHomeScreen(),
//         );
//         break;
//       case 'doctor':
//         nextPage = DoctorAppointmentsPage(
//           doctorId: uid,
//           doctorName: userName,
//         );
//         break;
//       case 'pharmacist':
//         nextPage = Scaffold(body: Center(child: Text('Pharmacist Dashboard for $userName (UID: $uid)')));
//         dev.log("AuthPage: Placeholder for Pharmacist Dashboard.");
//         break;
//       default:
//         dev.log("AuthPage: Unknown role '$role'. Defaulting to login with error.");
//         _auth.signOut(); 
//          if (mounted) {
//             setState(() {
//                 _errorMessage = "Unknown user role '$role'. Please contact support.";
//                 _isLoadingPage = false;
//             });
//         }
//         return; 
//     }
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => nextPage),
//     );
//   }

//   Future<void> _handleGoogleSignIn() async {
//     if (!mounted) return;
//     setState(() {
//       _isLoadingPage = true;
//       _errorMessage = null;
//     });
//     dev.log("AuthPage: Attempting Google Sign-In...");

//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         // User cancelled the sign-in
//         dev.log("AuthPage: Google Sign-In cancelled by user.");
//         if (mounted) setState(() => _isLoadingPage = false);
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential userCredential = await _auth.signInWithCredential(credential);
//       User? user = userCredential.user;

//       if (user != null) {
//         dev.log("AuthPage: Google Sign-In successful for UID: ${user.uid}. Checking/Creating user document...");

//         // Check if user exists in Firestore, if not, create them
//         // This is where you decide the default role for NEW Google Sign-In users
//         // OR prompt them to choose a role if they are new.
//         // For simplicity now, let's assume new Google users are 'patient' by default
//         // if this is their first time.

//         final userDocRef = _firestore.collection('users').doc(user.uid);
//         DocumentSnapshot userDoc = await userDocRef.get();

//         Map<String, dynamic> userData;
//         String userRoleInDb;

//         if (!userDoc.exists) {
//           dev.log("AuthPage: New Google user. Creating user document with default role 'patient'. UID: ${user.uid}");
//           userRoleInDb = 'patient'; // Default role for new Google Sign-In users
//           userData = {
//             'email': user.email,
//             'fullName': user.displayName ?? user.email?.split('@')[0] ?? 'Google User',
//             'role': userRoleInDb,
//             'profileImageUrl': user.photoURL,
//             'createdAt': FieldValue.serverTimestamp(),
//           };
//           await userDocRef.set(userData);
//           // If the new user is a doctor/pharmacist by some other logic,
//           // you'd need to add them to their respective collections here too.
//         } else {
//           userData = userDoc.data() as Map<String, dynamic>;
//           userRoleInDb = (userData['role'] as String? ?? 'patient').trim().toLowerCase();
//           dev.log("AuthPage: Existing user signed in with Google. Role from DB: '$userRoleInDb'");
//           // Optionally update profile image or name if changed in Google
//            Map<String, dynamic> updates = {};
//            if (user.displayName != null && user.displayName != userData['fullName']) {
//              updates['fullName'] = user.displayName;
//            }
//            if (user.photoURL != null && user.photoURL != userData['profileImageUrl']) {
//              updates['profileImageUrl'] = user.photoURL;
//            }
//            if (updates.isNotEmpty) {
//              updates['updatedAt'] = FieldValue.serverTimestamp();
//              await userDocRef.update(updates);
//              // Re-fetch userData if updated
//              userData = (await userDocRef.get()).data() as Map<String, dynamic>;
//            }
//         }

//         if (!mounted) return;
//         _navigateToDashboard(userRoleInDb, user.uid, userData);
//       } else {
//          throw Exception("Google Sign-In failed to return a user.");
//       }
//     } on FirebaseAuthException catch (e) {
//       dev.log("AuthPage: FirebaseAuthException during Google Sign-In: ${e.code} - ${e.message}");
//       if (mounted) {
//         setState(() {
//           // Handle specific errors like account-exists-with-different-credential
//           if (e.code == 'account-exists-with-different-credential') {
//             _errorMessage = 'An account already exists with the same email address but different sign-in credentials. Try signing in with the original method.';
//           } else {
//             _errorMessage = e.message ?? 'Google Sign-In failed.';
//           }
//         });
//       }
//     } catch (e) {
//       dev.log("AuthPage: Generic error during Google Sign-In: $e");
//       if (mounted) {
//         setState(() {
//           _errorMessage = 'An unexpected error occurred with Google Sign-In: ${e.toString()}';
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

//   void _goToSignUpRoleSelection() {
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignUpRoleSelectionPage()));
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         centerTitle: true,
//       ),
//       body: Stack(
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
//                   const SizedBox(height: 30),
//                   LoginFormWidget(
//                     isLoginMode: true,
//                     onSubmit: _handleLogin,
//                     onToggleToSignUp: _goToSignUpRoleSelection,
//                   ),
//                   const SizedBox(height: 12),
//                   if (_errorMessage != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                       child: Text(
//                         _errorMessage!,
//                         style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: <Widget>[
//                       const Expanded(child: Divider()),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Text("OR", style: TextStyle(color: Colors.grey.shade600)),
//                       ),
//                       const Expanded(child: Divider()),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     icon: Image.asset('assets/images/google_logo.png', height: 24.0, width: 24.0), // Add google_logo.png to your assets
//                     label: const Text('Sign in with Google'),
//                     onPressed: _isLoadingPage ? null : _handleGoogleSignIn,
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.black87, 
//                       backgroundColor: Colors.white,
//                       side: BorderSide(color: Colors.grey.shade400),
//                       padding: const EdgeInsets.symmetric(vertical: 12.0),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (_isLoadingPage)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black.withOpacity(0.1),
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }






















// lib/pages/auth/auth_page.dart
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:medi_sync_plus_app/pages/auth/login_form_widget.dart';
import 'package:medi_sync_plus_app/pages/auth/signup_role_selection_page.dart';
import 'package:medi_sync_plus_app/pages/doctor/doctor_dashboard.dart';
import 'package:medi_sync_plus_app/pages/patient/patient_dashboard.dart';
import 'package:medi_sync_plus_app/providers/patient_provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoadingPage = false;
  String? _errorMessage;

  Future<void> _handleLogin(String email, String password) async {
    if (!mounted) return;
    setState(() {
      _isLoadingPage = true;
      _errorMessage = null;
    });
    dev.log("AuthPage: Login attempt. Email: $email");

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      dev.log(
          "AuthPage: Login successful for UID: ${userCredential.user!.uid}. Fetching user document...");

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        dev.log(
            "AuthPage: User document NOT FOUND after login for UID: ${userCredential.user!.uid}.");
        await _auth.signOut();
        throw Exception('User profile not found. Please contact support.');
      }

      var userData = userDoc.data() as Map<String, dynamic>;
      String userRoleInDb =
          (userData['role'] as String? ?? 'patient').trim().toLowerCase();
      dev.log("AuthPage: User role from DB: '$userRoleInDb'");

      if (!mounted) return;

      _navigateToDashboard(userRoleInDb, userCredential.user!.uid, userData);
    } on FirebaseAuthException catch (e) {
      dev.log(
          "AuthPage: FirebaseAuthException during login: ${e.code} - ${e.message}");
      if (mounted) {
        setState(() {
          if (e.code == 'user-not-found' ||
              e.code == 'invalid-credential' ||
              e.code == 'wrong-password' ||
              e.code == 'INVALID_LOGIN_CREDENTIALS') {
            _errorMessage = 'Invalid email or password.';
          } else {
            _errorMessage = e.message ?? 'An authentication error occurred.';
          }
        });
      }
    } catch (e) {
      dev.log("AuthPage: Generic error during login: $e");
      if (mounted) {
        setState(() {
          _errorMessage =
              'An unexpected error occurred: ${e.toString().replaceAll("Exception: ", "")}';
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

  void _navigateToDashboard(
      String role, String uid, Map<String, dynamic> userData) {
    dev.log("AuthPage: Navigating to dashboard for role '$role', UID: $uid");
    Widget nextPage;
    String userName =
        userData['fullName'] as String? ?? userData['name'] as String? ?? uid;

    switch (role) {
      case 'patient':
        nextPage = ChangeNotifierProvider(
          create: (_) => PatientProvider()..setPatientId(uid),
          child: const PatientHomeScreen(),
        );
        break;
      case 'doctor':
        nextPage = const DoctorDashboardScreen();
        dev.log("AuthPage: Navigating to DoctorDashboardScreen for UID: $uid");
        break;
      case 'pharmacist':
        nextPage = Scaffold(
          body: Center(
            child: Text('Pharmacist Dashboard for $userName (UID: $uid)'),
          ),
        );
        dev.log("AuthPage: Placeholder for Pharmacist Dashboard.");
        break;
      default:
        dev.log("AuthPage: Unknown role '$role'. Defaulting to login with error.");
        _auth.signOut();
        if (mounted) {
          setState(() {
            _errorMessage = "Unknown user role '$role'. Please contact support.";
            _isLoadingPage = false;
          });
        }
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    if (!mounted) return;
    setState(() {
      _isLoadingPage = true;
      _errorMessage = null;
    });
    dev.log("AuthPage: Attempting Google Sign-In...");

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        dev.log("AuthPage: Google Sign-In cancelled by user.");
        if (mounted) setState(() => _isLoadingPage = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        dev.log(
            "AuthPage: Google Sign-In successful for UID: ${user.uid}. Checking/Creating user document...");

        final userDocRef = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot userDoc = await userDocRef.get();

        Map<String, dynamic> userData;
        String userRoleInDb;

        if (!userDoc.exists) {
          dev.log(
              "AuthPage: New Google user. Creating user document with default role 'patient'. UID: ${user.uid}");
          userRoleInDb = 'patient';
          userData = {
            'email': user.email,
            'fullName':
                user.displayName ?? user.email?.split('@')[0] ?? 'Google User',
            'role': userRoleInDb,
            'profileImageUrl': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          };
          await userDocRef.set(userData);
        } else {
          userData = userDoc.data() as Map<String, dynamic>;
          userRoleInDb =
              (userData['role'] as String? ?? 'patient').trim().toLowerCase();
          dev.log(
              "AuthPage: Existing user signed in with Google. Role from DB: '$userRoleInDb'");
          Map<String, dynamic> updates = {};
          if (user.displayName != null &&
              user.displayName != userData['fullName']) {
            updates['fullName'] = user.displayName;
          }
          if (user.photoURL != null &&
              user.photoURL != userData['profileImageUrl']) {
            updates['profileImageUrl'] = user.photoURL;
          }
          if (updates.isNotEmpty) {
            updates['updatedAt'] = FieldValue.serverTimestamp();
            await userDocRef.update(updates);
            userData = (await userDocRef.get()).data() as Map<String, dynamic>;
          }
        }

        if (!mounted) return;
        _navigateToDashboard(userRoleInDb, user.uid, userData);
      } else {
        throw Exception("Google Sign-In failed to return a user.");
      }
    } on FirebaseAuthException catch (e) {
      dev.log(
          "AuthPage: FirebaseAuthException during Google Sign-In: ${e.code} - ${e.message}");
      if (mounted) {
        setState(() {
          if (e.code == 'account-exists-with-different-credential') {
            _errorMessage =
                'An account already exists with the same email address but different sign-in credentials. Try signing in with the original method.';
          } else {
            _errorMessage = e.message ?? 'Google Sign-In failed.';
          }
        });
      }
    } catch (e) {
      dev.log("AuthPage: Generic error during Google Sign-In: $e");
      if (mounted) {
        setState(() {
          _errorMessage =
              'An unexpected error occurred with Google Sign-In: ${e.toString()}';
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

  void _goToSignUpRoleSelection() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SignUpRoleSelectionPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                  const SizedBox(height: 30),
                  LoginFormWidget(
                    isLoginMode: true,
                    onSubmit: _handleLogin,
                    onToggleToSignUp: _goToSignUpRoleSelection,
                  ),
                  const SizedBox(height: 12),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      height: 24.0,
                      width: 24.0,
                    ),
                    label: const Text('Sign in with Google'),
                    onPressed: _isLoadingPage ? null : _handleGoogleSignIn,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade400),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
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