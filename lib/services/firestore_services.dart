// import 'package:cloud_firestore/cloud_firestore.dart'; 
// import 'package:firebase_auth/firebase_auth.dart';

// class FirestoreService{ 
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future initializeSampleData() async { // Add 6 hospitals await _firestore.collection('hospitals').doc('hospital_1').set({ 'name': 'City General Hospital', 'address': '123 Main St, Mumbai', 'contact': '+912234567890', 'specialties': ['Cardiology', 'Neurology', 'Pediatrics'], });

//   await _firestore.collection('hospitals').doc('hospital_2').set({
//     'name': 'Green Valley Clinic',
//     'address': '456 Oak Ave, Delhi',
//     'contact': '+9111987654321',
//     'specialties': ['Orthopedics', 'Dermatology', 'ENT'],
//   });

//   await _firestore.collection('hospitals').doc('hospital_3').set({
//     'name': 'Sunrise Medical Center',
//     'address': '789 Pine Rd, Bangalore',
//     'contact': '+918765432109',
//     'specialties': ['Oncology', 'Radiology', 'Gastroenterology'],
//   });

//   await _firestore.collection('hospitals').doc('hospital_4').set({
//     'name': 'Blue Ridge Hospital',
//     'address': '321 Cedar Ln, Chennai',
//     'contact': '+914321098765',
//     'specialties': ['Endocrinology', 'Pulmonology', 'Urology'],
//   });

//   await _firestore.collection('hospitals').doc('hospital_5').set({
//     'name': 'Golden Care Facility',
//     'address': '654 Maple St, Kolkata',
//     'contact': '+913210987654',
//     'specialties': ['Psychiatry', 'Ophthalmology', 'Nephrology'],
//   });

//   await _firestore.collection('hospitals').doc('hospital_6').set({
//     'name': 'Silver Oak Clinic',
//     'address': '987 Birch Ave, Hyderabad',
//     'contact': '+914567890123',
//     'specialties': ['Hematology', 'Rheumatology', 'Infectious Diseases'],
//   });

//   // Add 15 doctors with different specialties
//   await _firestore.collection('doctors').doc('doctor_uid_1').set({
//     'name': 'Dr. John Doe',
//     'specialty': 'Cardiology',
//     'hospital_id': 'hospital_1',
//     'hospital_name': 'City General Hospital',
//     'email': 'john.doe@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '10:00 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '11:00 AM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_2').set({
//     'name': 'Dr. Sarah Lee',
//     'specialty': 'Neurology',
//     'hospital_id': 'hospital_1',
//     'hospital_name': 'City General Hospital',
//     'email': 'sarah.lee@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '09:00 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '02:00 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_3').set({
//     'name': 'Dr. Amit Sharma',
//     'specialty': 'Pediatrics',
//     'hospital_id': 'hospital_1',
//     'hospital_name': 'City General Hospital',
//     'email': 'amit.sharma@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '01:00 PM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '03:00 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_4').set({
//     'name': 'Dr. Priya Reddy',
//     'specialty': 'Orthopedics',
//     'hospital_id': 'hospital_2',
//     'hospital_name': 'Green Valley Clinic',
//     'email': 'priya.reddy@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '10:30 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '12:00 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_5').set({
//     'name': 'Dr. Rajesh Kumar',
//     'specialty': 'Dermatology',
//     'hospital_id': 'hospital_2',
//     'hospital_name': 'Green Valley Clinic',
//     'email': 'rajesh.kumar@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '11:30 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '02:30 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_6').set({
//     'name': 'Dr. Anjali Patel',
//     'specialty': 'ENT',
//     'hospital_id': 'hospital_2',
//     'hospital_name': 'Green Valley Clinic',
//     'email': 'anjali.patel@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '09:30 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '01:30 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_7').set({
//     'name': 'Dr. Vikram Singh',
//     'specialty': 'Oncology',
//     'hospital_id': 'hospital_3',
//     'hospital_name': 'Sunrise Medical Center',
//     'email': 'vikram.singh@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '10:00 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '03:00 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_8').set({
//     'name': 'Dr. Neha Gupta',
//     'specialty': 'Radiology',
//     'hospital_id': 'hospital_3',
//     'hospital_name': 'Sunrise Medical Center',
//     'email': 'neha.gupta@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '11:00 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '02:00 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_9').set({
//     'name': 'Dr. Sanjay Rao',
//     'specialty': 'Gastroenterology',
//     'hospital_id': 'hospital_3',
//     'hospital_name': 'Sunrise Medical Center',
//     'email': 'sanjay.rao@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '12:00 PM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '04:00 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_10').set({
//     'name': 'Dr. Meera Nair',
//     'specialty': 'Endocrinology',
//     'hospital_id': 'hospital_4',
//     'hospital_name': 'Blue Ridge Hospital',
//     'email': 'meera.nair@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '09:00 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '01:00 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_11').set({
//     'name': 'Dr. Anil Joshi',
//     'specialty': 'Pulmonology',
//     'hospital_id': 'hospital_4',
//     'hospital_name': 'Blue Ridge Hospital',
//     'email': 'anil.joshi@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '10:30 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '03:30 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_12').set({
//     'name': 'Dr. Sunita Mehra',
//     'specialty': 'Urology',
//     'hospital_id': 'hospital_4',
//     'hospital_name': 'Blue Ridge Hospital',
//     'email': 'sunita.mehra@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '11:30 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '02:30 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_13').set({
//     'name': 'Dr. Rohan Desai',
//     'specialty': 'Psychiatry',
//     'hospital_id': 'hospital_5',
//     'hospital_name': 'Golden Care Facility',
//     'email': 'rohan.desai@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '09:30 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '01:30 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_14').set({
//     'name': 'Dr. Kavita Sharma',
//     'specialty': 'Ophthalmology',
//     'hospital_id': 'hospital_5',
//     'hospital_name': 'Golden Care Facility',
//     'email': 'kavita.sharma@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '10:00 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '03:00 PM', 'isBooked': false},
//     ],
//   });

//   await _firestore.collection('doctors').doc('doctor_uid_15').set({
//     'name': 'Dr. Vikram Patel',
//     'specialty': 'Nephrology',
//     'hospital_id': 'hospital_5',
//     'hospital_name': 'Golden Care Facility',
//     'email': 'vikram.patel@example.com',
//     'available_slots': [
//       {'date': '2025-06-04', 'time': '11:00 AM', 'isBooked': false},
//       {'date': '2025-06-04', 'time': '02:00 PM', 'isBooked': false},
//     ],
//   });

//   // Add sample users
//   await _firestore.collection('users').doc('patient_uid_1').set({
//     'email': 'jane.smith@example.com',
//     'role': 'Patient',
//     'createdAt': FieldValue.serverTimestamp(),
//   });

//   await _firestore.collection('users').doc('doctor_uid_1').set({
//     'email': 'john.doe@example.com',
//     'role': 'Doctor',
//     'createdAt': FieldValue.serverTimestamp(),
//   });

//   }
// }




// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Add a doctor (called during signup in login_form.dart)
//   Future<void> addDoctor(
//     String uid,
//     String email,
//     String name,
//     String specialty,
//     String hospitalId,
//     String hospitalName,
//   ) async {
//     await _firestore.collection('doctors').doc(uid).set({
//       'name': name,
//       'specialty': specialty,
//       'hospital_id': hospitalId,
//       'hospital_name': hospitalName,
//       'email': email,
//       // Example: Default available slots. You might want a more dynamic way to manage these.
//       'available_slots': [
//         {'date': '2025-06-04', 'time': '10:00 AM', 'isBooked': false},
//         {'date': '2025-06-04', 'time': '11:00 AM', 'isBooked': false},
//         {'date': '2025-06-05', 'time': '02:00 PM', 'isBooked': false},
//       ],
//       'created_at': FieldValue.serverTimestamp(),
//     });
//   }

//   // Book an appointment
//   Future<void> bookAppointment({
//     required String patientId,
//     required String patientName,
//     required String doctorId,
//     required String doctorName,
//     required String hospitalId,
//     required String hospitalName,
//     required String specialty,
//     required Map<String, dynamic> slot, // The specific slot being booked
//   }) async {
//     // For atomicity (ensuring both appointment creation and slot update succeed or fail together),
//     // consider using a Firestore transaction. This example performs them sequentially.

//     // 1. Add appointment to appointments collection
//     await _firestore.collection('appointments').add({
//       'patient_id': patientId,
//       'patient_name': patientName,
//       'doctor_id': doctorId,
//       'doctor_name': doctorName,
//       'hospital_id': hospitalId,
//       'hospital_name': hospitalName,
//       'specialty': specialty,
//       'date': slot['date'],
//       'time': slot['time'],
//       'status': 'booked', // Or 'pending' if doctor confirmation is needed
//       'created_at': FieldValue.serverTimestamp(),
//     });

//     // 2. Update doctor's available slot to mark as booked
//     final DocumentReference doctorRef =
//         _firestore.collection('doctors').doc(doctorId);

//     final DocumentSnapshot doctorDoc = await doctorRef.get();

//     if (!doctorDoc.exists) {
//       throw Exception("Doctor not found. Cannot update slots.");
//     }

//     final Map<String, dynamic>? doctorData =
//         doctorDoc.data() as Map<String, dynamic>?;
//     if (doctorData == null || doctorData['available_slots'] == null) {
//       throw Exception(
//           "Doctor data or available_slots are missing. Cannot update slots.");
//     }

//     // Ensure 'available_slots' is treated as a list of maps
//     final List<dynamic> currentSlotsDynamic =
//         doctorData['available_slots'] as List<dynamic>;
//     final List<Map<String, dynamic>> currentSlots = currentSlotsDynamic
//         .map((s) => Map<String, dynamic>.from(s as Map))
//         .toList();

//     final List<Map<String, dynamic>> updatedSlots = currentSlots.map((s) {
//       if (s['date'] == slot['date'] && s['time'] == slot['time']) {
//         // Found the slot, mark it as booked
//         return {...s, 'isBooked': true};
//       }
//       return s; // Return other slots unchanged
//     }).toList();

//     await doctorRef.update({
//       'available_slots': updatedSlots,
//     });
//   }

//   // Get doctors stream.
//   // Note: searchQuery and filterType are not used for server-side filtering in this version.
//   // Filtering based on these parameters would typically be done client-side with this stream,
//   // or you'd need to build more complex queries here if server-side filtering is desired.
//   Stream<QuerySnapshot> getDoctors({
//     String? searchQuery,
//     String? filterType,
//   }) {
//     // Basic query fetching all doctors.
//     // For server-side filtering based on searchQuery/filterType, you'd modify this query:
//     // e.g., if (filterType == 'specialty' && searchQuery != null && searchQuery.isNotEmpty) {
//     //   return _firestore.collection('doctors').where('specialty', isEqualTo: searchQuery).snapshots();
//     // }
//     // 'contains' like filtering usually requires 3rd party search (Algolia, Typesense) or specific data structuring.
//     return _firestore.collection('doctors').snapshots();
//   }

//   // Get appointments for a specific doctor that are 'booked'
//   Stream<QuerySnapshot> getDoctorAppointments(String doctorId) {
//     return _firestore
//         .collection('appointments')
//         .where('doctor_id', isEqualTo: doctorId)
//         .where('status',
//             isEqualTo: 'booked') // Only show currently booked appointments
//         .orderBy('created_at',
//             descending: true) // Show newest appointments first
//         .snapshots();
//   }

//   // Example: Get appointments for a specific patient
//   Stream<QuerySnapshot> getPatientAppointments(String patientId) {
//     return _firestore
//         .collection('appointments')
//         .where('patient_id', isEqualTo: patientId)
//         .orderBy('created_at', descending: true)
//         .snapshots();
//   }
// }





























import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev; // For logging

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Added for convenience

  // --- Existing Methods (Based on older DB structure) ---

  // Add a doctor (called during signup in login_form.dart)
  // NOTE: This creates a doctor with an embedded 'available_slots' array and a simple 'specialty' string.
  // This is DIFFERENT from the doctor structure expected by the new AppointmentBookingPage.
  Future<void> addDoctor(
    String uid,
    String email,
    String name,
    String specialty, // This is just a string, not a specialtyId
    String hospitalId,
    String hospitalName,
  ) async {
    dev.log("FirestoreService: Attempting to add doctor (old structure): $name, Specialty: $specialty");
    await _db.collection('doctors').doc(uid).set({
      'doctorId': uid, // Good practice to store the ID in the document
      'fullName': name, // Consistent with new AppointmentBookingPage doctor model
      'email': email,
      // 'specialty': specialty, // This field is problematic if you also have specialtyId
      'specialtyId': specialty.toLowerCase().replaceAll(' ', ''), // ATTEMPT to make it compatible, assuming specialty string can be an ID
      // The new AppointmentBookingPage expects 'affiliatedHospitals' as an array of maps
      'affiliatedHospitals': [
        {
          'hospitalId': hospitalId,
          'hospitalName': hospitalName,
          'department': specialty, // Or a more generic department
        }
      ],
      // 'hospital_id': hospitalId, // Old field
      // 'hospital_name': hospitalName, // Old field
      // Example: Default available slots. This embedded array is not used by new AppointmentBookingPage.
      // 'available_slots': [
      //   {'date': '2025-06-04', 'time': '10:00 AM', 'isBooked': false},
      //   {'date': '2025-06-04', 'time': '11:00 AM', 'isBooked': false},
      //   {'date': '2025-06-05', 'time': '02:00 PM', 'isBooked': false},
      // ],
      'isEnabled': true, // Add this for compatibility with AppointmentBookingPage
      'created_at': FieldValue.serverTimestamp(),
    });
    dev.log("FirestoreService: Doctor added (old structure with attempted compatibility): $name");
  }

  // Book an appointment
  // NOTE: This method updates an embedded 'available_slots' array in the doctor's document.
  // The new AppointmentBookingPage uses a subcollection for slots and a transaction.
  // This method is INCOMPATIBLE with the new slot management.
  Future<void> bookAppointment_OLD_STRUCTURE({ // Renamed to avoid conflict
    required String patientId,
    required String patientName,
    required String doctorId,
    required String doctorName,
    required String hospitalId,
    required String hospitalName,
    required String specialty,
    required Map<String, dynamic> slot, // The specific slot {date, time, isBooked}
  }) async {
    dev.log("FirestoreService: Attempting to book appointment (OLD STRUCTURE) for Dr: $doctorName, Slot: ${slot['date']} ${slot['time']}");
    // For atomicity, a Firestore transaction is highly recommended.
    // This example performs them sequentially which is not ideal for production.

    // 1. Add appointment to appointments collection
    // This appointment structure is also different from the one in AppointmentBookingPage
    await _db.collection('appointments_old_structure').add({ // Use a different collection name
      'patient_id': patientId,
      'patient_name': patientName,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'hospital_id': hospitalId,
      'hospital_name': hospitalName,
      'specialty': specialty,
      'date': slot['date'], // String date
      'time': slot['time'], // String time
      'status': 'booked',
      'created_at': FieldValue.serverTimestamp(),
    });
    dev.log("FirestoreService: Appointment added to 'appointments_old_structure'");


    // 2. Update doctor's available slot to mark as booked
    final DocumentReference doctorRef = _db.collection('doctors').doc(doctorId);
    final DocumentSnapshot doctorDoc = await doctorRef.get();

    if (!doctorDoc.exists) {
      dev.log("FirestoreService: Doctor $doctorId not found. Cannot update slots.");
      throw Exception("Doctor not found. Cannot update slots.");
    }

    final Map<String, dynamic>? doctorData = doctorDoc.data() as Map<String, dynamic>?;
    // Check for 'available_slots' which is part of the old structure
    if (doctorData == null || doctorData['available_slots'] == null) {
      dev.log("FirestoreService: Doctor data or 'available_slots' are missing for $doctorId.");
      throw Exception("Doctor data or 'available_slots' are missing. Cannot update slots.");
    }

    final List<dynamic> currentSlotsDynamic = doctorData['available_slots'] as List<dynamic>;
    final List<Map<String, dynamic>> currentSlots = currentSlotsDynamic
        .map((s) => Map<String, dynamic>.from(s as Map))
        .toList();

    bool slotFoundAndUpdated = false;
    final List<Map<String, dynamic>> updatedSlots = currentSlots.map((s) {
      if (s['date'] == slot['date'] && s['time'] == slot['time'] && s['isBooked'] == false) {
        slotFoundAndUpdated = true;
        return {...s, 'isBooked': true};
      }
      return s;
    }).toList();

    if (slotFoundAndUpdated) {
      await doctorRef.update({'available_slots': updatedSlots});
      dev.log("FirestoreService: Doctor's 'available_slots' updated for $doctorId.");
    } else {
      dev.log("FirestoreService: Slot not found or already booked for $doctorId. Date: ${slot['date']}, Time: ${slot['time']}");
      throw Exception("Slot not found or already booked. Please try again.");
    }
  }

  // Get doctors stream.
  // NOTE: This fetches doctors based on the OLDER structure.
  // The new AppointmentBookingPage has its own _fetchAllDoctors logic.
  Stream<QuerySnapshot> getDoctors_OLD_STRUCTURE({ // Renamed
    String? searchQuery,
    String? filterType,
  }) {
    dev.log("FirestoreService: Fetching doctors (OLD STRUCTURE)");
    // Basic query fetching all doctors.
    // Server-side filtering is complex with this basic query.
    return _db.collection('doctors').snapshots();
  }

  // Get appointments for a specific doctor that are 'booked' (OLD STRUCTURE)
  Stream<QuerySnapshot> getDoctorAppointments_OLD_STRUCTURE(String doctorId) { // Renamed
    dev.log("FirestoreService: Fetching doctor appointments (OLD STRUCTURE) for $doctorId");
    return _db
        .collection('appointments_old_structure') // Query the old collection
        .where('doctor_id', isEqualTo: doctorId)
        .where('status', isEqualTo: 'booked')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // Example: Get appointments for a specific patient (OLD STRUCTURE)
  Stream<QuerySnapshot> getPatientAppointments_OLD_STRUCTURE(String patientId) { // Renamed
    dev.log("FirestoreService: Fetching patient appointments (OLD STRUCTURE) for $patientId");
    return _db
        .collection('appointments_old_structure') // Query the old collection
        .where('patient_id', isEqualTo: patientId)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // --- New Methods (Based on the new DB structure for AppointmentBookingPage & other features) ---

  // --- User Profile Methods ---
  Future<DocumentSnapshot?> getUserProfile(String userId) async {
    if (userId.isEmpty) {
      dev.log('FirestoreService: getUserProfile called with empty userId.');
      return null;
    }
    try {
      dev.log('FirestoreService: Fetching user profile for $userId');
      return await _db.collection('users').doc(userId).get();
    } catch (e) {
      dev.log('FirestoreService: Error fetching user profile for $userId: $e');
      return null;
    }
  }

  // --- Medical History Methods ---
  Future<Map<String, dynamic>> getMedicalHistory({String? patientId}) async {
    final id = patientId ?? _auth.currentUser?.uid;
    if (id == null) {
      dev.log('FirestoreService: User or patient ID not found for getMedicalHistory');
      throw Exception('User or patient ID not found for getMedicalHistory');
    }
    dev.log('FirestoreService: Fetching medical history for $id');
    final doc = await _db.collection('medical_histories').doc(id).get();
    if (!doc.exists) {
      dev.log('FirestoreService: No medical history found for $id, returning default structure.');
      return {
        'allergies': '',
        'chronicConditions': '',
        'familyHistory': '',
        'vaccinationHistory': '',
        'medications': [],
        'updatedAt': null,
      };
    }
    return doc.data() as Map<String, dynamic>;
  }

  Future<void> saveMedicalHistory({
    required String allergies,
    required String chronicConditions,
    required String familyHistory,
    required String vaccinationHistory,
    required List<Map<String, dynamic>> medications,
  }) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) {
      dev.log('FirestoreService: User ID not found for saveMedicalHistory');
      throw Exception('User ID not found for saveMedicalHistory');
    }
    dev.log('FirestoreService: Saving medical history for $currentUserId');
    await _db.collection('medical_histories').doc(currentUserId).set({
      'allergies': allergies,
      'chronicConditions': chronicConditions,
      'familyHistory': familyHistory,
      'vaccinationHistory': vaccinationHistory,
      'medications': medications,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    dev.log('FirestoreService: Medical history saved for $currentUserId');
  }

  // --- Prescription Methods ---
  Future<void> savePrescription({
    required String patientId,
    required String patientNameAtTimeOfPrescription,
    required String patientAgeAtTimeOfPrescription,
    required String doctorId,
    required String doctorNameAtTimeOfPrescription,
    required String doctorSpecializationAtTimeOfPrescription,
    required Timestamp prescriptionIssueDate,
    String? prescriptionSystemId,
    required String diagnosis,
    required List<Map<String, dynamic>> medicationItems,
    String? specialInstructions,
    String? labTestsRecommended,
  }) async {
    try {
      dev.log('FirestoreService: Saving prescription for patient $patientId by doctor $doctorId');
      await _db.collection('prescriptions').add({
        'patientId': patientId,
        'patientNameAtTimeOfPrescription': patientNameAtTimeOfPrescription,
        'patientAgeAtTimeOfPrescription': patientAgeAtTimeOfPrescription,
        'doctorId': doctorId,
        'doctorNameAtTimeOfPrescription': doctorNameAtTimeOfPrescription,
        'doctorSpecializationAtTimeOfPrescription': doctorSpecializationAtTimeOfPrescription,
        'prescriptionIssueDate': prescriptionIssueDate,
        if (prescriptionSystemId != null && prescriptionSystemId.isNotEmpty)
          'prescriptionSystemId': prescriptionSystemId,
        'diagnosis': diagnosis,
        'medicationItems': medicationItems,
        'specialInstructions': specialInstructions ?? '',
        'labTestsRecommended': labTestsRecommended ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      dev.log('FirestoreService: Prescription saved successfully.');
    } catch (e) {
      dev.log('FirestoreService: Error in savePrescription: $e');
      throw Exception('Failed to save prescription: $e');
    }
  }

  Stream<QuerySnapshot> getPrescriptionsForPatient(String patientId) {
    dev.log('FirestoreService: Getting prescriptions stream for patient $patientId');
    return _db
        .collection('prescriptions')
        .where('patientId', isEqualTo: patientId)
        .orderBy('prescriptionIssueDate', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPrescriptionsForDoctorPatient(String doctorId, String patientId) {
    dev.log('FirestoreService: Getting prescriptions stream for doctor $doctorId and patient $patientId');
    return _db
        .collection('prescriptions')
        .where('doctorId', isEqualTo: doctorId)
        .where('patientId', isEqualTo: patientId)
        .orderBy('prescriptionIssueDate', descending: true)
        .snapshots();
  }

  // --- New Methods for Medicines and Brands ---
  Future<List<Map<String, dynamic>>> getGenericMedicines() async {
    try {
      dev.log('FirestoreService: Fetching generic medicines');
      final querySnapshot = await _db.collection('medicines').get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      dev.log('FirestoreService: Error fetching generic medicines: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getBrandNames() async {
    try {
      dev.log('FirestoreService: Fetching brand names');
      final querySnapshot = await _db.collection('brands').get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      dev.log('FirestoreService: Error fetching brand names: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getBrandNamesForGeneric(String genericMedicineId) async {
    try {
      dev.log('FirestoreService: Fetching brands for generic $genericMedicineId');
      final querySnapshot = await _db.collection('brands').where('genericMedicineId', isEqualTo: genericMedicineId).get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      dev.log('FirestoreService: Error fetching brands for generic $genericMedicineId: $e');
      rethrow;
    }
  }

  // --- Access Log Method ---
  Future<void> logAccess(String patientId, String doctorId) async {
    dev.log('FirestoreService: Logging access for patient $patientId by doctor $doctorId');
    await _db.collection('access_logs').add({
      'patientId': patientId,
      'doctorId': doctorId,
      'accessedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<String>> getAllBrandNamesOnly() async {
    try {
      dev.log('FirestoreService: Fetching all brand names (only names)');
      final querySnapshot = await _db.collection('brands').get();
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            return data['brandName'] as String? ?? '';
          })
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (e) {
      dev.log('FirestoreService: Error fetching all brand names only: $e');
      return [];
    }
  }

  // --- Methods for NEW Appointment Booking Logic (compatible with AppointmentBookingPage) ---
  // You would call this from AppointmentBookingPage's _bookAppointment method
  // Note: The transaction logic is typically handled within the page/widget itself for UI feedback,
  // but you could centralize parts of it here if desired.
  // For now, this method just shows how to create the appointment document.
  // The slot update part should be done in a transaction with this.
  Future<DocumentReference> createAppointmentDocument_NEW_STRUCTURE({
    required String specialtyId,
    required String specialtyName,
    required String doctorId,
    required String doctorName,
    required String hospitalId,
    required String hospitalName,
    required Timestamp appointmentStartTime,
    required Timestamp appointmentEndTime,
    required String patientName,
    required String patientContact,
    required String patientUid,
    required String slotId, // ID of the slot from doctors/{doctorId}/availabilitySlots
  }) async {
    dev.log("FirestoreService: Creating NEW STRUCTURE appointment for Dr: $doctorName, Patient UID: $patientUid");
    return await _db.collection('appointments').add({ // Ensure this 'appointments' collection is for the new structure
        'specialtyId': specialtyId,
        'specialtyName': specialtyName,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'appointmentStartTime': appointmentStartTime,
        'appointmentEndTime': appointmentEndTime,
        'patientName': patientName,
        'patientContact': patientContact,
        'patientUid': patientUid,
        'status': 'confirmed', // Or 'pending_confirmation'
        'bookedAt': FieldValue.serverTimestamp(),
        'slotId': slotId,
        // 'appointmentId' will be the document ID, often added post-creation or stored if known
    });
  }

  // Method to update a slot in the subcollection (should be part of a transaction)
  Future<void> updateAvailabilitySlot_NEW_STRUCTURE({
    required String doctorId,
    required String slotId, // Document ID of the slot in availabilitySlots
    required String patientUid,
    required String appointmentId, // ID of the newly created appointment document
  }) async {
    dev.log("FirestoreService: Updating NEW STRUCTURE slot $slotId for Dr: $doctorId, Appt: $appointmentId");
    await _db.collection('doctors').doc(doctorId).collection('availabilitySlots').doc(slotId).update({
      'isBooked': true,
      'bookedByPatientId': patientUid,
      'appointmentId': appointmentId,
    });
  }

}