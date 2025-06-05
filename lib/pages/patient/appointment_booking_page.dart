// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:medi_sync_plus_app/pages/login_page/role_login_page.dart'; // Import your login page

// // --- Data Models ---
// class Specialty {
//   final String id;
//   final String name;
//   Specialty({required this.id, required this.name});

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Specialty && runtimeType == other.runtimeType && id == other.id;

//   @override
//   int get hashCode => id.hashCode;

//   @override
//   String toString() => 'Specialty(id: $id, name: $name)';
// }

// class Doctor {
//   final String id;
//   final String name;
//   final String specialtyId;
//   final String specialtyName;
//   final List<HospitalAffiliation> hospitalAffiliations;
//   final Map<String, List<String>> weeklyAvailability;

//   Doctor({
//     required this.id,
//     required this.name,
//     required this.specialtyId,
//     required this.specialtyName,
//     required this.hospitalAffiliations,
//     this.weeklyAvailability = const {},
//   });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Doctor && runtimeType == other.runtimeType && id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class HospitalAffiliation {
//   final String hospitalId;
//   final String hospitalName;
//   HospitalAffiliation({required this.hospitalId, required this.hospitalName});

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is HospitalAffiliation &&
//           runtimeType == other.runtimeType &&
//           hospitalId == other.hospitalId;

//   @override
//   int get hashCode => hospitalId.hashCode;
// }
// // --- End Data Models ---

// class AppointmentBookingPage extends StatefulWidget {
//   const AppointmentBookingPage({super.key});

//   @override
//   State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
// }

// class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final TextEditingController _searchController = TextEditingController();
//   String _searchTerm = "";

//   Specialty? _selectedSpecialty;
//   Doctor? _selectedDoctor;
//   HospitalAffiliation? _selectedHospitalAffiliation;
//   DateTime? _selectedDate;
//   String? _selectedTimeSlot;

//   final TextEditingController _patientNameController = TextEditingController();
//   final TextEditingController _patientContactController =
//       TextEditingController();

//   List<Specialty> _allSpecialties = [];
//   List<Doctor> _allDoctors = [];
//   List<Doctor> _filteredDoctors = [];
//   List<HospitalAffiliation> _hospitalAffiliations = [];
//   List<String> _availableTimeSlots = [];

//   bool _isLoadingSpecialties = true;
//   bool _isLoadingDoctors = false;
//   bool _isLoadingTimeSlots = false;
//   bool _isBooking = false;
//   bool _isDoctorGenerallyAvailableOnSelectedDate = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchInitialData();
//     _searchController.addListener(() {
//       if (!mounted) return;
//       setState(() {
//         _searchTerm = _searchController.text.trim();
//         _filterDoctors();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _patientNameController.dispose();
//     _patientContactController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchInitialData() async {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       print("User not authenticated. Redirecting to login.");
//       if (mounted) {
//         _showError("Please log in to continue.");
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => RoleLoginPage()),
//           (Route<dynamic> route) => false,
//         );
//       }
//       return;
//     }

//     await _fetchSpecialties();
//     await _fetchAllDoctors();
//   }

//   // Future<void> _fetchSpecialties() async {
//   //   if (!mounted) return;
//   //   setState(() => _isLoadingSpecialties = true);
//   //   try {
//   //     print("Fetching specialties from Firestore...");
//   //     QuerySnapshot snapshot =
//   //         await _firestore.collection('specialties').orderBy('name').get();
//   //     if (!mounted) return;

//   //     if (snapshot.docs.isEmpty) {
//   //       print("No specialties found in Firestore.");
//   //       if (mounted) _showError("No specialties available in the database.");
//   //       setState(() {
//   //         _allSpecialties = [];
//   //         _isLoadingSpecialties = false;
//   //       });
//   //       return;
//   //     }

//   //     _allSpecialties = snapshot.docs.map((doc) {
//   //       var data = doc.data() as Map<String, dynamic>;
//   //       if (!data.containsKey('name') || data['name'] == null) {
//   //         print("Invalid specialty document: ${doc.id}, missing 'name' field.");
//   //         return Specialty(id: doc.id, name: "Unnamed Specialty");
//   //       }
//   //       return Specialty(id: doc.id, name: data['name'] as String);
//   //     }).toList();

//   //     print("Fetched specialties: ${_allSpecialties.map((s) => s.name).toList()}");
//   //   } catch (e, stackTrace) {
//   //     print("Error fetching specialties: $e\n$stackTrace");
//   //     if (mounted) _showError("Could not load specialties. Please try again.");
//   //   } finally {
//   //     if (mounted) {
//   //       setState(() => _isLoadingSpecialties = false);
//   //       _filterDoctors();
//   //     }
//   //   }
//   // }

//   // Future<void> _fetchSpecialties() async {
//   //   if (!mounted) return;
//   //   setState(() => _isLoadingSpecialties = true);
//   //   try {
//   //     print("Fetching specialties from Firestore subcollections...");
//   //     QuerySnapshot specialtyCollections = await _firestore.collection('specialties').get();
//   //     if (!mounted) return;

//   //     print("Raw response from specialties collection: ${specialtyCollections.docs.map((d) => d.id).toList()}");
//   //     if (specialtyCollections.docs.isEmpty) {
//   //       print("No specialty subcollections found in Firestore.");
//   //       if (mounted) {
//   //         _showFeedback("No specialty categories available in the database. Please contact support or check back later.", isError: true);
//   //       }
//   //       setState(() {
//   //         _allSpecialties = [];
//   //         _isLoadingSpecialties = false;
//   //       });
//   //       return;
//   //     }

//   //     List<Future<void>> fetchTasks = [];
//   //     for (var doc in specialtyCollections.docs) {
//   //       String subcollectionName = doc.id;
//   //       print("Processing subcollection: $subcollectionName");
//   //       fetchTasks.add(
//   //         _firestore
//   //             .collection('specialties')
//   //             .doc(subcollectionName)
//   //             .collection(subcollectionName)
//   //             .get()
//   //             .then((QuerySnapshot snapshot) {
//   //           if (snapshot.docs.isNotEmpty) {
//   //             var data = snapshot.docs.first.data() as Map<String, dynamic>;
//   //             if (data.containsKey('name') && data['name'] != null) {
//   //               if (!mounted) {
//   //                 setState(() {
//   //                   _allSpecialties.add(Specialty(id: subcollectionName, name: data['name'] as String));
//   //                 });
//   //               }
//   //             }
//   //           }
//   //         }),
//   //       );
//   //     }

//   //     await Future.wait(fetchTasks);
//   //     print("Fetched specialties: ${_allSpecialties.map((s) => s.name).toList()}");
//   //   } catch (e, stackTrace) {
//   //     print("Error fetching specialties: $e\n$stackTrace");
//   //     if (mounted) _showError("Could not load specialties. Please try again.");
//   //   } finally {
//   //     if (mounted) {
//   //       setState(() => _isLoadingSpecialties = false);
//   //       _filterDoctors();
//   //     }
//   //   }
//   // }


//   Future<void> _fetchSpecialties() async {
//     if (!mounted) return;
//     setState(() => _isLoadingSpecialties = true);
//     try {
//       print("Fetching specialties from Firestore subcollections...");
//       // Explicitly check known subcollections
//       List<String> knownSubcollections = ['generalMedicine', 'cardiology', 'dentistry', 'pediatrics'];
//       List<Future<void>> fetchTasks = [];

//       for (var subcollectionName in knownSubcollections) {
//         print("Attempting to fetch from subcollection: $subcollectionName");
//         fetchTasks.add(
//           _firestore
//               .collection('specialties')
//               .doc(subcollectionName)
//               .collection(subcollectionName)
//               .get()
//               .then((QuerySnapshot snapshot) {
//             if (snapshot.docs.isNotEmpty) {
//               var data = snapshot.docs.first.data() as Map<String, dynamic>;
//               if (data.containsKey('name') && data['name'] != null) {
//                 if (!mounted) {
//                   setState(() {
//                     _allSpecialties.add(Specialty(id: subcollectionName, name: data['name'] as String));
//                   });
//                 }
//               }
//             } else {
//               print("No documents found in subcollection: $subcollectionName");
//             }
//           }).catchError((e) {
//             print("Error fetching subcollection $subcollectionName: $e");
//           }),
//         );
//       }

//       await Future.wait(fetchTasks);
//       print("Fetched specialties: ${_allSpecialties.map((s) => s.name).toList()}");
//       if (_allSpecialties.isEmpty) {
//         print("No specialty subcollections found after explicit checks.");
//         if (mounted) {
//           _showFeedback("No specialty categories available in the database. Please contact support or check back later.", isError: true);
//         }
//       }
//     } catch (e, stackTrace) {
//       print("Error fetching specialties: $e\n$stackTrace");
//       if (mounted) _showError("Could not load specialties. Please try again.");
//     } finally {
//       if (mounted) {
//         setState(() => _isLoadingSpecialties = false);
//         _filterDoctors();
//       }
//     }
//   }




//   Future<void> _fetchAllDoctors() async {
//     if (!mounted) return;
//     setState(() {
//       _isLoadingDoctors = true;
//       _allDoctors = [];
//       _filteredDoctors = [];
//     });
//     try {
//       QuerySnapshot doctorSnapshot = await _firestore.collection('doctors').get();
//       if (!mounted) return;

//       List<Future<Doctor>> futureDoctors = doctorSnapshot.docs.map((doc) async {
//         var data = doc.data() as Map<String, dynamic>;
//         List<dynamic> affiliationsData = data['hospitalAffiliations'] ?? [];
//         List<HospitalAffiliation> affiliations = affiliationsData.map((aff) {
//           return HospitalAffiliation(
//               hospitalId: aff['hospitalId'], hospitalName: aff['hospitalName']);
//         }).toList();

//         Map<String, List<String>> weeklyAvailability = {};
//         if (data['weeklyAvailability'] is Map) {
//           (data['weeklyAvailability'] as Map).forEach((key, value) {
//             if (value is List) {
//               weeklyAvailability[key.toLowerCase()] = List<String>.from(value);
//             }
//           });
//         }
//         String specialtyName = "Unknown Specialty";
//         String specialtyId = data['specialtyId'] as String? ?? "";
//         if (specialtyId.isNotEmpty) {
//           DocumentSnapshot specialtyDoc =
//               await _firestore.collection('specialties').doc(data['specialtyId']).get();
//           if (specialtyDoc.exists) {
//             specialtyName = specialtyDoc['name'] as String;
//           }
//         }
//         return Doctor(
//           id: doc.id,
//           name: data['name'] as String,
//           specialtyId: specialtyId,
//           specialtyName: specialtyName,
//           hospitalAffiliations: affiliations,
//           weeklyAvailability: weeklyAvailability,
//         );
//       }).toList();

//       _allDoctors = await Future.wait(futureDoctors);
//       _filterDoctors();
//     } catch (e) {
//       print("Error fetching all doctors: $e");
//       if (mounted) _showError("Could not load doctor list.");
//     }
//     if (mounted) setState(() => _isLoadingDoctors = false);
//   }

//   void _filterDoctors() {
//     if (!mounted) return;
//     List<Doctor> tempFiltered = [];
//     if (_searchTerm.isEmpty && _selectedSpecialty == null) {
//       tempFiltered = List.from(_allDoctors);
//     } else {
//       tempFiltered = _allDoctors.where((doctor) {
//         bool matchesSearchTerm = true;
//         if (_searchTerm.isNotEmpty) {
//           matchesSearchTerm = doctor.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
//               doctor.specialtyName.toLowerCase().contains(_searchTerm.toLowerCase());
//         }
//         bool matchesSpecialty = true;
//         if (_selectedSpecialty != null && _searchTerm.isEmpty) {
//           matchesSpecialty = doctor.specialtyId == _selectedSpecialty!.id;
//         }
//         return matchesSearchTerm &&
//             (_selectedSpecialty == null ||
//                 doctor.specialtyId == _selectedSpecialty!.id ||
//                 doctor.specialtyName.toLowerCase().contains(_searchTerm.toLowerCase()));
//       }).toList();
//     }

//     if (_selectedDoctor != null && !tempFiltered.contains(_selectedDoctor)) {
//       _clearDoctorAndBelowSelections();
//     }
//     setState(() {
//       _filteredDoctors = tempFiltered;
//     });
//   }

//   void _clearDoctorAndBelowSelections() {
//     if (!mounted) return;
//     setState(() {
//       _selectedDoctor = null;
//       _hospitalAffiliations = [];
//       _selectedHospitalAffiliation = null;
//       _selectedDate = null;
//       _clearDateAndBelowSelections();
//     });
//   }

//   void _clearDateAndBelowSelections() {
//     if (!mounted) return;
//     setState(() {
//       _selectedDate = null;
//       _availableTimeSlots = [];
//       _selectedTimeSlot = null;
//       _isDoctorGenerallyAvailableOnSelectedDate = true;
//     });
//   }

//   void _onSpecialtySelected(Specialty? specialty) {
//     if (!mounted) return;
//     setState(() {
//       _selectedSpecialty = specialty;
//       _clearDoctorAndBelowSelections();
//       _filterDoctors();
//     });
//   }

//   void _onDoctorSelected(Doctor? doctor) {
//     if (!mounted) return;
//     setState(() {
//       _selectedDoctor = doctor;
//       _hospitalAffiliations = doctor?.hospitalAffiliations ?? [];
//       _selectedHospitalAffiliation =
//           _hospitalAffiliations.isNotEmpty ? _hospitalAffiliations.first : null;
//       _clearDateAndBelowSelections();
//     });
//   }

//   void _onHospitalSelected(HospitalAffiliation? hospitalAffiliation) {
//     if (!mounted) return;
//     setState(() {
//       _selectedHospitalAffiliation = hospitalAffiliation;
//       _clearDateAndBelowSelections();
//     });
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     if (_selectedDoctor == null || _selectedHospitalAffiliation == null) {
//       _showError("Please select a doctor and hospital first.");
//       return;
//     }

//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 90)),
//     );

//     if (picked != null && picked != _selectedDate) {
//       if (!mounted) return;
//       setState(() {
//         _selectedDate = picked;
//         _selectedTimeSlot = null;
//         _fetchAvailableTimeSlots();
//       });
//     }
//   }

//   Future<void> _fetchAvailableTimeSlots() async {
//     if (_selectedDoctor == null ||
//         _selectedDate == null ||
//         _selectedHospitalAffiliation == null) {
//       if (mounted) setState(() => _availableTimeSlots = []);
//       return;
//     }
//     if (!mounted) return;
//     setState(() {
//       _isLoadingTimeSlots = true;
//       _availableTimeSlots = [];
//       _selectedTimeSlot = null;
//       _isDoctorGenerallyAvailableOnSelectedDate = true;
//     });

//     String dayOfWeek = DateFormat('EEEE').format(_selectedDate!).toLowerCase();
//     List<String> generalSlots =
//         _selectedDoctor!.weeklyAvailability[dayOfWeek] ?? [];

//     if (generalSlots.isEmpty) {
//       if (!mounted) return;
//       setState(() {
//         _isDoctorGenerallyAvailableOnSelectedDate = false;
//         _isLoadingTimeSlots = false;
//       });
//       return;
//     }

//     try {
//       QuerySnapshot bookedSnapshot = await _firestore
//           .collection('appointments')
//           .where('doctorId', isEqualTo: _selectedDoctor!.id)
//           .where('hospitalId', isEqualTo: _selectedHospitalAffiliation!.hospitalId)
//           .where('date', isEqualTo: Timestamp.fromDate(_selectedDate!))
//           .get();
//       if (!mounted) return;

//       List<String> bookedTimeSlots =
//           bookedSnapshot.docs.map((doc) => doc['timeSlot'] as String).toList();
//       final available =
//           generalSlots.where((slot) => !bookedTimeSlots.contains(slot)).toList();

//       if (!mounted) return;
//       setState(() {
//         _availableTimeSlots = available;
//         if (available.isEmpty && generalSlots.isNotEmpty) {
//           _isDoctorGenerallyAvailableOnSelectedDate = true;
//         } else if (available.isEmpty && generalSlots.isEmpty) {
//           _isDoctorGenerallyAvailableOnSelectedDate = false;
//         }
//       });
//     } catch (e) {
//       print("Error fetching time slots: $e");
//       if (mounted) _showError("Could not load available time slots.");
//       if (mounted) setState(() => _availableTimeSlots = []);
//     } finally {
//       if (mounted) setState(() => _isLoadingTimeSlots = false);
//     }
//   }

//   Future<void> _bookAppointment() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     if (_selectedDoctor == null ||
//         _selectedHospitalAffiliation == null ||
//         _selectedDate == null ||
//         _selectedTimeSlot == null) {
//       _showError("Please make all required selections (Doctor, Hospital, Date, Time).");
//       return;
//     }
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _showError("You must be logged in to book an appointment.");
//       return;
//     }

//     if (!mounted) return;
//     setState(() => _isBooking = true);

//     try {
//       await _firestore.collection('appointments').add({
//         'specialtyId': _selectedDoctor!.specialtyId,
//         'specialtyName': _selectedDoctor!.specialtyName,
//         'doctorId': _selectedDoctor!.id,
//         'doctorName': _selectedDoctor!.name,
//         'hospitalId': _selectedHospitalAffiliation!.hospitalId,
//         'hospitalName': _selectedHospitalAffiliation!.hospitalName,
//         'date': Timestamp.fromDate(_selectedDate!),
//         'timeSlot': _selectedTimeSlot!,
//         'patientName': _patientNameController.text.trim(),
//         'patientContact': _patientContactController.text.trim(),
//         'patientUid': currentUser.uid,
//         'status': 'booked',
//         'bookedAt': FieldValue.serverTimestamp(),
//       });

//       _showFeedback('Appointment Booked Successfully!', isError: false);

//       if (!mounted) return;
//       setState(() {
//         _searchController.clear();
//         _searchTerm = "";
//         _selectedSpecialty = null;
//         _filterDoctors();
//         _clearDoctorAndBelowSelections();
//         _patientNameController.clear();
//         _patientContactController.clear();
//         _formKey.currentState?.reset();
//       });
//     } catch (e) {
//       print("Error booking appointment: $e");
//       if (mounted) _showError("Failed to book appointment. Please try again.");
//     } finally {
//       if (mounted) setState(() => _isBooking = false);
//     }
//   }

//   void _showFeedback(String message, {bool isError = false}) {
//     if (mounted && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: isError ? Colors.redAccent : Colors.green,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   void _showError(String message) {
//     _showFeedback(message, isError: true);
//   }

//   Future<void> _signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       if (mounted) {
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => RoleLoginPage()),
//           (Route<dynamic> route) => false,
//         );
//       }
//     } catch (e) {
//       if (mounted) _showError('Error signing out: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Find & Book Appointment'),
//         actions: [
//           IconButton(
//               icon: const Icon(Icons.logout),
//               tooltip: 'Sign Out',
//               onPressed: _signOut),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: <Widget>[
//               TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   labelText: 'Search Doctor or Specialty',
//                   hintText: 'e.g., Dr. Smith or Cardiology',
//                   prefixIcon: const Icon(Icons.search),
//                   border: const OutlineInputBorder(),
//                   suffixIcon: _searchTerm.isNotEmpty
//                       ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () {
//                             _searchController.clear();
//                           },
//                         )
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               if (_searchTerm.isEmpty)
//                 DropdownButtonFormField<Specialty?>(
//                   decoration: const InputDecoration(labelText: 'Filter by Specialty (Optional)'),
//                   value: _selectedSpecialty,
//                   hint: const Text('All Specialties'),
//                   isExpanded: true,
//                   items: [
//                     const DropdownMenuItem<Specialty?>(
//                       value: null,
//                       child: Text("All Specialties"),
//                     ),
//                     ..._allSpecialties.map((Specialty specialty) => DropdownMenuItem<Specialty?>(
//                           value: specialty,
//                           child: Text(specialty.name),
//                         )),
//                   ],
//                   onChanged: _isLoadingSpecialties ? null : _onSpecialtySelected,
//                 ),
//               if (_isLoadingSpecialties && _searchTerm.isEmpty)
//                 const Center(
//                     child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CircularProgressIndicator())),
//               const SizedBox(height: 20),
//               Text("Available Doctors",
//                   style: Theme.of(context).textTheme.titleMedium),
//               const SizedBox(height: 8),
//               _isLoadingDoctors
//                   ? const Center(child: CircularProgressIndicator())
//                   : _filteredDoctors.isEmpty
//                       ? Center(
//                           child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 16.0),
//                           child: Text(_searchTerm.isNotEmpty || _selectedSpecialty != null
//                               ? "No doctors found matching your criteria."
//                               : "Select a specialty or search for a doctor."),
//                         ))
//                       : DropdownButtonFormField<Doctor>(
//                           decoration:
//                               const InputDecoration(labelText: 'Select Doctor'),
//                           value: _selectedDoctor,
//                           hint: const Text('Choose a doctor'),
//                           isExpanded: true,
//                           items: _filteredDoctors.map((Doctor doctor) {
//                             return DropdownMenuItem<Doctor>(
//                                 value: doctor,
//                                 child: Text("${doctor.name} (${doctor.specialtyName})"));
//                           }).toList(),
//                           onChanged: _onDoctorSelected,
//                           validator: (value) =>
//                               value == null ? 'Please select a doctor' : null,
//                         ),
//               const SizedBox(height: 20),
//               if (_selectedDoctor != null && _hospitalAffiliations.isNotEmpty)
//                 DropdownButtonFormField<HospitalAffiliation>(
//                   decoration:
//                       const InputDecoration(labelText: 'Select Hospital'),
//                   value: _selectedHospitalAffiliation,
//                   hint: const Text('Choose a hospital'),
//                   isExpanded: true,
//                   items: _hospitalAffiliations.map((HospitalAffiliation aff) {
//                     return DropdownMenuItem<HospitalAffiliation>(
//                         value: aff, child: Text(aff.hospitalName));
//                   }).toList(),
//                   onChanged: _onHospitalSelected,
//                   validator: (value) => value == null ? 'Please select a hospital' : null,
//                 ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Select Date',
//                   hintText: _selectedDoctor == null ||
//                           _selectedHospitalAffiliation == null
//                       ? 'Select doctor & hospital first'
//                       : 'Tap to choose a date',
//                   suffixIcon: Icon(Icons.calendar_today,
//                       color: Theme.of(context).primaryColor),
//                 ),
//                 readOnly: true,
//                 controller: TextEditingController(
//                   text: _selectedDate == null
//                       ? ''
//                       : DateFormat.yMMMd().format(_selectedDate!),
//                 ),
//                 onTap: _selectedDoctor == null || _selectedHospitalAffiliation == null
//                     ? null
//                     : () => _selectDate(context),
//                 validator: (value) =>
//                     _selectedDate == null ? 'Please select a date' : null,
//               ),
//               if (_selectedDate != null && !_isDoctorGenerallyAvailableOnSelectedDate)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text("Doctor is generally not available on this day.",
//                       style: TextStyle(color: Colors.orange.shade700)),
//                 ),
//               const SizedBox(height: 20),
//               if (_selectedDate != null &&
//                   _selectedDoctor != null &&
//                   _selectedHospitalAffiliation != null &&
//                   _isDoctorGenerallyAvailableOnSelectedDate)
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     labelText: 'Select Time Slot',
//                     enabled: !_isLoadingTimeSlots && _availableTimeSlots.isNotEmpty,
//                   ),
//                   value: _selectedTimeSlot,
//                   hint: _isLoadingTimeSlots
//                       ? const Text('Loading slots...')
//                       : _availableTimeSlots.isEmpty
//                           ? const Text('No slots available')
//                           : const Text('Choose a time slot'),
//                   isExpanded: true,
//                   items: _availableTimeSlots.map((String timeSlot) {
//                     return DropdownMenuItem<String>(
//                         value: timeSlot, child: Text(timeSlot));
//                   }).toList(),
//                   onChanged: _isLoadingTimeSlots || _availableTimeSlots.isEmpty
//                       ? null
//                       : (String? newValue) =>
//                           setState(() => _selectedTimeSlot = newValue),
//                   validator: (value) => value == null ? 'Please select a time slot' : null,
//                 ),
//               if (_isLoadingTimeSlots &&
//                   _selectedDate != null &&
//                   _selectedDoctor != null &&
//                   _selectedHospitalAffiliation != null)
//                 const Center(
//                     child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CircularProgressIndicator())),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _patientNameController,
//                 decoration: const InputDecoration(
//                     labelText: 'Your Full Name',
//                     prefixIcon: Icon(Icons.person_outline)),
//                 validator: (value) =>
//                     (value == null || value.isEmpty) ? 'Please enter your name' : null,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _patientContactController,
//                 decoration: const InputDecoration(
//                     labelText: 'Your Contact Number',
//                     prefixIcon: Icon(Icons.phone_outlined)),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter contact number';
//                   if (!RegExp(r'^[0-9\s+-]{7,}$').hasMatch(value))
//                     return 'Please enter a valid phone number';
//                   return null;
//                 },
//                 textInputAction: TextInputAction.done,
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 style:
//                     ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16.0)),
//                 onPressed: _isBooking ? null : _bookAppointment,
//                 child: _isBooking
//                     ? const SizedBox(
//                         height: 24,
//                         width: 24,
//                         child: CircularProgressIndicator(
//                             color: Colors.white, strokeWidth: 3.0))
//                     : const Text('Book Appointment'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




















// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:medi_sync_plus_app/services/firestore_services.dart'; // Adjust to your project name

// class AppointmentBookingPage extends StatefulWidget {
//   const AppointmentBookingPage({super.key});

//   @override
//   State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
// }

// class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
//   final _searchController = TextEditingController();
//   String _searchQuery = '';
//   String _filterType = 'specialty'; // Default filter type
//   final FirestoreService _firestoreService = FirestoreService();

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _bookAppointment(
//     String doctorId,
//     String doctorName,
//     String hospitalId,
//     String hospitalName,
//     String specialty,
//     Map<String, dynamic> slot,
//   ) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       if (!mounted) return; // Check if widget is still in the tree
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Please log in to book an appointment")),
//       );
//       return;
//     }

//     try {
//       // It's good practice to fetch user details from a dedicated 'users' collection
//       // if you store more than just what FirebaseAuth provides.
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users') // Assuming you have a 'users' collection
//           .doc(user.uid)
//           .get();

//       if (!userDoc.exists) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User profile data not found.")),
//         );
//         return;
//       }

//       // Safely access user's name for the appointment
//       final patientName =
//           userDoc.data()?['name'] // Prefer a 'name' field if available
//                   ??
//                   userDoc.data()?['email']?.split('@')[0] ??
//                   'Patient'; // Fallback to email prefix

//       await _firestoreService.bookAppointment(
//         patientId: user.uid,
//         patientName: patientName,
//         doctorId: doctorId,
//         doctorName: doctorName,
//         hospitalId: hospitalId,
//         hospitalName: hospitalName,
//         specialty: specialty,
//         slot: slot,
//       );

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Appointment booked successfully!")),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to book appointment: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Book Appointment"),
//         backgroundColor: Colors.green[700],
//       ),
//       body: Column(
//         children: [
//           // Search bar and filter dropdown
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                       labelText: "Search",
//                       prefixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value.trim().toLowerCase();
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 DropdownButton<String>(
//                   value: _filterType,
//                   items: const [
//                     DropdownMenuItem(
//                         value: 'specialty', child: Text("Specialty")),
//                     DropdownMenuItem(
//                         value: 'doctor_name', child: Text("Doctor Name")),
//                     DropdownMenuItem(
//                         value: 'hospital_name', child: Text("Hospital Name")),
//                   ],
//                   onChanged: (String? value) {
//                     if (value != null) {
//                       setState(() {
//                         _filterType = value;
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//           // List of doctors
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               // Note: _firestoreService.getDoctors currently fetches all doctors.
//               // The search/filter is applied client-side below.
//               stream: _firestoreService.getDoctors(
//                 searchQuery: _searchQuery,
//                 filterType: _filterType,
//               ),
//               builder: (
//                 BuildContext context,
//                 AsyncSnapshot<QuerySnapshot> snapshot,
//               ) {
//                 if (snapshot.hasError) {
//                   return Center(
//                       child: Text("Error loading doctors: ${snapshot.error}"));
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting ||
//                     !snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final List<DocumentSnapshot> doctorsDocs = snapshot.data!.docs;

//                 // Client-side filtering
//                 final filteredDoctors = doctorsDocs.where((doc) {
//                   final data = doc.data() as Map<String, dynamic>?;
//                   if (data == null) return false; // Skip if data is null

//                   if (_searchQuery.isEmpty) return true; // Show all if no query

//                   String fieldValueToSearch;
//                   if (_filterType == 'specialty') {
//                     fieldValueToSearch =
//                         (data['specialty'] as String? ?? '').toLowerCase();
//                   } else if (_filterType == 'doctor_name') {
//                     fieldValueToSearch =
//                         (data['name'] as String? ?? '').toLowerCase();
//                   } else {
//                     // Assuming 'hospital_name'
//                     fieldValueToSearch =
//                         (data['hospital_name'] as String? ?? '').toLowerCase();
//                   }
//                   return fieldValueToSearch.contains(_searchQuery);
//                 }).toList();

//                 if (filteredDoctors.isEmpty) {
//                   return const Center(child: Text("No doctors found matching your criteria"));
//                 }

//                 return ListView.builder(
//                   itemCount: filteredDoctors.length,
//                   itemBuilder: (context, index) {
//                     final doctor = filteredDoctors[index];
//                     final data = doctor.data() as Map<String, dynamic>;

//                     // Safely process available_slots
//                     final List<dynamic> slotsDynamic =
//                         data['available_slots'] as List<dynamic>? ?? [];
//                     final List<Map<String, dynamic>> availableSlots =
//                         slotsDynamic
//                             .where((slot) =>
//                                 slot is Map &&
//                                 !(slot['isBooked'] as bool? ?? true))
//                             .map((slot) => slot as Map<String, dynamic>)
//                             .toList();

//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 16),
//                       child: ExpansionTile(
//                         title: Text(
//                             "${data['name'] ?? 'N/A'} (${data['specialty'] ?? 'N/A'})"),
//                         subtitle: Text(data['hospital_name'] ?? 'N/A'),
//                         children: availableSlots.isEmpty
//                             ? [const ListTile(title: Text("No available slots"))]
//                             : availableSlots.map((slot) {
//                                 return ListTile(
//                                   title: Text(
//                                       "${slot['date'] ?? 'Unknown Date'} at ${slot['time'] ?? 'Unknown Time'}"),
//                                   trailing: ElevatedButton(
//                                     onPressed: () => _bookAppointment(
//                                       doctor.id,
//                                       data['name'] as String? ?? 'Unknown Doctor',
//                                       data['hospital_id'] as String? ?? 'Unknown Hospital ID',
//                                       data['hospital_name'] as String? ?? 'Unknown Hospital',
//                                       data['specialty'] as String? ?? 'Unknown Specialty',
//                                       slot, // slot is already Map<String, dynamic>
//                                     ),
//                                     child: const Text("Book"),
//                                   ),
//                                 );
//                               }).toList(),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }















import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medi_sync_plus_app/pages/login_page/role_login_page.dart'; // Assuming this is your login page

// --- Data Models (Adjusted) ---
class Specialty {
  final String id; // e.g., "cardiology", "dentistry"
  final String name; // e.g., "Cardiology", "Dentistry"
  Specialty({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Specialty && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Specialty(id: $id, name: $name)';
}

class Doctor {
  final String id;
  final String name;
  final String specialtyId; // e.g., "cardiology"
  final String specialtyName; // e.g., "Cardiology"
  final List<HospitalAffiliation> hospitalAffiliations;
  // weeklyAvailability is removed, slots are fetched directly

  Doctor({
    required this.id,
    required this.name,
    required this.specialtyId,
    required this.specialtyName,
    required this.hospitalAffiliations,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Doctor && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class HospitalAffiliation {
  final String hospitalId;
  final String hospitalName;
  HospitalAffiliation({required this.hospitalId, required this.hospitalName});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HospitalAffiliation &&
          runtimeType == other.runtimeType &&
          hospitalId == other.hospitalId;

  @override
  int get hashCode => hospitalId.hashCode;
}

// Represents a fetched available slot for UI display
class AvailableSlot {
  final String slotId; // Document ID of the slot in the subcollection
  final DateTime startTime;
  final DateTime endTime;
  final String displayTime; // e.g., "09:00 AM - 09:30 AM"

  AvailableSlot({
    required this.slotId,
    required this.startTime,
    required this.endTime,
    required this.displayTime,
  });

   @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvailableSlot &&
          runtimeType == other.runtimeType &&
          slotId == other.slotId;

  @override
  int get hashCode => slotId.hashCode;
}
// --- End Data Models ---

class AppointmentBookingPage extends StatefulWidget {
  const AppointmentBookingPage({super.key});

  @override
  State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";

  Specialty? _selectedSpecialty;
  Doctor? _selectedDoctor;
  HospitalAffiliation? _selectedHospitalAffiliation;
  DateTime? _selectedDate;
  AvailableSlot? _selectedSlot; // Changed from String to AvailableSlot

  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientContactController = TextEditingController();

  List<Specialty> _allSpecialties = [];
  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  List<HospitalAffiliation> _hospitalAffiliations = [];
  List<AvailableSlot> _availableTimeSlots = []; // Changed from List<String>

  bool _isLoadingSpecialties = true;
  bool _isLoadingDoctors = false;
  bool _isLoadingTimeSlots = false;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _searchController.addListener(() {
      if (!mounted) return;
      setState(() {
        _searchTerm = _searchController.text.trim();
        _filterDoctors();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _patientNameController.dispose();
    _patientContactController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      print("User not authenticated. Redirecting to login.");
      if (mounted) {
        _showError("Please log in to continue.");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RoleLoginPage()), // Ensure RoleLoginPage is imported/defined
          (Route<dynamic> route) => false,
        );
      }
      return;
    }

    // Prefetch patient name if available from user profile (optional)
    // if (currentUser.displayName != null && currentUser.displayName!.isNotEmpty) {
    //   _patientNameController.text = currentUser.displayName!;
    // }
    // Fetch from your 'users' or 'patients' collection if you store more details
    DocumentSnapshot userProfile = await _firestore.collection('users').doc(currentUser.uid).get();
    if(userProfile.exists && userProfile.data() != null) {
        var userData = userProfile.data() as Map<String, dynamic>;
        if(userData.containsKey('fullName') && userData['fullName'] != null) {
            _patientNameController.text = userData['fullName'];
        }
        if(userData.containsKey('phoneNumber') && userData['phoneNumber'] != null) {
            _patientContactController.text = userData['phoneNumber'];
        }
    }


    await _fetchSpecialties();
    await _fetchAllDoctors();
  }

  Future<void> _fetchSpecialties() async {
    if (!mounted) return;
    setState(() => _isLoadingSpecialties = true);
    try {
      print("Fetching specialties from Firestore 'specialties' collection...");
      QuerySnapshot snapshot =
          await _firestore.collection('specialties').orderBy('name').get(); // Assuming you have a 'name' field for ordering
      if (!mounted) return;

      if (snapshot.docs.isEmpty) {
        print("No specialties found in Firestore.");
        if (mounted) _showError("No specialties available in the database.");
        setState(() {
          _allSpecialties = [];
        });
        return;
      }

      _allSpecialties = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        // The document ID IS the specialty ID (e.g., "cardiology")
        // The document has a field 'name' (e.g., "Cardiology")
        return Specialty(id: doc.id, name: data['name'] as String? ?? "Unnamed Specialty");
      }).toList();

      print("Fetched specialties: ${_allSpecialties.map((s) => '${s.id}: ${s.name}').toList()}");
    } catch (e, stackTrace) {
      print("Error fetching specialties: $e\n$stackTrace");
      if (mounted) _showError("Could not load specialties. Please try again.");
    } finally {
      if (mounted) {
        setState(() => _isLoadingSpecialties = false);
        _filterDoctors(); // Initial filter
      }
    }
  }

  Future<void> _fetchAllDoctors() async {
    if (!mounted) return;
    setState(() {
      _isLoadingDoctors = true;
      _allDoctors = [];
      _filteredDoctors = [];
    });
    try {
      QuerySnapshot doctorSnapshot = await _firestore.collection('doctors').where('isEnabled', isEqualTo: true).get();
      if (!mounted) return;

      _allDoctors = await Future.wait(doctorSnapshot.docs.map((doc) async {
        var data = doc.data() as Map<String, dynamic>;
        List<dynamic> affiliationsData = data['affiliatedHospitals'] ?? [];
        List<HospitalAffiliation> affiliations = affiliationsData.map((aff) {
          return HospitalAffiliation(
              hospitalId: aff['hospitalId'] as String,
              hospitalName: aff['hospitalName'] as String);
        }).toList();

        String specialtyId = data['specialtyId'] as String? ?? ""; // This is the doc ID from 'specialties'
        String specialtyName = "Unknown Specialty";

        if (specialtyId.isNotEmpty) {
          // Find in already fetched specialties
          final foundSpecialty = _allSpecialties.firstWhere(
            (s) => s.id == specialtyId,
            orElse: () => Specialty(id: specialtyId, name: "Loading...") // Placeholder
          );
          if (foundSpecialty.name != "Loading...") {
            specialtyName = foundSpecialty.name;
          } else {
            // Fallback: Fetch directly if not found (shouldn't happen if _fetchSpecialties ran first)
            try {
                DocumentSnapshot specialtyDoc = await _firestore.collection('specialties').doc(specialtyId).get();
                if (specialtyDoc.exists) {
                specialtyName = (specialtyDoc.data() as Map<String, dynamic>)['name'] as String? ?? "Unnamed Specialty";
                }
            } catch (e) {
                print("Error fetching specialty details for doctor ${doc.id}, specialtyId ${specialtyId}: $e");
            }
          }
        }

        return Doctor(
          id: doc.id,
          name: data['fullName'] as String? ?? 'N/A', // Use fullName
          specialtyId: specialtyId,
          specialtyName: specialtyName,
          hospitalAffiliations: affiliations,
        );
      }).toList());

      _filterDoctors();
    } catch (e, s) {
      print("Error fetching all doctors: $e\n$s");
      if (mounted) _showError("Could not load doctor list.");
    }
    if (mounted) setState(() => _isLoadingDoctors = false);
  }

  void _filterDoctors() {
    if (!mounted) return;
    List<Doctor> tempFiltered;
    if (_searchTerm.isEmpty && _selectedSpecialty == null) {
      tempFiltered = List.from(_allDoctors);
    } else {
      tempFiltered = _allDoctors.where((doctor) {
        bool matchesSearchTerm = _searchTerm.isEmpty ||
            doctor.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            doctor.specialtyName.toLowerCase().contains(_searchTerm.toLowerCase());
        
        bool matchesSpecialty = _selectedSpecialty == null ||
            doctor.specialtyId == _selectedSpecialty!.id;
        
        return matchesSearchTerm && matchesSpecialty;
      }).toList();
    }

    // If current selected doctor is no longer in filtered list, clear it
    if (_selectedDoctor != null && !tempFiltered.any((d) => d.id == _selectedDoctor!.id)) {
        _clearDoctorAndBelowSelections();
    }

    setState(() {
      _filteredDoctors = tempFiltered;
    });
  }

  void _clearDoctorAndBelowSelections() {
    if (!mounted) return;
    setState(() {
      _selectedDoctor = null;
      _hospitalAffiliations = [];
      _selectedHospitalAffiliation = null;
      _clearDateAndBelowSelections();
    });
  }

  void _clearDateAndBelowSelections() {
    if (!mounted) return;
    setState(() {
      _selectedDate = null;
      _availableTimeSlots = [];
      _selectedSlot = null;
    });
  }

  void _onSpecialtySelected(Specialty? specialty) {
    if (!mounted) return;
    setState(() {
      _selectedSpecialty = specialty;
      _searchController.clear(); // Clear search when specialty filter is used
      _searchTerm = "";
      _clearDoctorAndBelowSelections();
      _filterDoctors();
    });
  }

  void _onDoctorSelected(Doctor? doctor) {
    if (!mounted) return;
    setState(() {
      _selectedDoctor = doctor;
      _hospitalAffiliations = doctor?.hospitalAffiliations ?? [];
      // Auto-select first hospital if available, or null
      _selectedHospitalAffiliation = _hospitalAffiliations.isNotEmpty ? _hospitalAffiliations.first : null;
      _clearDateAndBelowSelections();
    });
  }

  void _onHospitalSelected(HospitalAffiliation? hospitalAffiliation) {
    if (!mounted) return;
    setState(() {
      _selectedHospitalAffiliation = hospitalAffiliation;
      _clearDateAndBelowSelections();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    if (_selectedDoctor == null || _selectedHospitalAffiliation == null) {
      _showError("Please select a doctor and hospital first.");
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days:1)), // Start from tomorrow
      firstDate: DateTime.now().add(const Duration(days:1)), // Can't book for today
      lastDate: DateTime.now().add(const Duration(days: 90)), // Book up to 90 days ahead
    );

    if (picked != null && picked != _selectedDate) {
      if (!mounted) return;
      setState(() {
        _selectedDate = picked;
        _selectedSlot = null; // Reset selected slot
        _fetchAvailableTimeSlots();
      });
    }
  }

  Future<void> _fetchAvailableTimeSlots() async {
    if (_selectedDoctor == null ||
        _selectedDate == null ||
        _selectedHospitalAffiliation == null) {
      if (mounted) setState(() => _availableTimeSlots = []);
      return;
    }
    if (!mounted) return;
    setState(() {
      _isLoadingTimeSlots = true;
      _availableTimeSlots = [];
      _selectedSlot = null;
    });

    try {
      // Define start and end of the selected day for Firestore query
      DateTime startOfDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, 0, 0, 0);
      DateTime endOfDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, 23, 59, 59);

      Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
      Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

      print("Fetching slots for Dr: ${_selectedDoctor!.id}, Hosp: ${_selectedHospitalAffiliation!.hospitalId}, Date: $_selectedDate");
      print("Querying slots from ${startOfDay.toIso8601String()} to ${endOfDay.toIso8601String()}");

      QuerySnapshot slotSnapshot = await _firestore
          .collection('doctors')
          .doc(_selectedDoctor!.id)
          .collection('availabilitySlots')
          .where('hospitalId', isEqualTo: _selectedHospitalAffiliation!.hospitalId)
          .where('startTime', isGreaterThanOrEqualTo: startTimestamp)
          .where('startTime', isLessThanOrEqualTo: endTimestamp)
          .where('isBooked', isEqualTo: false)
          .orderBy('startTime') // Important for displaying in order
          .get();

      if (!mounted) return;

      if (slotSnapshot.docs.isEmpty) {
        print("No available slots found matching criteria.");
      }

      _availableTimeSlots = slotSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        Timestamp startTimeStamp = data['startTime'] as Timestamp;
        Timestamp endTimeStamp = data['endTime'] as Timestamp;
        DateTime sTime = startTimeStamp.toDate();
        DateTime eTime = endTimeStamp.toDate();

        return AvailableSlot(
          slotId: doc.id,
          startTime: sTime,
          endTime: eTime,
          displayTime: "${DateFormat.jm().format(sTime)} - ${DateFormat.jm().format(eTime)}",
        );
      }).toList();

      print("Fetched ${_availableTimeSlots.length} available slots.");

    } catch (e, s) {
      print("Error fetching time slots: $e\n$s");
      if (mounted) _showError("Could not load available time slots.");
    } finally {
      if (mounted) setState(() => _isLoadingTimeSlots = false);
    }
  }

  Future<void> _bookAppointment() async {
    if (!_formKey.currentState!.validate()) {
       _showError("Please fill all required fields correctly.");
       return;
    }
    _formKey.currentState!.save();

    if (_selectedDoctor == null ||
        _selectedHospitalAffiliation == null ||
        _selectedDate == null ||
        _selectedSlot == null) {
      _showError("Please make all required selections (Doctor, Hospital, Date, Time).");
      return;
    }
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      _showError("You must be logged in to book an appointment.");
      // Optionally redirect to login
      return;
    }

    if (!mounted) return;
    setState(() => _isBooking = true);

    final appointmentRef = _firestore.collection('appointments').doc();
    final slotRef = _firestore
        .collection('doctors')
        .doc(_selectedDoctor!.id)
        .collection('availabilitySlots')
        .doc(_selectedSlot!.slotId);

    try {
      // Use a Firestore transaction
      await _firestore.runTransaction((transaction) async {
        // 1. Read the slot to ensure it's still available
        DocumentSnapshot slotDoc = await transaction.get(slotRef);
        if (!slotDoc.exists) {
          throw Exception("Selected time slot no longer exists.");
        }
        var slotData = slotDoc.data() as Map<String, dynamic>;
        if (slotData['isBooked'] == true) {
          throw Exception("This time slot was just booked by someone else. Please select another.");
        }

        // 2. Create the appointment document
        transaction.set(appointmentRef, {
          'appointmentId': appointmentRef.id, // Store the ID within the document
          'specialtyId': _selectedDoctor!.specialtyId,
          'specialtyName': _selectedDoctor!.specialtyName,
          'doctorId': _selectedDoctor!.id,
          'doctorName': _selectedDoctor!.name,
          'hospitalId': _selectedHospitalAffiliation!.hospitalId,
          'hospitalName': _selectedHospitalAffiliation!.hospitalName,
          'appointmentStartTime': Timestamp.fromDate(_selectedSlot!.startTime),
          'appointmentEndTime': Timestamp.fromDate(_selectedSlot!.endTime),
          'patientName': _patientNameController.text.trim(),
          'patientContact': _patientContactController.text.trim(),
          'patientUid': currentUser.uid,
          'status': 'confirmed', // Or 'pending_confirmation' if admin needs to approve
          'bookedAt': FieldValue.serverTimestamp(),
          'slotId': _selectedSlot!.slotId, // Link back to the slot
        });

        // 3. Update the slot document
        transaction.update(slotRef, {
          'isBooked': true,
          'bookedByPatientId': currentUser.uid,
          'appointmentId': appointmentRef.id,
        });
      });

      _showFeedback('Appointment Booked Successfully!', isError: false);

      if (!mounted) return;
      // Reset the form and selections
      setState(() {
        _searchController.clear();
        _searchTerm = "";
        _selectedSpecialty = null;
        _clearDoctorAndBelowSelections(); // This will clear doctor, hospital, date, slot
        _patientNameController.clear(); // Consider if you want to keep these prefilled
        _patientContactController.clear(); // for subsequent bookings by same user
        _formKey.currentState?.reset();
        _filterDoctors(); // Re-filter doctors to show all
      });

    } catch (e) {
      print("Error booking appointment: $e");
      if (mounted) _showError("Failed to book appointment: ${e.toString().replaceFirst("Exception: ", "")}");
      // If booking failed, refresh slots in case one was taken
      if (mounted) _fetchAvailableTimeSlots();
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  void _showFeedback(String message, {bool isError = false}) {
    if (mounted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : Theme.of(context).primaryColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showError(String message) {
    _showFeedback(message, isError: true);
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RoleLoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) _showError('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find & Book Appointment'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sign Out',
              onPressed: _signOut),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Search Field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Doctor or Specialty',
                  hintText: 'e.g., Dr. Alice or Cardiology',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: _searchTerm.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear(); // This will trigger the listener
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Specialty Filter Dropdown (only if search is empty)
              if (_searchTerm.isEmpty)
                DropdownButtonFormField<Specialty?>(
                  decoration: InputDecoration(
                      labelText: 'Filter by Specialty (Optional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  value: _selectedSpecialty,
                  hint: const Text('All Specialties'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<Specialty?>(
                      value: null,
                      child: Text("All Specialties"),
                    ),
                    ..._allSpecialties.map((Specialty specialty) => DropdownMenuItem<Specialty?>(
                          value: specialty,
                          child: Text(specialty.name),
                        )),
                  ],
                  onChanged: _isLoadingSpecialties ? null : _onSpecialtySelected,
                ),
              if (_isLoadingSpecialties && _searchTerm.isEmpty)
                const Center(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator())),
              const SizedBox(height: 16),

              // Select Doctor Dropdown
              Text("Select Doctor", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _isLoadingDoctors
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredDoctors.isEmpty
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            _allDoctors.isEmpty && !_isLoadingSpecialties? "No doctors available at the moment."
                            : "No doctors found matching your criteria.",
                          style: TextStyle(color: Colors.grey[600]),),
                        ))
                      : DropdownButtonFormField<Doctor>(
                          decoration: InputDecoration(
                            labelText: 'Select Doctor',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          value: _selectedDoctor,
                          hint: const Text('Choose a doctor'),
                          isExpanded: true,
                          items: _filteredDoctors.map((Doctor doctor) {
                            return DropdownMenuItem<Doctor>(
                                value: doctor,
                                child: Text("${doctor.name} (${doctor.specialtyName})"));
                          }).toList(),
                          onChanged: _onDoctorSelected,
                          validator: (value) => value == null ? 'Please select a doctor' : null,
                        ),
              const SizedBox(height: 16),

              // Select Hospital Dropdown
              if (_selectedDoctor != null && _hospitalAffiliations.isNotEmpty)
                DropdownButtonFormField<HospitalAffiliation>(
                  decoration: InputDecoration(
                    labelText: 'Select Hospital/Clinic',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  value: _selectedHospitalAffiliation,
                  hint: const Text('Choose a hospital or clinic'),
                  isExpanded: true,
                  items: _hospitalAffiliations.map((HospitalAffiliation aff) {
                    return DropdownMenuItem<HospitalAffiliation>(
                        value: aff, child: Text(aff.hospitalName));
                  }).toList(),
                  onChanged: _onHospitalSelected,
                  validator: (value) => value == null ? 'Please select a hospital/clinic' : null,
                ),
              if (_selectedDoctor != null && _hospitalAffiliations.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("This doctor has no listed hospital affiliations.", style: TextStyle(color: Colors.orange.shade700)),
                ),
              const SizedBox(height: 16),

              // Select Date
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  hintText: _selectedDoctor == null || _selectedHospitalAffiliation == null
                      ? 'Select doctor & hospital first'
                      : 'Tap to choose a date',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: Icon(Icons.calendar_today,
                      color: Theme.of(context).primaryColorDark),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : DateFormat.yMMMd().format(_selectedDate!), // e.g., Dec 15, 2023
                ),
                onTap: _selectedDoctor == null || _selectedHospitalAffiliation == null
                    ? null : () => _selectDate(context),
                validator: (value) => _selectedDate == null ? 'Please select a date' : null,
              ),
              const SizedBox(height: 16),

              // Select Time Slot Dropdown
              if (_selectedDate != null && _selectedDoctor != null && _selectedHospitalAffiliation != null)
                DropdownButtonFormField<AvailableSlot>(
                  decoration: InputDecoration(
                    labelText: 'Select Time Slot',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    enabled: !_isLoadingTimeSlots && _availableTimeSlots.isNotEmpty,
                  ),
                  value: _selectedSlot,
                  hint: _isLoadingTimeSlots
                      ? const Text('Loading slots...')
                      : _availableTimeSlots.isEmpty
                          ? Text('No slots available for ${DateFormat.yMMMd().format(_selectedDate!)}')
                          : const Text('Choose a time slot'),
                  isExpanded: true,
                  items: _availableTimeSlots.map((AvailableSlot slot) {
                    return DropdownMenuItem<AvailableSlot>(
                        value: slot, child: Text(slot.displayTime));
                  }).toList(),
                  onChanged: _isLoadingTimeSlots || _availableTimeSlots.isEmpty
                      ? null
                      : (AvailableSlot? newValue) => setState(() => _selectedSlot = newValue),
                  validator: (value) => value == null ? 'Please select a time slot' : null,
                ),
              if (_isLoadingTimeSlots && _selectedDate != null && _selectedDoctor != null && _selectedHospitalAffiliation != null)
                const Center(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator())),
              const SizedBox(height: 20),

              // Patient Details
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(
                    labelText: 'Your Full Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixIcon: Icon(Icons.person_outline)),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter your name' : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _patientContactController,
                decoration: InputDecoration(
                    labelText: 'Your Contact Number',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixIcon: Icon(Icons.phone_outlined)),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter contact number';
                  if (!RegExp(r'^[0-9\s+-]{7,}$').hasMatch(value)) return 'Please enter a valid phone number';
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 30),

              // Book Appointment Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _isBooking ? null : _bookAppointment,
                child: _isBooking
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0))
                    : const Text('Book Appointment', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}