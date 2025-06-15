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















// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:medi_sync_plus_app/pages/login_page/role_login_page.dart'; // Assuming this is your login page

// // --- Data Models (Adjusted) ---
// class Specialty {
//   final String id; // e.g., "cardiology", "dentistry"
//   final String name; // e.g., "Cardiology", "Dentistry"
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
//   final String specialtyId; // e.g., "cardiology"
//   final String specialtyName; // e.g., "Cardiology"
//   final List<HospitalAffiliation> hospitalAffiliations;
//   // weeklyAvailability is removed, slots are fetched directly

//   Doctor({
//     required this.id,
//     required this.name,
//     required this.specialtyId,
//     required this.specialtyName,
//     required this.hospitalAffiliations,
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

// // Represents a fetched available slot for UI display
// class AvailableSlot {
//   final String slotId; // Document ID of the slot in the subcollection
//   final DateTime startTime;
//   final DateTime endTime;
//   final String displayTime; // e.g., "09:00 AM - 09:30 AM"

//   AvailableSlot({
//     required this.slotId,
//     required this.startTime,
//     required this.endTime,
//     required this.displayTime,
//   });

//    @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is AvailableSlot &&
//           runtimeType == other.runtimeType &&
//           slotId == other.slotId;

//   @override
//   int get hashCode => slotId.hashCode;
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
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final TextEditingController _searchController = TextEditingController();
//   String _searchTerm = "";

//   Specialty? _selectedSpecialty;
//   Doctor? _selectedDoctor;
//   HospitalAffiliation? _selectedHospitalAffiliation;
//   DateTime? _selectedDate;
//   AvailableSlot? _selectedSlot; // Changed from String to AvailableSlot

//   final TextEditingController _patientNameController = TextEditingController();
//   final TextEditingController _patientContactController = TextEditingController();

//   List<Specialty> _allSpecialties = [];
//   List<Doctor> _allDoctors = [];
//   List<Doctor> _filteredDoctors = [];
//   List<HospitalAffiliation> _hospitalAffiliations = [];
//   List<AvailableSlot> _availableTimeSlots = []; // Changed from List<String>

//   bool _isLoadingSpecialties = true;
//   bool _isLoadingDoctors = false;
//   bool _isLoadingTimeSlots = false;
//   bool _isBooking = false;

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
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) {
//       print("User not authenticated. Redirecting to login.");
//       if (mounted) {
//         _showError("Please log in to continue.");
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => RoleLoginPage()), // Ensure RoleLoginPage is imported/defined
//           (Route<dynamic> route) => false,
//         );
//       }
//       return;
//     }

//     // Prefetch patient name if available from user profile (optional)
//     // if (currentUser.displayName != null && currentUser.displayName!.isNotEmpty) {
//     //   _patientNameController.text = currentUser.displayName!;
//     // }
//     // Fetch from your 'users' or 'patients' collection if you store more details
//     DocumentSnapshot userProfile = await _firestore.collection('users').doc(currentUser.uid).get();
//     if(userProfile.exists && userProfile.data() != null) {
//         var userData = userProfile.data() as Map<String, dynamic>;
//         if(userData.containsKey('fullName') && userData['fullName'] != null) {
//             _patientNameController.text = userData['fullName'];
//         }
//         if(userData.containsKey('phoneNumber') && userData['phoneNumber'] != null) {
//             _patientContactController.text = userData['phoneNumber'];
//         }
//     }


//     await _fetchSpecialties();
//     await _fetchAllDoctors();
//   }

//   Future<void> _fetchSpecialties() async {
//     if (!mounted) return;
//     setState(() => _isLoadingSpecialties = true);
//     try {
//       print("Fetching specialties from Firestore 'specialties' collection...");
//       QuerySnapshot snapshot =
//           await _firestore.collection('specialties').orderBy('name').get(); // Assuming you have a 'name' field for ordering
//       if (!mounted) return;

//       if (snapshot.docs.isEmpty) {
//         print("No specialties found in Firestore.");
//         if (mounted) _showError("No specialties available in the database.");
//         setState(() {
//           _allSpecialties = [];
//         });
//         return;
//       }

//       _allSpecialties = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         // The document ID IS the specialty ID (e.g., "cardiology")
//         // The document has a field 'name' (e.g., "Cardiology")
//         return Specialty(id: doc.id, name: data['name'] as String? ?? "Unnamed Specialty");
//       }).toList();

//       print("Fetched specialties: ${_allSpecialties.map((s) => '${s.id}: ${s.name}').toList()}");
//     } catch (e, stackTrace) {
//       print("Error fetching specialties: $e\n$stackTrace");
//       if (mounted) _showError("Could not load specialties. Please try again.");
//     } finally {
//       if (mounted) {
//         setState(() => _isLoadingSpecialties = false);
//         _filterDoctors(); // Initial filter
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
//       QuerySnapshot doctorSnapshot = await _firestore.collection('doctors').where('isEnabled', isEqualTo: true).get();
//       if (!mounted) return;

//       _allDoctors = await Future.wait(doctorSnapshot.docs.map((doc) async {
//         var data = doc.data() as Map<String, dynamic>;
//         List<dynamic> affiliationsData = data['affiliatedHospitals'] ?? [];
//         List<HospitalAffiliation> affiliations = affiliationsData.map((aff) {
//           return HospitalAffiliation(
//               hospitalId: aff['hospitalId'] as String,
//               hospitalName: aff['hospitalName'] as String);
//         }).toList();

//         String specialtyId = data['specialtyId'] as String? ?? ""; // This is the doc ID from 'specialties'
//         String specialtyName = "Unknown Specialty";

//         if (specialtyId.isNotEmpty) {
//           // Find in already fetched specialties
//           final foundSpecialty = _allSpecialties.firstWhere(
//             (s) => s.id == specialtyId,
//             orElse: () => Specialty(id: specialtyId, name: "Loading...") // Placeholder
//           );
//           if (foundSpecialty.name != "Loading...") {
//             specialtyName = foundSpecialty.name;
//           } else {
//             // Fallback: Fetch directly if not found (shouldn't happen if _fetchSpecialties ran first)
//             try {
//                 DocumentSnapshot specialtyDoc = await _firestore.collection('specialties').doc(specialtyId).get();
//                 if (specialtyDoc.exists) {
//                 specialtyName = (specialtyDoc.data() as Map<String, dynamic>)['name'] as String? ?? "Unnamed Specialty";
//                 }
//             } catch (e) {
//                 print("Error fetching specialty details for doctor ${doc.id}, specialtyId ${specialtyId}: $e");
//             }
//           }
//         }

//         return Doctor(
//           id: doc.id,
//           name: data['fullName'] as String? ?? 'N/A', // Use fullName
//           specialtyId: specialtyId,
//           specialtyName: specialtyName,
//           hospitalAffiliations: affiliations,
//         );
//       }).toList());

//       _filterDoctors();
//     } catch (e, s) {
//       print("Error fetching all doctors: $e\n$s");
//       if (mounted) _showError("Could not load doctor list.");
//     }
//     if (mounted) setState(() => _isLoadingDoctors = false);
//   }

//   void _filterDoctors() {
//     if (!mounted) return;
//     List<Doctor> tempFiltered;
//     if (_searchTerm.isEmpty && _selectedSpecialty == null) {
//       tempFiltered = List.from(_allDoctors);
//     } else {
//       tempFiltered = _allDoctors.where((doctor) {
//         bool matchesSearchTerm = _searchTerm.isEmpty ||
//             doctor.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
//             doctor.specialtyName.toLowerCase().contains(_searchTerm.toLowerCase());
        
//         bool matchesSpecialty = _selectedSpecialty == null ||
//             doctor.specialtyId == _selectedSpecialty!.id;
        
//         return matchesSearchTerm && matchesSpecialty;
//       }).toList();
//     }

//     // If current selected doctor is no longer in filtered list, clear it
//     if (_selectedDoctor != null && !tempFiltered.any((d) => d.id == _selectedDoctor!.id)) {
//         _clearDoctorAndBelowSelections();
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
//       _clearDateAndBelowSelections();
//     });
//   }

//   void _clearDateAndBelowSelections() {
//     if (!mounted) return;
//     setState(() {
//       _selectedDate = null;
//       _availableTimeSlots = [];
//       _selectedSlot = null;
//     });
//   }

//   void _onSpecialtySelected(Specialty? specialty) {
//     if (!mounted) return;
//     setState(() {
//       _selectedSpecialty = specialty;
//       _searchController.clear(); // Clear search when specialty filter is used
//       _searchTerm = "";
//       _clearDoctorAndBelowSelections();
//       _filterDoctors();
//     });
//   }

//   void _onDoctorSelected(Doctor? doctor) {
//     if (!mounted) return;
//     setState(() {
//       _selectedDoctor = doctor;
//       _hospitalAffiliations = doctor?.hospitalAffiliations ?? [];
//       // Auto-select first hospital if available, or null
//       _selectedHospitalAffiliation = _hospitalAffiliations.isNotEmpty ? _hospitalAffiliations.first : null;
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
//       initialDate: _selectedDate ?? DateTime.now().add(const Duration(days:1)), // Start from tomorrow
//       firstDate: DateTime.now().add(const Duration(days:1)), // Can't book for today
//       lastDate: DateTime.now().add(const Duration(days: 90)), // Book up to 90 days ahead
//     );

//     if (picked != null && picked != _selectedDate) {
//       if (!mounted) return;
//       setState(() {
//         _selectedDate = picked;
//         _selectedSlot = null; // Reset selected slot
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
//       _selectedSlot = null;
//     });

//     try {
//       // Define start and end of the selected day for Firestore query
//       DateTime startOfDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, 0, 0, 0);
//       DateTime endOfDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, 23, 59, 59);

//       Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
//       Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

//       print("Fetching slots for Dr: ${_selectedDoctor!.id}, Hosp: ${_selectedHospitalAffiliation!.hospitalId}, Date: $_selectedDate");
//       print("Querying slots from ${startOfDay.toIso8601String()} to ${endOfDay.toIso8601String()}");

//       QuerySnapshot slotSnapshot = await _firestore
//           .collection('doctors')
//           .doc(_selectedDoctor!.id)
//           .collection('availabilitySlots')
//           .where('hospitalId', isEqualTo: _selectedHospitalAffiliation!.hospitalId)
//           .where('startTime', isGreaterThanOrEqualTo: startTimestamp)
//           .where('startTime', isLessThanOrEqualTo: endTimestamp)
//           .where('isBooked', isEqualTo: false)
//           .orderBy('startTime') // Important for displaying in order
//           .get();

//       if (!mounted) return;

//       if (slotSnapshot.docs.isEmpty) {
//         print("No available slots found matching criteria.");
//       }

//       _availableTimeSlots = slotSnapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         Timestamp startTimeStamp = data['startTime'] as Timestamp;
//         Timestamp endTimeStamp = data['endTime'] as Timestamp;
//         DateTime sTime = startTimeStamp.toDate();
//         DateTime eTime = endTimeStamp.toDate();

//         return AvailableSlot(
//           slotId: doc.id,
//           startTime: sTime,
//           endTime: eTime,
//           displayTime: "${DateFormat.jm().format(sTime)} - ${DateFormat.jm().format(eTime)}",
//         );
//       }).toList();

//       print("Fetched ${_availableTimeSlots.length} available slots.");

//     } catch (e, s) {
//       print("Error fetching time slots: $e\n$s");
//       if (mounted) _showError("Could not load available time slots.");
//     } finally {
//       if (mounted) setState(() => _isLoadingTimeSlots = false);
//     }
//   }

//   Future<void> _bookAppointment() async {
//     if (!_formKey.currentState!.validate()) {
//        _showError("Please fill all required fields correctly.");
//        return;
//     }
//     _formKey.currentState!.save();

//     if (_selectedDoctor == null ||
//         _selectedHospitalAffiliation == null ||
//         _selectedDate == null ||
//         _selectedSlot == null) {
//       _showError("Please make all required selections (Doctor, Hospital, Date, Time).");
//       return;
//     }
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) {
//       _showError("You must be logged in to book an appointment.");
//       // Optionally redirect to login
//       return;
//     }

//     if (!mounted) return;
//     setState(() => _isBooking = true);

//     final appointmentRef = _firestore.collection('appointments').doc();
//     final slotRef = _firestore
//         .collection('doctors')
//         .doc(_selectedDoctor!.id)
//         .collection('availabilitySlots')
//         .doc(_selectedSlot!.slotId);

//     try {
//       // Use a Firestore transaction
//       await _firestore.runTransaction((transaction) async {
//         // 1. Read the slot to ensure it's still available
//         DocumentSnapshot slotDoc = await transaction.get(slotRef);
//         if (!slotDoc.exists) {
//           throw Exception("Selected time slot no longer exists.");
//         }
//         var slotData = slotDoc.data() as Map<String, dynamic>;
//         if (slotData['isBooked'] == true) {
//           throw Exception("This time slot was just booked by someone else. Please select another.");
//         }

//         // 2. Create the appointment document
//         transaction.set(appointmentRef, {
//           'appointmentId': appointmentRef.id, // Store the ID within the document
//           'specialtyId': _selectedDoctor!.specialtyId,
//           'specialtyName': _selectedDoctor!.specialtyName,
//           'doctorId': _selectedDoctor!.id,
//           'doctorName': _selectedDoctor!.name,
//           'hospitalId': _selectedHospitalAffiliation!.hospitalId,
//           'hospitalName': _selectedHospitalAffiliation!.hospitalName,
//           'appointmentStartTime': Timestamp.fromDate(_selectedSlot!.startTime),
//           'appointmentEndTime': Timestamp.fromDate(_selectedSlot!.endTime),
//           'patientName': _patientNameController.text.trim(),
//           'patientContact': _patientContactController.text.trim(),
//           'patientUid': currentUser.uid,
//           'status': 'confirmed', // Or 'pending_confirmation' if admin needs to approve
//           'bookedAt': FieldValue.serverTimestamp(),
//           'slotId': _selectedSlot!.slotId, // Link back to the slot
//         });

//         // 3. Update the slot document
//         transaction.update(slotRef, {
//           'isBooked': true,
//           'bookedByPatientId': currentUser.uid,
//           'appointmentId': appointmentRef.id,
//         });
//       });

//       _showFeedback('Appointment Booked Successfully!', isError: false);

//       if (!mounted) return;
//       // Reset the form and selections
//       setState(() {
//         _searchController.clear();
//         _searchTerm = "";
//         _selectedSpecialty = null;
//         _clearDoctorAndBelowSelections(); // This will clear doctor, hospital, date, slot
//         _patientNameController.clear(); // Consider if you want to keep these prefilled
//         _patientContactController.clear(); // for subsequent bookings by same user
//         _formKey.currentState?.reset();
//         _filterDoctors(); // Re-filter doctors to show all
//       });

//     } catch (e) {
//       print("Error booking appointment: $e");
//       if (mounted) _showError("Failed to book appointment: ${e.toString().replaceFirst("Exception: ", "")}");
//       // If booking failed, refresh slots in case one was taken
//       if (mounted) _fetchAvailableTimeSlots();
//     } finally {
//       if (mounted) setState(() => _isBooking = false);
//     }
//   }

//   void _showFeedback(String message, {bool isError = false}) {
//     if (mounted && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: isError ? Colors.redAccent : Theme.of(context).primaryColor,
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
//       await _auth.signOut();
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
//               // Search Field
//               TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   labelText: 'Search Doctor or Specialty',
//                   hintText: 'e.g., Dr. Alice or Cardiology',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   suffixIcon: _searchTerm.isNotEmpty
//                       ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () {
//                             _searchController.clear(); // This will trigger the listener
//                           },
//                         )
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Specialty Filter Dropdown (only if search is empty)
//               if (_searchTerm.isEmpty)
//                 DropdownButtonFormField<Specialty?>(
//                   decoration: InputDecoration(
//                       labelText: 'Filter by Specialty (Optional)',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
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
//               const SizedBox(height: 16),

//               // Select Doctor Dropdown
//               Text("Select Doctor", style: Theme.of(context).textTheme.titleMedium),
//               const SizedBox(height: 8),
//               _isLoadingDoctors
//                   ? const Center(child: CircularProgressIndicator())
//                   : _filteredDoctors.isEmpty
//                       ? Center(
//                           child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 16.0),
//                           child: Text(
//                             _allDoctors.isEmpty && !_isLoadingSpecialties? "No doctors available at the moment."
//                             : "No doctors found matching your criteria.",
//                           style: TextStyle(color: Colors.grey[600]),),
//                         ))
//                       : DropdownButtonFormField<Doctor>(
//                           decoration: InputDecoration(
//                             labelText: 'Select Doctor',
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                           ),
//                           value: _selectedDoctor,
//                           hint: const Text('Choose a doctor'),
//                           isExpanded: true,
//                           items: _filteredDoctors.map((Doctor doctor) {
//                             return DropdownMenuItem<Doctor>(
//                                 value: doctor,
//                                 child: Text("${doctor.name} (${doctor.specialtyName})"));
//                           }).toList(),
//                           onChanged: _onDoctorSelected,
//                           validator: (value) => value == null ? 'Please select a doctor' : null,
//                         ),
//               const SizedBox(height: 16),

//               // Select Hospital Dropdown
//               if (_selectedDoctor != null && _hospitalAffiliations.isNotEmpty)
//                 DropdownButtonFormField<HospitalAffiliation>(
//                   decoration: InputDecoration(
//                     labelText: 'Select Hospital/Clinic',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   value: _selectedHospitalAffiliation,
//                   hint: const Text('Choose a hospital or clinic'),
//                   isExpanded: true,
//                   items: _hospitalAffiliations.map((HospitalAffiliation aff) {
//                     return DropdownMenuItem<HospitalAffiliation>(
//                         value: aff, child: Text(aff.hospitalName));
//                   }).toList(),
//                   onChanged: _onHospitalSelected,
//                   validator: (value) => value == null ? 'Please select a hospital/clinic' : null,
//                 ),
//               if (_selectedDoctor != null && _hospitalAffiliations.isEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text("This doctor has no listed hospital affiliations.", style: TextStyle(color: Colors.orange.shade700)),
//                 ),
//               const SizedBox(height: 16),

//               // Select Date
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Select Date',
//                   hintText: _selectedDoctor == null || _selectedHospitalAffiliation == null
//                       ? 'Select doctor & hospital first'
//                       : 'Tap to choose a date',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   suffixIcon: Icon(Icons.calendar_today,
//                       color: Theme.of(context).primaryColorDark),
//                 ),
//                 readOnly: true,
//                 controller: TextEditingController(
//                   text: _selectedDate == null
//                       ? ''
//                       : DateFormat.yMMMd().format(_selectedDate!), // e.g., Dec 15, 2023
//                 ),
//                 onTap: _selectedDoctor == null || _selectedHospitalAffiliation == null
//                     ? null : () => _selectDate(context),
//                 validator: (value) => _selectedDate == null ? 'Please select a date' : null,
//               ),
//               const SizedBox(height: 16),

//               // Select Time Slot Dropdown
//               if (_selectedDate != null && _selectedDoctor != null && _selectedHospitalAffiliation != null)
//                 DropdownButtonFormField<AvailableSlot>(
//                   decoration: InputDecoration(
//                     labelText: 'Select Time Slot',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     enabled: !_isLoadingTimeSlots && _availableTimeSlots.isNotEmpty,
//                   ),
//                   value: _selectedSlot,
//                   hint: _isLoadingTimeSlots
//                       ? const Text('Loading slots...')
//                       : _availableTimeSlots.isEmpty
//                           ? Text('No slots available for ${DateFormat.yMMMd().format(_selectedDate!)}')
//                           : const Text('Choose a time slot'),
//                   isExpanded: true,
//                   items: _availableTimeSlots.map((AvailableSlot slot) {
//                     return DropdownMenuItem<AvailableSlot>(
//                         value: slot, child: Text(slot.displayTime));
//                   }).toList(),
//                   onChanged: _isLoadingTimeSlots || _availableTimeSlots.isEmpty
//                       ? null
//                       : (AvailableSlot? newValue) => setState(() => _selectedSlot = newValue),
//                   validator: (value) => value == null ? 'Please select a time slot' : null,
//                 ),
//               if (_isLoadingTimeSlots && _selectedDate != null && _selectedDoctor != null && _selectedHospitalAffiliation != null)
//                 const Center(
//                     child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CircularProgressIndicator())),
//               const SizedBox(height: 20),

//               // Patient Details
//               TextFormField(
//                 controller: _patientNameController,
//                 decoration: InputDecoration(
//                     labelText: 'Your Full Name',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     prefixIcon: Icon(Icons.person_outline)),
//                 validator: (value) => (value == null || value.isEmpty) ? 'Please enter your name' : null,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _patientContactController,
//                 decoration: InputDecoration(
//                     labelText: 'Your Contact Number',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     prefixIcon: Icon(Icons.phone_outlined)),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter contact number';
//                   if (!RegExp(r'^[0-9\s+-]{7,}$').hasMatch(value)) return 'Please enter a valid phone number';
//                   return null;
//                 },
//                 textInputAction: TextInputAction.done,
//               ),
//               const SizedBox(height: 30),

//               // Book Appointment Button
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16.0),
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onPressed: _isBooking ? null : _bookAppointment,
//                 child: _isBooking
//                     ? const SizedBox(
//                         height: 24,
//                         width: 24,
//                         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0))
//                     : const Text('Book Appointment', style: TextStyle(fontSize: 16)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }































// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:medi_sync_plus_app/pages/login_page/role_login_page.dart'; // Assuming this is your login page

// // --- Data Models (Adjusted) ---
// class Specialty {
//   final String id; // e.g., "cardiology", "dentistry"
//   final String name; // e.g., "Cardiology", "Dentistry"
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
//   final String specialtyId; // e.g., "cardiology" - EXPECTED FROM FIRESTORE
//   final String specialtyName; // e.g., "Cardiology" - RESOLVED IN APP
//   final List<HospitalAffiliation> hospitalAffiliations;

//   Doctor({
//     required this.id,
//     required this.name,
//     required this.specialtyId,
//     required this.specialtyName,
//     required this.hospitalAffiliations,
//   });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Doctor && runtimeType == other.runtimeType && id == other.id;

//   @override
//   int get hashCode => id.hashCode;

//    @override
//   String toString() => 'Doctor(id: $id, name: $name, specialtyId: $specialtyId, specialtyName: $specialtyName, affiliations: ${hospitalAffiliations.length})';
// }

// class HospitalAffiliation {
//   final String hospitalId;
//   final String hospitalName;
//   // final String department; // Optional: Add if you need it from affiliatedHospitals maps

//   HospitalAffiliation({
//     required this.hospitalId,
//     required this.hospitalName,
//     // required this.department, // Optional
//   });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is HospitalAffiliation &&
//           runtimeType == other.runtimeType &&
//           hospitalId == other.hospitalId;

//   @override
//   int get hashCode => hospitalId.hashCode;

//   @override
//   String toString() => 'HospitalAffiliation(id: $hospitalId, name: $hospitalName)';
// }

// class AvailableSlot {
//   final String slotId;
//   final DateTime startTime;
//   final DateTime endTime;
//   final String displayTime;

//   AvailableSlot({
//     required this.slotId,
//     required this.startTime,
//     required this.endTime,
//     required this.displayTime,
//   });

//    @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is AvailableSlot &&
//           runtimeType == other.runtimeType &&
//           slotId == other.slotId;

//   @override
//   int get hashCode => slotId.hashCode;

//   @override
//   String toString() => 'AvailableSlot(id: $slotId, displayTime: $displayTime)';
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
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final TextEditingController _searchController = TextEditingController();
//   String _searchTerm = "";

//   Specialty? _selectedSpecialty;
//   Doctor? _selectedDoctor;
//   HospitalAffiliation? _selectedHospitalAffiliation;
//   DateTime? _selectedDate;
//   AvailableSlot? _selectedSlot;

//   final TextEditingController _patientNameController = TextEditingController();
//   final TextEditingController _patientContactController = TextEditingController();

//   List<Specialty> _allSpecialties = [];
//   List<Doctor> _allDoctors = [];
//   List<Doctor> _filteredDoctors = [];
//   List<HospitalAffiliation> _hospitalAffiliations = [];
//   List<AvailableSlot> _availableTimeSlots = [];

//   bool _isLoadingSpecialties = true;
//   bool _isLoadingDoctors = false;
//   bool _isLoadingTimeSlots = false;
//   bool _isBooking = false;

//   @override
//   void initState() {
//     super.initState();
//     print("AppointmentBookingPage: initState called");
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
//     print("AppointmentBookingPage: dispose called");
//     _searchController.dispose();
//     _patientNameController.dispose();
//     _patientContactController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchInitialData() async {
//     print("AppointmentBookingPage: _fetchInitialData started");
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) {
//       print("AppointmentBookingPage: User not authenticated. Redirecting to login.");
//       if (mounted) {
//         _showError("Please log in to continue.");
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const RoleLoginPage()),
//           (Route<dynamic> route) => false,
//         );
//       }
//       return;
//     }
//     print("AppointmentBookingPage: User ${currentUser.uid} is authenticated.");

//     try {
//         DocumentSnapshot userProfile = await _firestore.collection('users').doc(currentUser.uid).get();
//         if(userProfile.exists && userProfile.data() != null) {
//             var userData = userProfile.data() as Map<String, dynamic>;
//             print("AppointmentBookingPage: Fetched user profile data: $userData");
//             if(userData.containsKey('fullName') && userData['fullName'] != null) {
//                 _patientNameController.text = userData['fullName'];
//             }
//             if(userData.containsKey('phoneNumber') && userData['phoneNumber'] != null) {
//                 _patientContactController.text = userData['phoneNumber'];
//             }
//         } else {
//           print("AppointmentBookingPage: User profile not found or empty for UID: ${currentUser.uid}");
//         }
//     } catch (e) {
//         print("AppointmentBookingPage: Error fetching user profile: $e");
//     }

//     await _fetchSpecialties();
//     await _fetchAllDoctors();
//     print("AppointmentBookingPage: _fetchInitialData completed");
//   }

//   Future<void> _fetchSpecialties() async {
//     if (!mounted) return;
//     setState(() => _isLoadingSpecialties = true);
//     print("AppointmentBookingPage: _fetchSpecialties - Fetching from 'specialties' collection...");
//     try {
//       QuerySnapshot snapshot =
//           await _firestore.collection('specialties').orderBy('name').get();
//       if (!mounted) return;

//       if (snapshot.docs.isEmpty) {
//         print("AppointmentBookingPage: _fetchSpecialties - No specialties found in Firestore.");
//         if (mounted) _showError("No specialties available.");
//          setState(() => _allSpecialties = []);
//         return;
//       }

//       _allSpecialties = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         print("AppointmentBookingPage: _fetchSpecialties - Raw specialty data for doc ID ${doc.id}: $data");
//         return Specialty(id: doc.id, name: data['name'] as String? ?? "Unnamed Specialty");
//       }).toList();

//       print("AppointmentBookingPage: _fetchSpecialties - Fetched and Mapped specialties: ${_allSpecialties.map((s) => '${s.id}: ${s.name}').join(', ')}");
//     } catch (e, stackTrace) {
//       print("AppointmentBookingPage: _fetchSpecialties - Error fetching specialties: $e\n$stackTrace");
//       if (mounted) _showError("Could not load specialties.");
//     } finally {
//       if (mounted) {
//         setState(() => _isLoadingSpecialties = false);
//         // _filterDoctors(); // filterDoctors will be called after _fetchAllDoctors completes
//       }
//     }
//   }

//   Future<void> _fetchAllDoctors() async {
//     if (!mounted) return;
//     print("AppointmentBookingPage: _fetchAllDoctors - Fetching doctors...");
//     setState(() {
//       _isLoadingDoctors = true;
//       _allDoctors = [];
//       _filteredDoctors = [];
//     });
//     try {
//       // QuerySnapshot doctorSnapshot = await _firestore.collection('doctors').where('isEnabled', isEqualTo: true).get(); // ORIGINAL
//       QuerySnapshot doctorSnapshot = await _firestore.collection('doctors').get(); // TEMP: Fetch ALL doctors
//       print("AppointmentBookingPage: _fetchAllDoctors - TEMP TEST: Fetched ALL doctors (no 'isEnabled' filter). Count: ${doctorSnapshot.docs.length}");


//       if (!mounted) return;

//       _allDoctors = await Future.wait(doctorSnapshot.docs.map((doc) async {
//         var data = doc.data() as Map<String, dynamic>;
//         print("AppointmentBookingPage: _fetchAllDoctors - Raw doctor data for doc ID ${doc.id}: $data");

//         // --- Affiliated Hospitals Parsing ---
//         List<dynamic> affiliationsData = data['affiliatedHospitals'] ?? []; // Default to empty list if null
//         print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - raw affiliationsData: $affiliationsData (Type: ${affiliationsData.runtimeType})");
//         List<HospitalAffiliation> affiliations = [];
//         if (affiliationsData is List) {
//             affiliations = affiliationsData.map((aff) {
//               if (aff is Map<String, dynamic>) {
//                   print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - mapping affiliation map: $aff");
//                   return HospitalAffiliation(
//                       hospitalId: aff['hospitalId'] as String? ?? 'unknown_hosp_id_${doc.id}_${affiliations.length}',
//                       hospitalName: aff['hospitalName'] as String? ?? 'Unknown Hospital',
//                       // department: aff['department'] as String? ?? 'N/A Dept', // Optional
//                   );
//               }
//               print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - affiliation item is NOT a map: $aff. Type: ${aff.runtimeType}");
//               return HospitalAffiliation(hospitalId: 'error_hosp_id_${doc.id}_${affiliations.length}', hospitalName: 'Error Hospital Structure');
//             }).toList();
//         } else {
//              print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - affiliatedHospitals field is NOT a List. Actual type: ${affiliationsData.runtimeType}");
//         }


//         // --- Specialty Parsing ---
//         // IMPORTANT: Your Firestore 'doctors' documents NEED a 'specialtyId' field (string)
//         // that matches a document ID from your 'specialties' collection.
//         // The 'specializations' array is different.
//         String specialtyIdFromDoc = data['specialtyId'] as String? ?? ""; // EXPECTING THIS FIELD
//         print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Attempting to get 'specialtyId' from Firestore: '$specialtyIdFromDoc'");
//         if (specialtyIdFromDoc.isEmpty) {
//             print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//             print("APPOINTMENT_BOOKING_PAGE WARNING: Doctor ${doc.id} is MISSING 'specialtyId' field in Firestore.");
//             print("Please add a 'specialtyId' (string) field to this doctor document,");
//             print("with a value matching a document ID from your 'specialties' collection (e.g., 'cardiology').");
//             print("The existing 'specializations' array is NOT used for this primary specialty lookup.");
//             print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//         }

//         String resolvedSpecialtyName = "Unknown Specialty";
//         if (specialtyIdFromDoc.isNotEmpty) {
//           final foundSpecialty = _allSpecialties.firstWhere(
//             (s) => s.id == specialtyIdFromDoc,
//             orElse: () {
//               print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - specialtyId '$specialtyIdFromDoc' NOT FOUND in _allSpecialties. _allSpecialties has ${_allSpecialties.length} items: ${_allSpecialties.map((sp) => sp.id).join(', ')}");
//               return Specialty(id: specialtyIdFromDoc, name: "Loading...");
//             }
//           );
//           if (foundSpecialty.name != "Loading...") {
//             resolvedSpecialtyName = foundSpecialty.name;
//           } else {
//             print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - specialtyId '$specialtyIdFromDoc' - Attempting fallback direct fetch for specialty name because it was 'Loading...'.");
//             try {
//                 DocumentSnapshot specialtyDoc = await _firestore.collection('specialties').doc(specialtyIdFromDoc).get();
//                 if (specialtyDoc.exists) {
//                   resolvedSpecialtyName = (specialtyDoc.data() as Map<String, dynamic>)['name'] as String? ?? "Unnamed Specialty (Fallback)";
//                    print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Fallback fetch successful for '$specialtyIdFromDoc': $resolvedSpecialtyName");
//                 } else {
//                    print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Fallback fetch: specialty document '$specialtyIdFromDoc' does NOT exist.");
//                 }
//             } catch (e) {
//                 print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Error during fallback specialty fetch for '$specialtyIdFromDoc': $e");
//             }
//           }
//         }
//         print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Resolved specialtyName: '$resolvedSpecialtyName', Original specialtyId from doc: '$specialtyIdFromDoc'");

//         Doctor mappedDoctor = Doctor(
//           id: doc.id,
//           name: data['fullName'] as String? ?? 'N/A Doctor Name', // Ensure 'fullName' exists
//           specialtyId: specialtyIdFromDoc, // This will be empty if 'specialtyId' field is missing in Firestore
//           specialtyName: resolvedSpecialtyName,
//           hospitalAffiliations: affiliations,
//         );
//         print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Mapped Doctor object: $mappedDoctor");
//         return mappedDoctor;
//       }).toList());

//       print("AppointmentBookingPage: _fetchAllDoctors - Total doctors fetched and mapped: ${_allDoctors.length}");
//       _filterDoctors(); // Now call filterDoctors
//     } catch (e, s) {
//       print("AppointmentBookingPage: _fetchAllDoctors - Error fetching all doctors: $e\n$s");
//       if (mounted) _showError("Could not load doctor list.");
//     }
//     if (mounted) setState(() => _isLoadingDoctors = false);
//   }

//   void _filterDoctors() {
//     if (!mounted) return;

//     // TEMP: If using the "fetch ALL doctors" approach, manually filter by isEnabled here for now
//     // This is NOT efficient for large datasets but helps for testing the 'isEnabled' logic
//     List<Doctor> doctorsToConsider = _allDoctors;
//     // Comment out the next block if you fix the Firestore query for 'isEnabled'
//     //
//     // print("AppointmentBookingPage: _filterDoctors - Manually checking 'isEnabled' for ${doctorsToConsider.length} doctors (TEMP)");
//     // doctorsToConsider = _allDoctors.where((doctor) {
//     //    // This requires fetching the 'isEnabled' field during _fetchAllDoctors if you keep this manual filter
//     //    // For now, assuming all doctors fetched should be considered if the Firestore query is `.get()`
//     //    // If you add 'isEnabled' to your Doctor model and fetch it, you can filter here:
//     //    // return doctor.isEnabled == true;
//     //    return true; // Placeholder if not fetching 'isEnabled' into Doctor model
//     // }).toList();
//     // print("AppointmentBookingPage: _filterDoctors - Doctors considered after manual 'isEnabled' check (TEMP): ${doctorsToConsider.length}");


//     List<Doctor> tempFiltered;
//     if (_searchTerm.isEmpty && _selectedSpecialty == null) {
//       tempFiltered = List.from(doctorsToConsider);
//     } else {
//       tempFiltered = doctorsToConsider.where((doctor) {
//         bool matchesSearchTerm = _searchTerm.isEmpty ||
//             doctor.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
//             doctor.specialtyName.toLowerCase().contains(_searchTerm.toLowerCase());

//         bool matchesSpecialty = _selectedSpecialty == null ||
//             doctor.specialtyId == _selectedSpecialty!.id;

//         return matchesSearchTerm && matchesSpecialty;
//       }).toList();
//     }

//     print("AppointmentBookingPage: _filterDoctors - Search: '$_searchTerm', Selected Specialty ID: '${_selectedSpecialty?.id}'. Input doctors: ${doctorsToConsider.length}, Filtered count: ${tempFiltered.length}");
//     if (tempFiltered.isNotEmpty) {
//         print("AppointmentBookingPage: _filterDoctors - First filtered doctor: ${tempFiltered.first}");
//     } else if (doctorsToConsider.isNotEmpty) {
//         print("AppointmentBookingPage: _filterDoctors - No doctors match criteria. First available doctor for reference: ${doctorsToConsider.first}");
//     }


//     if (_selectedDoctor != null && !tempFiltered.any((d) => d.id == _selectedDoctor!.id)) {
//         print("AppointmentBookingPage: _filterDoctors - Current selected doctor ${_selectedDoctor!.id} no longer in filtered list. Clearing doctor selection.");
//         _clearDoctorAndBelowSelections();
//     }

//     setState(() {
//       _filteredDoctors = tempFiltered;
//     });
//   }

//   void _clearDoctorAndBelowSelections() {
//     if (!mounted) return;
//     print("AppointmentBookingPage: _clearDoctorAndBelowSelections called.");
//     setState(() {
//       _selectedDoctor = null;
//       _hospitalAffiliations = [];
//       _selectedHospitalAffiliation = null;
//       _clearDateAndBelowSelections();
//     });
//   }

//   void _clearDateAndBelowSelections() {
//     if (!mounted) return;
//      print("AppointmentBookingPage: _clearDateAndBelowSelections called.");
//     setState(() {
//       _selectedDate = null;
//       _availableTimeSlots = [];
//       _selectedSlot = null;
//     });
//   }

//   void _onSpecialtySelected(Specialty? specialty) {
//     if (!mounted) return;
//     print("AppointmentBookingPage: _onSpecialtySelected - ${specialty?.id ?? 'All'}");
//     setState(() {
//       _selectedSpecialty = specialty;
//       _searchController.clear();
//       _searchTerm = "";
//       _clearDoctorAndBelowSelections();
//       _filterDoctors();
//     });
//   }

//   void _onDoctorSelected(Doctor? doctor) {
//     if (!mounted) return;
//      print("AppointmentBookingPage: _onDoctorSelected - ${doctor?.id ?? 'None'}");
//     setState(() {
//       _selectedDoctor = doctor;
//       _hospitalAffiliations = doctor?.hospitalAffiliations ?? [];
//       _selectedHospitalAffiliation = _hospitalAffiliations.isNotEmpty ? _hospitalAffiliations.first : null;
//       print("AppointmentBookingPage: _onDoctorSelected - Selected hospital affiliation: ${_selectedHospitalAffiliation?.hospitalName}");
//       _clearDateAndBelowSelections();
//     });
//   }

//   void _onHospitalSelected(HospitalAffiliation? hospitalAffiliation) {
//     if (!mounted) return;
//     print("AppointmentBookingPage: _onHospitalSelected - ${hospitalAffiliation?.hospitalId ?? 'None'}");
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
//     print("AppointmentBookingPage: _selectDate - Opening date picker.");
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now().add(const Duration(days:1)),
//       firstDate: DateTime.now().add(const Duration(days:1)),
//       lastDate: DateTime.now().add(const Duration(days: 90)),
//     );

//     if (picked != null && picked != _selectedDate) {
//       if (!mounted) return;
//       print("AppointmentBookingPage: _selectDate - Date picked: $picked");
//       setState(() {
//         _selectedDate = picked;
//         _selectedSlot = null;
//         _fetchAvailableTimeSlots();
//       });
//     } else {
//       print("AppointmentBookingPage: _selectDate - Date picker cancelled or same date picked.");
//     }
//   }

//   Future<void> _fetchAvailableTimeSlots() async {

//     // At the beginning of _fetchAvailableTimeSlots
//     print("AppointmentBookingPage: _fetchAvailableTimeSlots - CHECKING hospitalId. Selected Hospital ID: '${_selectedHospitalAffiliation?.hospitalId}'");
//     if (_selectedDoctor == null ||
//         _selectedDate == null ||
//         _selectedHospitalAffiliation == null) {
//       if (mounted) setState(() => _availableTimeSlots = []);
//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - Prerequisites not met. Doctor: ${_selectedDoctor?.id}, Date: $_selectedDate, Hospital: ${_selectedHospitalAffiliation?.hospitalId}");
//       return;
//     }
//     if (!mounted) return;
//     print("AppointmentBookingPage: _fetchAvailableTimeSlots - Fetching for Dr: ${_selectedDoctor!.id}, Hosp: ${_selectedHospitalAffiliation!.hospitalId}, Date: $_selectedDate");
//     setState(() {
//       _isLoadingTimeSlots = true;
//       _availableTimeSlots = [];
//       _selectedSlot = null;
//     });

//     try {
//       DateTime startOfDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, 0, 0, 0);
//       DateTime endOfDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, 23, 59, 59);
//       Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
//       Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - Querying slots from ${startOfDay.toIso8601String()} to ${endOfDay.toIso8601String()} for hospitalId: ${_selectedHospitalAffiliation!.hospitalId}");

//       QuerySnapshot slotSnapshot = await _firestore
//           .collection('doctors')
//           .doc(_selectedDoctor!.id)
//           .collection('availabilitySlots')
//           .where('hospitalId', isEqualTo: _selectedHospitalAffiliation!.hospitalId)
//           .where('startTime', isGreaterThanOrEqualTo: startTimestamp)
//           .where('startTime', isLessThanOrEqualTo: endTimestamp)
//           .where('isBooked', isEqualTo: false)
//           .orderBy('startTime')
//           .get();

//       if (!mounted) return;

//       if (slotSnapshot.docs.isEmpty) {
//         print("AppointmentBookingPage: _fetchAvailableTimeSlots - No available slots found matching criteria.");
//       } else {
//         print("AppointmentBookingPage: _fetchAvailableTimeSlots - Found ${slotSnapshot.docs.length} raw slot documents.");
//       }

//       _availableTimeSlots = slotSnapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         print("AppointmentBookingPage: _fetchAvailableTimeSlots - Mapping slot doc ${doc.id}, data: $data");
//         Timestamp startTimeStamp = data['startTime'] as Timestamp;
//         Timestamp endTimeStamp = data['endTime'] as Timestamp;
//         DateTime sTime = startTimeStamp.toDate();
//         DateTime eTime = endTimeStamp.toDate();

//         return AvailableSlot(
//           slotId: doc.id,
//           startTime: sTime,
//           endTime: eTime,
//           displayTime: "${DateFormat.jm().format(sTime)} - ${DateFormat.jm().format(eTime)}",
//         );
//       }).toList();

//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - Mapped ${_availableTimeSlots.length} available slots: ${_availableTimeSlots.map((s)=>s.displayTime).join(', ')}");

//     } catch (e, s) {
//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - Error fetching time slots: $e\n$s");
//       if (mounted) _showError("Could not load time slots.");
//     } finally {
//       if (mounted) setState(() => _isLoadingTimeSlots = false);
//     }
//   }

//   Future<void> _bookAppointment() async {
//     if (!_formKey.currentState!.validate()) {
//        _showError("Please fill all required fields correctly.");
//        print("AppointmentBookingPage: _bookAppointment - Form validation failed.");
//        return;
//     }
//     _formKey.currentState!.save();
//      print("AppointmentBookingPage: _bookAppointment - Form validated and saved.");

//     if (_selectedDoctor == null ||
//         _selectedHospitalAffiliation == null ||
//         _selectedDate == null ||
//         _selectedSlot == null) {
//       _showError("Please make all required selections.");
//       print("AppointmentBookingPage: _bookAppointment - Missing selections: Dr: ${_selectedDoctor?.id}, Hosp: ${_selectedHospitalAffiliation?.hospitalId}, Date: $_selectedDate, Slot: ${_selectedSlot?.slotId}");
//       return;
//     }
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) {
//       _showError("You must be logged in.");
//       print("AppointmentBookingPage: _bookAppointment - Current user is null.");
//       return;
//     }

//     if (!mounted) return;
//     setState(() => _isBooking = true);
//     print("AppointmentBookingPage: _bookAppointment - Attempting to book for User: ${currentUser.uid}, Doctor: ${_selectedDoctor!.id}, Slot: ${_selectedSlot!.slotId}");


//     final appointmentRef = _firestore.collection('appointments').doc();
//     final slotRef = _firestore
//         .collection('doctors')
//         .doc(_selectedDoctor!.id)
//         .collection('availabilitySlots')
//         .doc(_selectedSlot!.slotId);

//     try {
//       await _firestore.runTransaction((transaction) async {
//         print("AppointmentBookingPage: _bookAppointment - Transaction started.");
//         DocumentSnapshot slotDoc = await transaction.get(slotRef);
//         if (!slotDoc.exists) {
//           print("AppointmentBookingPage: _bookAppointment - Transaction: Slot ${slotRef.path} does not exist.");
//           throw Exception("Selected time slot no longer exists.");
//         }
//         var slotData = slotDoc.data() as Map<String, dynamic>;
//          print("AppointmentBookingPage: _bookAppointment - Transaction: Slot data: $slotData");
//         if (slotData['isBooked'] == true) {
//           print("AppointmentBookingPage: _bookAppointment - Transaction: Slot ${slotRef.path} is already booked.");
//           throw Exception("This time slot was just booked. Please select another.");
//         }

//         Map<String, dynamic> appointmentData = {
//           'appointmentId': appointmentRef.id,
//           'specialtyId': _selectedDoctor!.specialtyId, // Will be empty if not in Firestore doc
//           'specialtyName': _selectedDoctor!.specialtyName,
//           'doctorId': _selectedDoctor!.id,
//           'doctorName': _selectedDoctor!.name,
//           'hospitalId': _selectedHospitalAffiliation!.hospitalId,
//           'hospitalName': _selectedHospitalAffiliation!.hospitalName,
//           'appointmentStartTime': Timestamp.fromDate(_selectedSlot!.startTime),
//           'appointmentEndTime': Timestamp.fromDate(_selectedSlot!.endTime),
//           'patientName': _patientNameController.text.trim(),
//           'patientContact': _patientContactController.text.trim(),
//           'patientUid': currentUser.uid,
//           'status': 'confirmed',
//           'bookedAt': FieldValue.serverTimestamp(),
//           'slotId': _selectedSlot!.slotId,
//         };
//         print("AppointmentBookingPage: _bookAppointment - Transaction: Setting appointment data: $appointmentData");
//         transaction.set(appointmentRef, appointmentData);

//         Map<String, dynamic> slotUpdateData = {
//           'isBooked': true,
//           'bookedByPatientId': currentUser.uid,
//           'appointmentId': appointmentRef.id,
//         };
//         print("AppointmentBookingPage: _bookAppointment - Transaction: Updating slot ${slotRef.path} with: $slotUpdateData");
//         transaction.update(slotRef, slotUpdateData);
//         print("AppointmentBookingPage: _bookAppointment - Transaction completed successfully.");
//       });

//       _showFeedback('Appointment Booked Successfully!', isError: false);
//       print("AppointmentBookingPage: _bookAppointment - Appointment booked successfully.");


//       if (!mounted) return;
//       setState(() {
//         _searchController.clear();
//         _searchTerm = "";
//         _selectedSpecialty = null;
//         _clearDoctorAndBelowSelections();
//         _formKey.currentState?.reset();
//         _filterDoctors();
//       });

//     } catch (e) {
//       print("AppointmentBookingPage: _bookAppointment - Error booking appointment: $e");
//       if (mounted) _showError("Failed to book: ${e.toString().replaceFirst("Exception: ", "")}");
//       if (mounted) _fetchAvailableTimeSlots();
//     } finally {
//       if (mounted) setState(() => _isBooking = false);
//     }
//   }

//   void _showFeedback(String message, {bool isError = false}) {
//     if (mounted && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: isError ? Colors.redAccent : Theme.of(context).primaryColor,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   void _showError(String message) {
//     _showFeedback(message, isError: true);
//   }

//   Future<void> _signOut() async {
//     print("AppointmentBookingPage: _signOut called");
//     try {
//       await _auth.signOut();
//       if (mounted) {
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const RoleLoginPage()),
//           (Route<dynamic> route) => false,
//         );
//       }
//     } catch (e) {
//       if (mounted) _showError('Error signing out: $e');
//       print("AppointmentBookingPage: _signOut error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("AppointmentBookingPage: build method called. isLoadingDoctors: $_isLoadingDoctors, Selected Doctor: ${_selectedDoctor?.name}, Filtered Doctors: ${_filteredDoctors.length}");
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
//                   hintText: 'e.g., Dr. Alice or Cardiology',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
//               const SizedBox(height: 16),

//               if (_searchTerm.isEmpty)
//                 DropdownButtonFormField<Specialty?>(
//                   decoration: InputDecoration(
//                       labelText: 'Filter by Specialty (Optional)',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
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
//               const SizedBox(height: 16),

//               Text("Select Doctor", style: Theme.of(context).textTheme.titleMedium),
//               const SizedBox(height: 8),
//               _isLoadingDoctors
//                   ? const Center(child: CircularProgressIndicator())
//                   : _filteredDoctors.isEmpty
//                       ? Center(
//                           child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 16.0),
//                           child: Text(
//                              _allDoctors.isEmpty && !_isLoadingSpecialties && !_isLoadingDoctors? "No doctors found." // Initial state before/during load
//                             : "No doctors found matching your criteria.", // After load, if filter yields none
//                           style: TextStyle(color: Colors.grey[600]),),
//                         ))
//                       : DropdownButtonFormField<Doctor>(
//                           decoration: InputDecoration(
//                             labelText: 'Select Doctor',
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                           ),
//                           value: _selectedDoctor,
//                           hint: const Text('Choose a doctor'),
//                           isExpanded: true,
//                           items: _filteredDoctors.map((Doctor doctor) {
//                             return DropdownMenuItem<Doctor>(
//                                 value: doctor,
//                                 child: Text("${doctor.name} (${doctor.specialtyName})"));
//                           }).toList(),
//                           onChanged: _onDoctorSelected,
//                           validator: (value) => value == null ? 'Please select a doctor' : null,
//                         ),
//               const SizedBox(height: 16),

//               if (_selectedDoctor != null && _hospitalAffiliations.isNotEmpty)
//                 DropdownButtonFormField<HospitalAffiliation>(
//                   decoration: InputDecoration(
//                     labelText: 'Select Hospital/Clinic',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   value: _selectedHospitalAffiliation,
//                   hint: const Text('Choose a hospital or clinic'),
//                   isExpanded: true,
//                   items: _hospitalAffiliations.map((HospitalAffiliation aff) {
//                     return DropdownMenuItem<HospitalAffiliation>(
//                         value: aff, child: Text(aff.hospitalName));
//                   }).toList(),
//                   onChanged: _onHospitalSelected,
//                   validator: (value) => value == null ? 'Please select a hospital/clinic' : null,
//                 ),
//               if (_selectedDoctor != null && _hospitalAffiliations.isEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text("This doctor has no listed hospital affiliations.", style: TextStyle(color: Colors.orange.shade700)),
//                 ),
//               const SizedBox(height: 16),

//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Select Date',
//                   hintText: _selectedDoctor == null || _selectedHospitalAffiliation == null
//                       ? 'Select doctor & hospital first'
//                       : 'Tap to choose a date',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   suffixIcon: Icon(Icons.calendar_today,
//                       color: Theme.of(context).primaryColorDark),
//                 ),
//                 readOnly: true,
//                 controller: TextEditingController(
//                   text: _selectedDate == null
//                       ? ''
//                       : DateFormat.yMMMd().format(_selectedDate!),
//                 ),
//                 onTap: _selectedDoctor == null || _selectedHospitalAffiliation == null
//                     ? null : () => _selectDate(context),
//                 validator: (value) => _selectedDate == null ? 'Please select a date' : null,
//               ),
//               const SizedBox(height: 16),

//               if (_selectedDate != null && _selectedDoctor != null && _selectedHospitalAffiliation != null)
//                 DropdownButtonFormField<AvailableSlot>(
//                   decoration: InputDecoration(
//                     labelText: 'Select Time Slot',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     enabled: !_isLoadingTimeSlots && _availableTimeSlots.isNotEmpty,
//                   ),
//                   value: _selectedSlot,
//                   hint: _isLoadingTimeSlots
//                       ? const Text('Loading slots...')
//                       : _availableTimeSlots.isEmpty
//                           ? Text('No slots available for ${DateFormat.yMMMd().format(_selectedDate!)}')
//                           : const Text('Choose a time slot'),
//                   isExpanded: true,
//                   items: _availableTimeSlots.map((AvailableSlot slot) {
//                     return DropdownMenuItem<AvailableSlot>(
//                         value: slot, child: Text(slot.displayTime));
//                   }).toList(),
//                   onChanged: _isLoadingTimeSlots || _availableTimeSlots.isEmpty
//                       ? null
//                       : (AvailableSlot? newValue) => setState(() => _selectedSlot = newValue),
//                   validator: (value) => value == null ? 'Please select a time slot' : null,
//                 ),
//               if (_isLoadingTimeSlots && _selectedDate != null && _selectedDoctor != null && _selectedHospitalAffiliation != null)
//                 const Center(
//                     child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CircularProgressIndicator())),
//               const SizedBox(height: 20),

//               TextFormField(
//                 controller: _patientNameController,
//                 decoration: InputDecoration(
//                     labelText: 'Your Full Name',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     prefixIcon: const Icon(Icons.person_outline)),
//                 validator: (value) => (value == null || value.isEmpty) ? 'Please enter your name' : null,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _patientContactController,
//                 decoration: InputDecoration(
//                     labelText: 'Your Contact Number',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     prefixIcon: const Icon(Icons.phone_outlined)),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter contact number';
//                   if (!RegExp(r'^[0-9\s+-]{7,}$').hasMatch(value)) return 'Please enter a valid phone number';
//                   return null;
//                 },
//                 textInputAction: TextInputAction.done,
//               ),
//               const SizedBox(height: 30),

//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16.0),
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onPressed: _isBooking ? null : _bookAppointment,
//                 child: _isBooking
//                     ? const SizedBox(
//                         height: 24,
//                         width: 24,
//                         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0))
//                     : const Text('Book Appointment', style: TextStyle(fontSize: 16)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




























// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:medi_sync_plus_app/pages/login_page/role_login_page.dart'; // Assuming this is your login page

// // --- Data Models (Keep as they are) ---
// class Specialty {
//   final String id;
//   final String name;
//   Specialty({required this.id, required this.name});
//   @override bool operator ==(Object other) => identical(this, other) || other is Specialty && runtimeType == other.runtimeType && id == other.id;
//   @override int get hashCode => id.hashCode;
//   @override String toString() => 'Specialty(id: $id, name: $name)';
// }

// class Doctor {
//   final String id;
//   final String name;
//   final String specialtyId;
//   final String specialtyName;
//   final List<HospitalAffiliation> hospitalAffiliations;
//   Doctor({ required this.id, required this.name, required this.specialtyId, required this.specialtyName, required this.hospitalAffiliations });
//   @override bool operator ==(Object other) => identical(this, other) || other is Doctor && runtimeType == other.runtimeType && id == other.id;
//   @override int get hashCode => id.hashCode;
//   @override String toString() => 'Doctor(id: $id, name: $name, specialtyId: $specialtyId, specialtyName: $specialtyName, affiliations: ${hospitalAffiliations.length})';
// }

// class HospitalAffiliation {
//   final String hospitalId;
//   final String hospitalName;
//   HospitalAffiliation({required this.hospitalId, required this.hospitalName});
//   @override bool operator ==(Object other) => identical(this, other) || other is HospitalAffiliation && runtimeType == other.runtimeType && hospitalId == other.hospitalId;
//   @override int get hashCode => hospitalId.hashCode;
//   @override String toString() => 'HospitalAffiliation(id: $hospitalId, name: $hospitalName)';
// }

// class AvailableSlot {
//   final String slotId;
//   final DateTime startTime;
//   final DateTime endTime;
//   final String displayTime;
//   AvailableSlot({ required this.slotId, required this.startTime, required this.endTime, required this.displayTime });
//   @override bool operator ==(Object other) => identical(this, other) || other is AvailableSlot && runtimeType == other.runtimeType && slotId == other.slotId;
//   @override int get hashCode => slotId.hashCode;
//   @override String toString() => 'AvailableSlot(id: $slotId, displayTime: $displayTime)';
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
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final TextEditingController _searchController = TextEditingController();
//   String _searchTerm = "";

//   Specialty? _selectedSpecialty;
//   Doctor? _selectedDoctor;
//   HospitalAffiliation? _selectedHospitalAffiliation;
//   DateTime? _selectedDate;
//   AvailableSlot? _selectedSlot;

//   final TextEditingController _patientNameController = TextEditingController();
//   final TextEditingController _patientContactController = TextEditingController();

//   List<Specialty> _allSpecialties = [];
//   List<Doctor> _allDoctors = [];
//   List<Doctor> _filteredDoctors = [];
//   List<HospitalAffiliation> _hospitalAffiliations = [];
//   List<AvailableSlot> _availableTimeSlots = [];

//   bool _isLoadingSpecialties = true;
//   bool _isLoadingDoctors = false;
//   bool _isLoadingTimeSlots = false;
//   bool _isBooking = false;

//   @override
//   void initState() {
//     super.initState();
//     print("AppointmentBookingPage: initState called");
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
//     print("AppointmentBookingPage: dispose called");
//     _searchController.dispose();
//     _patientNameController.dispose();
//     _patientContactController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchInitialData() async {
//     print("AppointmentBookingPage: _fetchInitialData started");
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) {
//       print("AppointmentBookingPage: User not authenticated. Redirecting to login.");
//       if (mounted) {
//         _showError("Please log in to continue.");
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const RoleLoginPage()),
//           (Route<dynamic> route) => false,
//         );
//       }
//       return;
//     }
//     print("AppointmentBookingPage: User ${currentUser.uid} is authenticated.");

//     try {
//         DocumentSnapshot userProfile = await _firestore.collection('users').doc(currentUser.uid).get();
//         if(userProfile.exists && userProfile.data() != null) {
//             var userData = userProfile.data() as Map<String, dynamic>;
//             print("AppointmentBookingPage: Fetched user profile data: $userData");
//             if(userData.containsKey('fullName') && userData['fullName'] != null) {
//                 _patientNameController.text = userData['fullName'];
//             }
//             if(userData.containsKey('phoneNumber') && userData['phoneNumber'] != null) {
//                 _patientContactController.text = userData['phoneNumber'];
//             }
//         } else {
//           print("AppointmentBookingPage: User profile not found or empty for UID: ${currentUser.uid}");
//         }
//     } catch (e) {
//         print("AppointmentBookingPage: Error fetching user profile: $e");
//     }

//     await _fetchSpecialties();
//     await _fetchAllDoctors();
//     print("AppointmentBookingPage: _fetchInitialData completed");
//   }

//   Future<void> _fetchSpecialties() async {
//     // ... (keep this method as it was in the previous "full updated code")
//     if (!mounted) return;
//     setState(() => _isLoadingSpecialties = true);
//     print("AppointmentBookingPage: _fetchSpecialties - Fetching from 'specialties' collection...");
//     try {
//       QuerySnapshot snapshot =
//           await _firestore.collection('specialties').orderBy('name').get();
//       if (!mounted) return;

//       if (snapshot.docs.isEmpty) {
//         print("AppointmentBookingPage: _fetchSpecialties - No specialties found in Firestore.");
//         if (mounted) _showError("No specialties available.");
//          setState(() => _allSpecialties = []);
//         return;
//       }

//       _allSpecialties = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         print("AppointmentBookingPage: _fetchSpecialties - Raw specialty data for doc ID ${doc.id}: $data");
//         return Specialty(id: doc.id, name: data['name'] as String? ?? "Unnamed Specialty");
//       }).toList();

//       print("AppointmentBookingPage: _fetchSpecialties - Fetched and Mapped specialties: ${_allSpecialties.map((s) => '${s.id}: ${s.name}').join(', ')}");
//     } catch (e, stackTrace) {
//       print("AppointmentBookingPage: _fetchSpecialties - Error fetching specialties: $e\n$stackTrace");
//       if (mounted) _showError("Could not load specialties.");
//     } finally {
//       if (mounted) {
//         setState(() => _isLoadingSpecialties = false);
//       }
//     }
//   }

//   Future<void> _fetchAllDoctors() async {
//     // ... (keep this method as it was in the previous "full updated code" - the one that fetches ALL doctors temporarily)
//     if (!mounted) return;
//     print("AppointmentBookingPage: _fetchAllDoctors - Fetching doctors...");
//     setState(() {
//       _isLoadingDoctors = true;
//       _allDoctors = [];
//       _filteredDoctors = [];
//     });
//     try {
//       QuerySnapshot doctorSnapshot = await _firestore.collection('doctors').get(); // TEMP: Fetch ALL doctors
//       print("AppointmentBookingPage: _fetchAllDoctors - TEMP TEST: Fetched ALL doctors (no 'isEnabled' filter). Count: ${doctorSnapshot.docs.length}");

//       if (!mounted) return;

//       _allDoctors = await Future.wait(doctorSnapshot.docs.map((doc) async {
//         var data = doc.data() as Map<String, dynamic>;
//         print("AppointmentBookingPage: _fetchAllDoctors - Raw doctor data for doc ID ${doc.id}: $data");

//         List<dynamic> affiliationsData = data['affiliatedHospitals'] ?? [];
//         print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - raw affiliationsData: $affiliationsData (Type: ${affiliationsData.runtimeType})");
//         List<HospitalAffiliation> affiliations = [];
//         if (affiliationsData is List) {
//             affiliations = affiliationsData.map((aff) {
//               if (aff is Map<String, dynamic>) {
//                   print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - mapping affiliation map: $aff");
//                   return HospitalAffiliation(
//                       hospitalId: aff['hospitalId'] as String? ?? 'unknown_hosp_id_${doc.id}_${affiliations.length}',
//                       hospitalName: aff['hospitalName'] as String? ?? 'Unknown Hospital',
//                   );
//               }
//               print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - affiliation item is NOT a map: $aff. Type: ${aff.runtimeType}");
//               return HospitalAffiliation(hospitalId: 'error_hosp_id_${doc.id}_${affiliations.length}', hospitalName: 'Error Hospital Structure');
//             }).toList();
//         } else {
//              print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - affiliatedHospitals field is NOT a List. Actual type: ${affiliationsData.runtimeType}");
//         }

//         String specialtyIdFromDoc = data['specialtyId'] as String? ?? "";
//         print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Attempting to get 'specialtyId' from Firestore: '$specialtyIdFromDoc'");
//         if (specialtyIdFromDoc.isEmpty) {
//             print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//             print("APPOINTMENT_BOOKING_PAGE WARNING: Doctor ${doc.id} is MISSING 'specialtyId' field in Firestore.");
//             print("Please add a 'specialtyId' (string) field to this doctor document,");
//             print("with a value matching a document ID from your 'specialties' collection (e.g., 'cardiology').");
//             print("The existing 'specializations' array is NOT used for this primary specialty lookup.");
//             print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//         }

//         String resolvedSpecialtyName = "Unknown Specialty";
//         if (specialtyIdFromDoc.isNotEmpty) {
//           final foundSpecialty = _allSpecialties.firstWhere(
//             (s) => s.id == specialtyIdFromDoc,
//             orElse: () {
//               print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - specialtyId '$specialtyIdFromDoc' NOT FOUND in _allSpecialties. _allSpecialties has ${_allSpecialties.length} items: ${_allSpecialties.map((sp) => sp.id).join(', ')}");
//               return Specialty(id: specialtyIdFromDoc, name: "Loading...");
//             }
//           );
//           if (foundSpecialty.name != "Loading...") {
//             resolvedSpecialtyName = foundSpecialty.name;
//           } else {
//             print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - specialtyId '$specialtyIdFromDoc' - Attempting fallback direct fetch for specialty name because it was 'Loading...'.");
//             try {
//                 DocumentSnapshot specialtyDoc = await _firestore.collection('specialties').doc(specialtyIdFromDoc).get();
//                 if (specialtyDoc.exists) {
//                   resolvedSpecialtyName = (specialtyDoc.data() as Map<String, dynamic>)['name'] as String? ?? "Unnamed Specialty (Fallback)";
//                    print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Fallback fetch successful for '$specialtyIdFromDoc': $resolvedSpecialtyName");
//                 } else {
//                    print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Fallback fetch: specialty document '$specialtyIdFromDoc' does NOT exist.");
//                 }
//             } catch (e) {
//                 print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Error during fallback specialty fetch for '$specialtyIdFromDoc': $e");
//             }
//           }
//         }
//         print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Resolved specialtyName: '$resolvedSpecialtyName', Original specialtyId from doc: '$specialtyIdFromDoc'");

//         Doctor mappedDoctor = Doctor(
//           id: doc.id,
//           name: data['fullName'] as String? ?? 'N/A Doctor Name',
//           specialtyId: specialtyIdFromDoc,
//           specialtyName: resolvedSpecialtyName,
//           hospitalAffiliations: affiliations,
//         );
//         print("AppointmentBookingPage: _fetchAllDoctors - Doctor ${doc.id} - Mapped Doctor object: $mappedDoctor");
//         return mappedDoctor;
//       }).toList());

//       print("AppointmentBookingPage: _fetchAllDoctors - Total doctors fetched and mapped: ${_allDoctors.length}");
//       _filterDoctors();
//     } catch (e, s) {
//       print("AppointmentBookingPage: _fetchAllDoctors - Error fetching all doctors: $e\n$s");
//       if (mounted) _showError("Could not load doctor list.");
//     }
//     if (mounted) setState(() => _isLoadingDoctors = false);
//   }

//   void _filterDoctors() {
//     // ... (keep this method as it was in the previous "full updated code")
//      if (!mounted) return;
//     List<Doctor> doctorsToConsider = _allDoctors;

//     List<Doctor> tempFiltered;
//     if (_searchTerm.isEmpty && _selectedSpecialty == null) {
//       tempFiltered = List.from(doctorsToConsider);
//     } else {
//       tempFiltered = doctorsToConsider.where((doctor) {
//         bool matchesSearchTerm = _searchTerm.isEmpty ||
//             doctor.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
//             doctor.specialtyName.toLowerCase().contains(_searchTerm.toLowerCase());
//         bool matchesSpecialty = _selectedSpecialty == null ||
//             doctor.specialtyId == _selectedSpecialty!.id;
//         return matchesSearchTerm && matchesSpecialty;
//       }).toList();
//     }
//     print("AppointmentBookingPage: _filterDoctors - Search: '$_searchTerm', Selected Specialty ID: '${_selectedSpecialty?.id}'. Input doctors: ${doctorsToConsider.length}, Filtered count: ${tempFiltered.length}");
//     if (tempFiltered.isNotEmpty) {
//         print("AppointmentBookingPage: _filterDoctors - First filtered doctor: ${tempFiltered.first}");
//     } else if (doctorsToConsider.isNotEmpty) {
//         print("AppointmentBookingPage: _filterDoctors - No doctors match criteria. First available doctor for reference: ${doctorsToConsider.first}");
//     }

//     if (_selectedDoctor != null && !tempFiltered.any((d) => d.id == _selectedDoctor!.id)) {
//         print("AppointmentBookingPage: _filterDoctors - Current selected doctor ${_selectedDoctor!.id} no longer in filtered list. Clearing doctor selection.");
//         _clearDoctorAndBelowSelections();
//     }
//     setState(() {
//       _filteredDoctors = tempFiltered;
//     });
//   }

//   void _clearDoctorAndBelowSelections() {
//     // ... (keep this method as it was)
//     if (!mounted) return;
//     print("AppointmentBookingPage: _clearDoctorAndBelowSelections called.");
//     setState(() {
//       _selectedDoctor = null;
//       _hospitalAffiliations = [];
//       _selectedHospitalAffiliation = null;
//       _clearDateAndBelowSelections();
//     });
//   }

//   void _clearDateAndBelowSelections() {
//     // ... (keep this method as it was)
//      if (!mounted) return;
//      print("AppointmentBookingPage: _clearDateAndBelowSelections called.");
//     setState(() {
//       _selectedDate = null;
//       _availableTimeSlots = [];
//       _selectedSlot = null;
//     });
//   }

//   void _onSpecialtySelected(Specialty? specialty) {
//     // ... (keep this method as it was)
//     if (!mounted) return;
//     print("AppointmentBookingPage: _onSpecialtySelected - ${specialty?.id ?? 'All'}");
//     setState(() {
//       _selectedSpecialty = specialty;
//       _searchController.clear();
//       _searchTerm = "";
//       _clearDoctorAndBelowSelections();
//       _filterDoctors();
//     });
//   }

//   void _onDoctorSelected(Doctor? doctor) {
//     // ... (keep this method as it was)
//     if (!mounted) return;
//      print("AppointmentBookingPage: _onDoctorSelected - ${doctor?.id ?? 'None'}");
//     setState(() {
//       _selectedDoctor = doctor;
//       _hospitalAffiliations = doctor?.hospitalAffiliations ?? [];
//       _selectedHospitalAffiliation = _hospitalAffiliations.isNotEmpty ? _hospitalAffiliations.first : null;
//       print("AppointmentBookingPage: _onDoctorSelected - Selected hospital affiliation: ${_selectedHospitalAffiliation?.hospitalName}");
//       _clearDateAndBelowSelections();
//     });
//   }

//   void _onHospitalSelected(HospitalAffiliation? hospitalAffiliation) {
//     // ... (keep this method as it was)
//     if (!mounted) return;
//     print("AppointmentBookingPage: _onHospitalSelected - ${hospitalAffiliation?.hospitalId ?? 'None'}");
//     setState(() {
//       _selectedHospitalAffiliation = hospitalAffiliation;
//       _clearDateAndBelowSelections();
//     });
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     // ... (keep this method as it was)
//     if (_selectedDoctor == null || _selectedHospitalAffiliation == null) {
//       _showError("Please select a doctor and hospital first.");
//       return;
//     }
//     print("AppointmentBookingPage: _selectDate - Opening date picker.");
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now().add(const Duration(days:1)),
//       firstDate: DateTime.now().add(const Duration(days:1)),
//       lastDate: DateTime.now().add(const Duration(days: 90)),
//     );

//     if (picked != null && picked != _selectedDate) {
//       if (!mounted) return;
//       print("AppointmentBookingPage: _selectDate - Date picked: $picked");
//       setState(() {
//         _selectedDate = picked;
//         _selectedSlot = null;
//         _fetchAvailableTimeSlots();
//       });
//     } else {
//       print("AppointmentBookingPage: _selectDate - Date picker cancelled or same date picked.");
//     }
//   }

//   // =======================================================================
//   // MODIFIED _fetchAvailableTimeSlots with extensive logging and test queries
//   // =======================================================================
//   Future<void> _fetchAvailableTimeSlots() async {
//     print("AppointmentBookingPage: _fetchAvailableTimeSlots - Function CALLED.");
//     print("AppointmentBookingPage: _fetchAvailableTimeSlots - Current Selected Doctor ID: ${_selectedDoctor?.id}");
//     print("AppointmentBookingPage: _fetchAvailableTimeSlots - Current Selected Hospital ID: ${_selectedHospitalAffiliation?.hospitalId}");
//     print("AppointmentBookingPage: _fetchAvailableTimeSlots - Current Selected Date: $_selectedDate");


//     if (_selectedDoctor == null ||
//         _selectedDate == null ||
//         _selectedHospitalAffiliation == null) {
//       if (mounted) setState(() => _availableTimeSlots = []);
//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - ABORTING: Prerequisites not met (Doctor, Hospital, or Date is null).");
//       return;
//     }
//     if (!mounted) return;

//     final String doctorId = _selectedDoctor!.id;
//     final String hospitalIdQuery = _selectedHospitalAffiliation!.hospitalId;
//     final DateTime dateQuery = _selectedDate!;

//     print("AppointmentBookingPage: _fetchAvailableTimeSlots - PREPARING to fetch for Dr: $doctorId, Hosp: $hospitalIdQuery, Date: $dateQuery");

//     setState(() {
//       _isLoadingTimeSlots = true;
//       _availableTimeSlots = [];
//       _selectedSlot = null;
//     });

//     try {
//       DateTime startOfDay = DateTime(dateQuery.year, dateQuery.month, dateQuery.day, 0, 0, 0, 0, 0); // Explicitly set milliseconds and microseconds to 0
//       DateTime endOfDay = DateTime(dateQuery.year, dateQuery.month, dateQuery.day, 23, 59, 59, 999, 999); // End of the day

//       Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
//       Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - Calculated local startOfDay: $startOfDay (ISO: ${startOfDay.toIso8601String()})");
//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - Calculated local endOfDay: $endOfDay (ISO: ${endOfDay.toIso8601String()})");
//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - Converted startTimestamp (UTC fromDate): ${startTimestamp.toDate()}");
//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - Converted endTimestamp (UTC fromDate): ${endTimestamp.toDate()}");
//       print("------------------------------------------------------------------------------------");
//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - USING MAIN QUERY");
//       print("------------------------------------------------------------------------------------");


//       // --- MAIN QUERY ---
//       QuerySnapshot slotSnapshot = await _firestore
//           .collection('doctors')
//           .doc(doctorId)
//           .collection('availabilitySlots')
//           .where('hospitalId', isEqualTo: hospitalIdQuery)
//           .where('startTime', isGreaterThanOrEqualTo: startTimestamp)
//           .where('startTime', isLessThanOrEqualTo: endTimestamp)
//           .where('isBooked', isEqualTo: false)
//           .orderBy('startTime')
//           .get();


//       // --- TEST QUERIES (Uncomment ONE AT A TIME to debug) ---

//       // // --- TEST A: Any slots for doctor & hospital (IGNORE DATE & BOOKED STATUS) ---
//       // print("------------------------------------------------------------------------------------");
//       // print("AppointmentBookingPage: _fetchAvailableTimeSlots - EXECUTING TEST A QUERY");
//       // print("------------------------------------------------------------------------------------");
//       // QuerySnapshot slotSnapshot = await _firestore
//       //     .collection('doctors')
//       //     .doc(doctorId)
//       //     .collection('availabilitySlots')
//       //     .where('hospitalId', isEqualTo: hospitalIdQuery)
//       //     .orderBy('startTime')
//       //     .limit(10) // Limit results for testing
//       //     .get();


//       // // --- TEST B: Unbooked slots for doctor & hospital (IGNORE DATE) ---
//       // print("------------------------------------------------------------------------------------");
//       // print("AppointmentBookingPage: _fetchAvailableTimeSlots - EXECUTING TEST B QUERY");
//       // print("------------------------------------------------------------------------------------");
//       // QuerySnapshot slotSnapshot = await _firestore
//       //     .collection('doctors')
//       //     .doc(doctorId)
//       //     .collection('availabilitySlots')
//       //     .where('hospitalId', isEqualTo: hospitalIdQuery)
//       //     .where('isBooked', isEqualTo: false)
//       //     .orderBy('startTime')
//       //     .limit(10)
//       //     .get();


//       // // --- TEST C: Slots by date for doctor & hospital (IGNORE BOOKED STATUS) ---
//       // print("------------------------------------------------------------------------------------");
//       // print("AppointmentBookingPage: _fetchAvailableTimeSlots - EXECUTING TEST C QUERY");
//       // print("------------------------------------------------------------------------------------");
//       // QuerySnapshot slotSnapshot = await _firestore
//       //     .collection('doctors')
//       //     .doc(doctorId)
//       //     .collection('availabilitySlots')
//       //     .where('hospitalId', isEqualTo: hospitalIdQuery)
//       //     .where('startTime', isGreaterThanOrEqualTo: startTimestamp)
//       //     .where('startTime', isLessThanOrEqualTo: endTimestamp)
//       //     .orderBy('startTime')
//       //     .limit(10)
//       //     .get();

//       // --- End Test Queries ---

//       if (!mounted) return;

//       if (slotSnapshot.docs.isEmpty) {
//         print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//         print("AppointmentBookingPage: _fetchAvailableTimeSlots - QUERY RESULT: NO SLOTS FOUND matching the current query criteria.");
//         print("    Doctor ID: $doctorId");
//         print("    Hospital ID for Query: $hospitalIdQuery");
//         print("    Date for Query: $dateQuery");
//         print("    Query Start Timestamp (UTC): ${startTimestamp.toDate()}");
//         print("    Query End Timestamp (UTC): ${endTimestamp.toDate()}");
//         print("    (If using main query, also filtered for isBooked: false)");
//         print("    COMMON CHECKS:");
//         print("    1. Verify 'hospitalId' in slot documents EXACTLY matches '$hospitalIdQuery'.");
//         print("    2. Verify 'startTime' (Timestamp type) in slot documents falls BETWEEN the Query Start/End Timestamps (consider UTC).");
//         print("    3. Verify 'isBooked' is 'false' (boolean) in slot documents (for main query).");
//         print("    4. Check Firestore Security Rules for 'doctors/$doctorId/availabilitySlots'.");
//         print("    5. Check for Firestore Indexing errors in Firebase Console or Flutter logs for this query.");
//         print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

//       } else {
//         print("AppointmentBookingPage: _fetchAvailableTimeSlots - QUERY RESULT: Found ${slotSnapshot.docs.length} raw slot documents.");
//       }

//       _availableTimeSlots = slotSnapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         print("AppointmentBookingPage: _fetchAvailableTimeSlots - Mapping slot doc ${doc.id}, Raw Data: $data");

//         Timestamp? firestoreStartTime = data['startTime'] as Timestamp?;
//         Timestamp? firestoreEndTime = data['endTime'] as Timestamp?;
//         bool isSlotBooked = data['isBooked'] as bool? ?? true; // Default to booked if missing, to be safe
//         String slotHospitalId = data['hospitalId'] as String? ?? 'NO_HOSPITAL_ID_IN_SLOT';

//         if (firestoreStartTime == null || firestoreEndTime == null) {
//           print("      >> WARNING: Slot ${doc.id} is missing startTime or endTime. Skipping.");
//           return null; // Will be filtered out by .whereType
//         }
//         DateTime sTime = firestoreStartTime.toDate();
//         DateTime eTime = firestoreEndTime.toDate();

//         print("      >> Slot ${doc.id}: Start (UTC): $sTime, End (UTC): $eTime, isBooked: $isSlotBooked, Slot's HospitalId: '$slotHospitalId'");

//         return AvailableSlot(
//           slotId: doc.id,
//           startTime: sTime,
//           endTime: eTime,
//           displayTime: "${DateFormat.jm().format(sTime.toLocal())} - ${DateFormat.jm().format(eTime.toLocal())}", // Display in local time
//         );
//       }).whereType<AvailableSlot>().toList(); // Filter out any nulls from parsing errors

//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - Mapped ${_availableTimeSlots.length} VALID available slots: ${_availableTimeSlots.map((s)=>s.displayTime).join(', ')}");

//     } catch (e, s) {
//       print("AppointmentBookingPage: _fetchAvailableTimeSlots - Error during fetch/map: $e\n$s");
//       if (mounted) _showError("Could not load time slots. Error: $e");
//     } finally {
//       if (mounted) setState(() => _isLoadingTimeSlots = false);
//     }
//   }
//   // =======================================================================
//   // End MODIFIED _fetchAvailableTimeSlots
//   // =======================================================================


//   Future<void> _bookAppointment() async {
//     // ... (keep this method as it was in the previous "full updated code")
//     if (!_formKey.currentState!.validate()) {
//        _showError("Please fill all required fields correctly.");
//        print("AppointmentBookingPage: _bookAppointment - Form validation failed.");
//        return;
//     }
//     _formKey.currentState!.save();
//      print("AppointmentBookingPage: _bookAppointment - Form validated and saved.");

//     if (_selectedDoctor == null ||
//         _selectedHospitalAffiliation == null ||
//         _selectedDate == null ||
//         _selectedSlot == null) {
//       _showError("Please make all required selections.");
//       print("AppointmentBookingPage: _bookAppointment - Missing selections: Dr: ${_selectedDoctor?.id}, Hosp: ${_selectedHospitalAffiliation?.hospitalId}, Date: $_selectedDate, Slot: ${_selectedSlot?.slotId}");
//       return;
//     }
//     User? currentUser = _auth.currentUser;
//     if (currentUser == null) {
//       _showError("You must be logged in.");
//       print("AppointmentBookingPage: _bookAppointment - Current user is null.");
//       return;
//     }

//     if (!mounted) return;
//     setState(() => _isBooking = true);
//     print("AppointmentBookingPage: _bookAppointment - Attempting to book for User: ${currentUser.uid}, Doctor: ${_selectedDoctor!.id}, Slot: ${_selectedSlot!.slotId}");


//     final appointmentRef = _firestore.collection('appointments').doc();
//     final slotRef = _firestore
//         .collection('doctors')
//         .doc(_selectedDoctor!.id)
//         .collection('availabilitySlots')
//         .doc(_selectedSlot!.slotId);

//     try {
//       await _firestore.runTransaction((transaction) async {
//         print("AppointmentBookingPage: _bookAppointment - Transaction started.");
//         DocumentSnapshot slotDoc = await transaction.get(slotRef);
//         if (!slotDoc.exists) {
//           print("AppointmentBookingPage: _bookAppointment - Transaction: Slot ${slotRef.path} does not exist.");
//           throw Exception("Selected time slot no longer exists.");
//         }
//         var slotData = slotDoc.data() as Map<String, dynamic>;
//          print("AppointmentBookingPage: _bookAppointment - Transaction: Slot data: $slotData");
//         if (slotData['isBooked'] == true) {
//           print("AppointmentBookingPage: _bookAppointment - Transaction: Slot ${slotRef.path} is already booked.");
//           throw Exception("This time slot was just booked. Please select another.");
//         }

//         Map<String, dynamic> appointmentData = {
//           'appointmentId': appointmentRef.id,
//           'specialtyId': _selectedDoctor!.specialtyId,
//           'specialtyName': _selectedDoctor!.specialtyName,
//           'doctorId': _selectedDoctor!.id,
//           'doctorName': _selectedDoctor!.name,
//           'hospitalId': _selectedHospitalAffiliation!.hospitalId,
//           'hospitalName': _selectedHospitalAffiliation!.hospitalName,
//           'appointmentStartTime': Timestamp.fromDate(_selectedSlot!.startTime),
//           'appointmentEndTime': Timestamp.fromDate(_selectedSlot!.endTime),
//           'patientName': _patientNameController.text.trim(),
//           'patientContact': _patientContactController.text.trim(),
//           'patientUid': currentUser.uid,
//           'status': 'confirmed',
//           'bookedAt': FieldValue.serverTimestamp(),
//           'slotId': _selectedSlot!.slotId,
//         };
//         print("AppointmentBookingPage: _bookAppointment - Transaction: Setting appointment data: $appointmentData");
//         transaction.set(appointmentRef, appointmentData);

//         Map<String, dynamic> slotUpdateData = {
//           'isBooked': true,
//           'bookedByPatientId': currentUser.uid,
//           'appointmentId': appointmentRef.id,
//         };
//         print("AppointmentBookingPage: _bookAppointment - Transaction: Updating slot ${slotRef.path} with: $slotUpdateData");
//         transaction.update(slotRef, slotUpdateData);
//         print("AppointmentBookingPage: _bookAppointment - Transaction completed successfully.");
//       });

//       _showFeedback('Appointment Booked Successfully!', isError: false);
//       print("AppointmentBookingPage: _bookAppointment - Appointment booked successfully.");


//       if (!mounted) return;
//       setState(() {
//         _searchController.clear();
//         _searchTerm = "";
//         _selectedSpecialty = null;
//         _clearDoctorAndBelowSelections();
//         _formKey.currentState?.reset();
//         _filterDoctors();
//       });

//     } catch (e) {
//       print("AppointmentBookingPage: _bookAppointment - Error booking appointment: $e");
//       if (mounted) _showError("Failed to book: ${e.toString().replaceFirst("Exception: ", "")}");
//       if (mounted) _fetchAvailableTimeSlots();
//     } finally {
//       if (mounted) setState(() => _isBooking = false);
//     }
//   }

//   void _showFeedback(String message, {bool isError = false}) {
//     // ... (keep this method as it was)
//     if (mounted && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: isError ? Colors.redAccent : Theme.of(context).primaryColor,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   void _showError(String message) {
//     // ... (keep this method as it was)
//     _showFeedback(message, isError: true);
//   }

//   Future<void> _signOut() async {
//     // ... (keep this method as it was)
//     print("AppointmentBookingPage: _signOut called");
//     try {
//       await _auth.signOut();
//       if (mounted) {
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const RoleLoginPage()),
//           (Route<dynamic> route) => false,
//         );
//       }
//     } catch (e) {
//       if (mounted) _showError('Error signing out: $e');
//       print("AppointmentBookingPage: _signOut error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ... (keep this method mostly as it was, check the hint text for slots)
//     print("AppointmentBookingPage: build method called. isLoadingTimeSlots: $_isLoadingTimeSlots, Selected Date: $_selectedDate, Available Slots Count: ${_availableTimeSlots.length}");
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
//               // ... (Search, Specialty, Doctor, Hospital, Date fields remain the same as previous full code)
//               TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   labelText: 'Search Doctor or Specialty',
//                   hintText: 'e.g., Dr. Alice or Cardiology',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
//               const SizedBox(height: 16),

//               if (_searchTerm.isEmpty)
//                 DropdownButtonFormField<Specialty?>(
//                   decoration: InputDecoration(
//                       labelText: 'Filter by Specialty (Optional)',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
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
//               const SizedBox(height: 16),

//               Text("Select Doctor", style: Theme.of(context).textTheme.titleMedium),
//               const SizedBox(height: 8),
//               _isLoadingDoctors
//                   ? const Center(child: CircularProgressIndicator())
//                   : _filteredDoctors.isEmpty
//                       ? Center(
//                           child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 16.0),
//                           child: Text(
//                              _allDoctors.isEmpty && !_isLoadingSpecialties && !_isLoadingDoctors? "No doctors found."
//                             : "No doctors found matching your criteria.",
//                           style: TextStyle(color: Colors.grey[600]),),
//                         ))
//                       : DropdownButtonFormField<Doctor>(
//                           decoration: InputDecoration(
//                             labelText: 'Select Doctor',
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                           ),
//                           value: _selectedDoctor,
//                           hint: const Text('Choose a doctor'),
//                           isExpanded: true,
//                           items: _filteredDoctors.map((Doctor doctor) {
//                             return DropdownMenuItem<Doctor>(
//                                 value: doctor,
//                                 child: Text("${doctor.name} (${doctor.specialtyName})"));
//                           }).toList(),
//                           onChanged: _onDoctorSelected,
//                           validator: (value) => value == null ? 'Please select a doctor' : null,
//                         ),
//               const SizedBox(height: 16),

//               if (_selectedDoctor != null && _hospitalAffiliations.isNotEmpty)
//                 DropdownButtonFormField<HospitalAffiliation>(
//                   decoration: InputDecoration(
//                     labelText: 'Select Hospital/Clinic',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   value: _selectedHospitalAffiliation,
//                   hint: const Text('Choose a hospital or clinic'),
//                   isExpanded: true,
//                   items: _hospitalAffiliations.map((HospitalAffiliation aff) {
//                     return DropdownMenuItem<HospitalAffiliation>(
//                         value: aff, child: Text(aff.hospitalName));
//                   }).toList(),
//                   onChanged: _onHospitalSelected,
//                   validator: (value) => value == null ? 'Please select a hospital/clinic' : null,
//                 ),
//               if (_selectedDoctor != null && _hospitalAffiliations.isEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text("This doctor has no listed hospital affiliations.", style: TextStyle(color: Colors.orange.shade700)),
//                 ),
//               const SizedBox(height: 16),

//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Select Date',
//                   hintText: _selectedDoctor == null || _selectedHospitalAffiliation == null
//                       ? 'Select doctor & hospital first'
//                       : 'Tap to choose a date',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   suffixIcon: Icon(Icons.calendar_today,
//                       color: Theme.of(context).primaryColorDark),
//                 ),
//                 readOnly: true,
//                 controller: TextEditingController(
//                   text: _selectedDate == null
//                       ? ''
//                       : DateFormat.yMMMd().format(_selectedDate!),
//                 ),
//                 onTap: _selectedDoctor == null || _selectedHospitalAffiliation == null
//                     ? null : () => _selectDate(context),
//                 validator: (value) => _selectedDate == null ? 'Please select a date' : null,
//               ),
//               const SizedBox(height: 16),
//               // --- Time Slot Dropdown ---
//               if (_selectedDate != null && _selectedDoctor != null && _selectedHospitalAffiliation != null)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     DropdownButtonFormField<AvailableSlot>(
//                       decoration: InputDecoration(
//                         labelText: 'Select Time Slot',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                         enabled: !_isLoadingTimeSlots && _availableTimeSlots.isNotEmpty,
//                       ),
//                       value: _selectedSlot,
//                       hint: _isLoadingTimeSlots
//                           ? const Text('Loading slots...')
//                           : _availableTimeSlots.isEmpty
//                               ? Text('No slots available for ${DateFormat.yMMMd().format(_selectedDate!)}')
//                               : const Text('Choose a time slot'),
//                       isExpanded: true,
//                       items: _availableTimeSlots.map((AvailableSlot slot) {
//                         return DropdownMenuItem<AvailableSlot>(
//                             value: slot, child: Text(slot.displayTime));
//                       }).toList(),
//                       onChanged: _isLoadingTimeSlots || _availableTimeSlots.isEmpty
//                           ? null
//                           : (AvailableSlot? newValue) {
//                               print("AppointmentBookingPage: Time slot selected by user: ${newValue?.displayTime}");
//                               setState(() => _selectedSlot = newValue);
//                             },
//                       validator: (value) => value == null ? 'Please select a time slot' : null,
//                     ),
//                     if (_isLoadingTimeSlots)
//                        const Center(
//                           child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: CircularProgressIndicator())),
//                     if (!_isLoadingTimeSlots && _availableTimeSlots.isEmpty && _selectedDate != null) // Explicitly check selectedDate
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Center(child: Text("No slots found for the selected criteria.", style: TextStyle(color: Colors.grey[700]))),
//                       ),
//                   ],
//                 ),
//               const SizedBox(height: 20),
//               // ... (Patient Name, Contact, Book Button fields remain the same)
//                TextFormField(
//                 controller: _patientNameController,
//                 decoration: InputDecoration(
//                     labelText: 'Your Full Name',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     prefixIcon: const Icon(Icons.person_outline)),
//                 validator: (value) => (value == null || value.isEmpty) ? 'Please enter your name' : null,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _patientContactController,
//                 decoration: InputDecoration(
//                     labelText: 'Your Contact Number',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     prefixIcon: const Icon(Icons.phone_outlined)),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Please enter contact number';
//                   if (!RegExp(r'^[0-9\s+-]{7,}$').hasMatch(value)) return 'Please enter a valid phone number';
//                   return null;
//                 },
//                 textInputAction: TextInputAction.done,
//               ),
//               const SizedBox(height: 30),

//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16.0),
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onPressed: _isBooking ? null : _bookAppointment,
//                 child: _isBooking
//                     ? const SizedBox(
//                         height: 24,
//                         width: 24,
//                         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0))
//                     : const Text('Book Appointment', style: TextStyle(fontSize: 16)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }














// lib/pages/patient/appointment_booking_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev; // For logging

// Assuming RoleLoginPage is correctly pathed for redirection
import 'package:medi_sync_plus_app/pages/login_page/role_login_page.dart';

// --- Data Models ---
import 'package:medi_sync_plus_app/models/appointment_model.dart';

// Data Models (kept in file as per your structure, except BookedUserAppointment)
class Specialty {
  final String id;
  final String name;
  Specialty({required this.id, required this.name});
  @override bool operator ==(Object other) => identical(this, other) || other is Specialty && runtimeType == other.runtimeType && id == other.id;
  @override int get hashCode => id.hashCode;
  @override String toString() => 'Specialty(id: $id, name: $name)';
}

class Doctor {
  final String id;
  final String name;
  final String specialtyId;
  final String specialtyName;
  final List<HospitalAffiliation> hospitalAffiliations;
  Doctor({ required this.id, required this.name, required this.specialtyId, required this.specialtyName, required this.hospitalAffiliations });
  @override bool operator ==(Object other) => identical(this, other) || other is Doctor && runtimeType == other.runtimeType && id == other.id;
  @override int get hashCode => id.hashCode;
  @override String toString() => 'Doctor(id: $id, name: $name, specialtyId: $specialtyId, specialtyName: $specialtyName, affiliations: ${hospitalAffiliations.length})';
}

class HospitalAffiliation {
  final String hospitalId;
  final String hospitalName;
  HospitalAffiliation({required this.hospitalId, required this.hospitalName});
  @override bool operator ==(Object other) => identical(this, other) || other is HospitalAffiliation && runtimeType == other.runtimeType && hospitalId == other.hospitalId;
  @override int get hashCode => hospitalId.hashCode;
  @override String toString() => 'HospitalAffiliation(id: $hospitalId, name: $hospitalName)';
}

class AvailableSlot {
  final String slotId;
  final DateTime startTime;
  final DateTime endTime;
  final String displayTime;
  AvailableSlot({ required this.slotId, required this.startTime, required this.endTime, required this.displayTime });
  @override bool operator ==(Object other) => identical(this, other) || other is AvailableSlot && runtimeType == other.runtimeType && slotId == other.slotId;
  @override int get hashCode => slotId.hashCode;
  @override String toString() => 'AvailableSlot(id: $slotId, displayTime: $displayTime)';
}
// --- End Data Models ---

class AppointmentBookingPage extends StatefulWidget {
  const AppointmentBookingPage({super.key});

  @override
  State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _clearDoctorAndBelowSelections() {
    if (!mounted) return;
    setState(() {
      _selectedDoctor = null;
      _selectedHospitalAffiliation = null;
      _hospitalAffiliations = [];
      _selectedDate = null;
      _selectedSlot = null;
      _availableTimeSlots = [];
    });
  }

  late TabController _tabController;

  // --- State for Booking Form ---
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  Specialty? _selectedSpecialty;
  Doctor? _selectedDoctor;
  HospitalAffiliation? _selectedHospitalAffiliation;
  DateTime? _selectedDate;
  AvailableSlot? _selectedSlot;
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientContactController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController(); // Added for reasonForVisit
  List<Specialty> _allSpecialties = [];
  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  List<HospitalAffiliation> _hospitalAffiliations = [];
  List<AvailableSlot> _availableTimeSlots = [];
  bool _isLoadingSpecialties = true;
  bool _isLoadingDoctors = false;
  bool _isLoadingTimeSlots = false;
  bool _isBooking = false;
  // --- End State for Booking Form ---

  // --- State for My Bookings Tab ---
  Stream<List<BookedUserAppointment>>? _myBookingsStream;
  String _myBookingsFilterStatus = 'upcoming';
  // --- End State for My Bookings Tab ---

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    dev.log("AppointmentBookingPage: initState called");
    _fetchInitialDataForBookingForm();
    _loadMyBookings();
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
    _tabController.dispose();
    _searchController.dispose();
    _patientNameController.dispose();
    _patientContactController.dispose();
    _reasonController.dispose();
    dev.log("AppointmentBookingPage: dispose called");
    super.dispose();
  }

  // --- Methods for Booking Form ---
  Future<void> _fetchInitialDataForBookingForm() async {
    dev.log("AppointmentBookingPage (Booking Tab): _fetchInitialDataForBookingForm started");
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      dev.log("AppointmentBookingPage: User not authenticated. Redirecting to login.");
      if (mounted) {
        _showError("Please log in to continue.");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const RoleLoginPage()),
          (Route<dynamic> route) => false,
        );
      }
      return;
    }
    dev.log("AppointmentBookingPage (Booking Tab): User ${currentUser.uid} is authenticated.");
    try {
      DocumentSnapshot userProfile = await _firestore.collection('users').doc(currentUser.uid).get();
      if (userProfile.exists && userProfile.data() != null && mounted) {
        var userData = userProfile.data() as Map<String, dynamic>;
        setState(() {
          _patientNameController.text = userData['fullName'] ?? currentUser.displayName ?? '';
          _patientContactController.text = userData['phoneNumber'] ?? userData['mobile'] ?? '';
        });
      } else {
        if (mounted) {
          setState(() {
            _patientNameController.text = currentUser.displayName ?? '';
            _patientContactController.text = currentUser.phoneNumber ?? '';
          });
        }
      }
    } catch (e) {
      dev.log("AppointmentBookingPage (Booking Tab): Error fetching user profile: $e");
    }
    await _fetchSpecialties();
    await _fetchAllDoctors();
    dev.log("AppointmentBookingPage (Booking Tab): _fetchInitialDataForBookingForm completed");
  }

  Future<void> _fetchSpecialties() async {
    if (!mounted) return;
    setState(() => _isLoadingSpecialties = true);
    try {
      QuerySnapshot snapshot = await _firestore.collection('specialties').orderBy('name').get();
      if (!mounted) return;
      if (snapshot.docs.isEmpty) {
        if (mounted) {
          _showError("No specialties available.");
          setState(() => _allSpecialties = []);
        }
        return;
      }
      _allSpecialties = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Specialty(id: doc.id, name: data['name'] as String? ?? "Unnamed");
      }).toList();
    } catch (e, stackTrace) {
      dev.log("AppointmentBookingPage (Booking Tab): _fetchSpecialties - Error: $e\n$stackTrace");
      if (mounted) _showError("Could not load specialties.");
    } finally {
      if (mounted) setState(() => _isLoadingSpecialties = false);
    }
  }

  // Future<void> _fetchAllDoctors() async {
  //   if (!mounted) return;
  //   setState(() {
  //     _isLoadingDoctors = true;
  //     _allDoctors = [];
  //     _filteredDoctors = [];
  //   });
  //   try {
  //     QuerySnapshot doctorSnapshot = await _firestore.collection('doctors').where('isEnabled', isEqualTo: true).get();
  //     if (!mounted) return;
  //     _allDoctors = await Future.wait(doctorSnapshot.docs.map((doc) async {
  //       var data = doc.data() as Map<String, dynamic>;
  //       List<dynamic> affiliationsData = data['affiliatedHospitals'] ?? [];
  //       List<HospitalAffiliation> affiliations = affiliationsData
  //           .whereType<Map<String, dynamic>>()
  //           .map((aff) => HospitalAffiliation(
  //               hospitalId: aff['hospitalId'] as String? ?? '',
  //               hospitalName: aff['hospitalName'] as String? ?? 'N/A'))
  //           .toList();
  //       String specialtyIdFromDoc = (data['specialtyId'] as String? ?? "").trim();
  //       String resolvedSpecialtyName = "Unknown Specialty";
  //       if (specialtyIdFromDoc.isNotEmpty) {
  //         final foundInMemory = _allSpecialties.any((s) => s.id == specialtyIdFromDoc)
  //             ? _allSpecialties.firstWhere((s) => s.id == specialtyIdFromDoc)
  //             : null;
  //         if (foundInMemory != null) {
  //           resolvedSpecialtyName = foundInMemory.name;
  //         } else {
  //           try {
  //             DocumentSnapshot specialtyDoc = await _firestore.collection('specialties').doc(specialtyIdFromDoc).get();
  //             if (specialtyDoc.exists) {
  //               resolvedSpecialtyName = (specialtyDoc.data() as Map<String, dynamic>)['name'] as String? ?? "Unnamed";
  //             }
  //           } catch (e) {
  //             dev.log("Error fallback specialty fetch for $specialtyIdFromDoc: $e");
  //           }
  //         }
  //       }
  //       return Doctor(
  //         id: doc.id,
  //         name: data['fullName'] as String? ?? 'N/A Doctor',
  //         specialtyId: specialtyIdFromDoc,
  //         specialtyName: resolvedSpecialtyName,
  //         hospitalAffiliations: affiliations,
  //       );
  //     }).toList());
  //     _filterDoctors();
  //   } catch (e, s) {
  //     dev.log("AppointmentBookingPage (Booking Tab): _fetchAllDoctors - Error: $e\n$s");
  //     if (mounted) _showError("Could not load doctor list.");
  //   }
  //   if (mounted) setState(() => _isLoadingDoctors = false);
  // }

  // void _filterDoctors() {
  //   if (!mounted) return;
  //   List<Doctor> tempFiltered;
  //   if (_searchTerm.isEmpty && _selectedSpecialty == null) {
  //     tempFiltered = List.from(_allDoctors);
  //   } else {
  //     tempFiltered = _allDoctors.where((doctor) {
  //       bool matchesSearchTerm = _searchTerm.isEmpty ||
  //           doctor.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
  //           doctor.specialtyName.toLowerCase().contains(_searchTerm.toLowerCase());
  //       bool matchesSpecialty = _selectedSpecialty == null || doctor.specialtyId == _selectedSpecialty!.id;
  //       return matchesSearchTerm && matchesSpecialty;
  //     }).toList();
  //   }
  //   if (_selectedDoctor != null && !tempFiltered.any((d) => d.id == _selectedDoctor!.id)) {
  //     _clearDoctorAndBelowSelections();
  //   }
  //   setState(() => _filteredDoctors = tempFiltered);
  // }

  // void _clearDoctorAndBelowSelections() {
  //   if (!mounted) return;
  //   setState(() {
  //     _selectedDoctor = null;
  //     _selectedHospitalAffiliation = null;
  //     _hospitalAffiliations = [];
  //     _selectedDate = null;
  //     _selectedSlot = null;
  //     _availableTimeSlots = [];
  //   });
  // }

  // void _clearDateAndBelowSelections() {
  //   if (!mounted) return;
  //   setState(() {
  //     _selectedDate = null;
  //     _selectedSlot = null;
  //     _availableTimeSlots = [];
  //   });
  // }

  void _onSpecialtySelected(Specialty? specialty) {
    if (!mounted) return;
    setState(() {
      _selectedSpecialty = specialty;
      _selectedDoctor = null;
      _selectedHospitalAffiliation = null;
      _hospitalAffiliations = [];
      _selectedDate = null;
      _selectedSlot = null;
      _availableTimeSlots = [];
      _filterDoctors();
    });
  }

  void _onDoctorSelected(Doctor? doctor) {
    if (!mounted) return;
    setState(() {
      _selectedDoctor = doctor;
      _selectedHospitalAffiliation = null;
      _selectedDate = null;
      _selectedSlot = null;
      _availableTimeSlots = [];
      _hospitalAffiliations = doctor != null ? doctor.hospitalAffiliations : [];
    });
  }

  void _onHospitalSelected(HospitalAffiliation? hospitalAffiliation) {
    if (!mounted) return;
    setState(() {
      _selectedHospitalAffiliation = hospitalAffiliation;
      _selectedDate = null;
      _selectedSlot = null;
      _availableTimeSlots = [];
    });
  }




  Future<void> _fetchAllDoctors() async {
    if (!mounted) return;
    setState(() {
      _isLoadingDoctors = true;
      _allDoctors = [];
      _filteredDoctors = [];
    });
    try {
      dev.log("AppointmentBookingPage (Booking Tab): Fetching doctors with isEnabled: true");
      QuerySnapshot doctorSnapshot = await _firestore.collection('doctors').where('isEnabled', isEqualTo: true).get();
      if (!mounted) return;
      dev.log("AppointmentBookingPage (Booking Tab): Fetched ${doctorSnapshot.docs.length} doctors");
      _allDoctors = await Future.wait(doctorSnapshot.docs.map((doc) async {
        var data = doc.data() as Map<String, dynamic>;
        dev.log("Processing doctor doc: ${doc.id}, data: $data");
        List<dynamic> affiliationsData = data['affiliatedHospitals'] ?? [];
        List<HospitalAffiliation> affiliations = affiliationsData
            .whereType<Map<String, dynamic>>()
            .map((aff) => HospitalAffiliation(
                hospitalId: aff['hospitalId'] as String? ?? '',
                hospitalName: aff['hospitalName'] as String? ?? 'N/A'))
            .toList();
        String specialtyIdFromDoc = (data['specialtyId'] as String? ?? "").trim();
        String resolvedSpecialtyName = "Unknown Specialty";
        if (specialtyIdFromDoc.isNotEmpty) {
          final foundInMemory = _allSpecialties.any((s) => s.id == specialtyIdFromDoc)
              ? _allSpecialties.firstWhere((s) => s.id == specialtyIdFromDoc)
              : null;
          if (foundInMemory != null) {
            resolvedSpecialtyName = foundInMemory.name;
          } else {
            try {
              DocumentSnapshot specialtyDoc = await _firestore.collection('specialties').doc(specialtyIdFromDoc).get();
              if (specialtyDoc.exists) {
                resolvedSpecialtyName = (specialtyDoc.data() as Map<String, dynamic>)['name'] as String? ?? "Unnamed";
              }
            } catch (e) {
              dev.log("Error fallback specialty fetch for $specialtyIdFromDoc: $e");
            }
          }
        }
        return Doctor(
          id: doc.id,
          name: data['fullName'] as String? ?? 'N/A Doctor',
          specialtyId: specialtyIdFromDoc,
          specialtyName: resolvedSpecialtyName,
          hospitalAffiliations: affiliations,
        );
      }).toList());
      dev.log("AppointmentBookingPage (Booking Tab): Loaded ${_allDoctors.length} doctors");
      _filterDoctors();
    } catch (e, s) {
      dev.log("AppointmentBookingPage (Booking Tab): _fetchAllDoctors - Error: $e\n$s");
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
        bool matchesSpecialty = _selectedSpecialty == null || doctor.specialtyId == _selectedSpecialty!.id;
        return matchesSearchTerm && matchesSpecialty;
      }).toList();
    }
    dev.log("AppointmentBookingPage (Booking Tab): Filtered ${tempFiltered.length} doctors, search: $_searchTerm, specialty: ${_selectedSpecialty?.name}");
    if (_selectedDoctor != null && !tempFiltered.any((d) => d.id == _selectedDoctor!.id)) {
      _clearDoctorAndBelowSelections();
    }
    setState(() => _filteredDoctors = tempFiltered);
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!mounted) return;
    DateTime today = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 90)), // Limit to 3 months ahead
    );
    if (pickedDate != null && mounted) {
      setState(() {
        _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
        _selectedSlot = null;
        _availableTimeSlots = [];
      });
      await _fetchAvailableTimeSlots();
    }
  }

  Future<void> _fetchAvailableTimeSlots() async {
    if (!mounted || _selectedDoctor == null || _selectedHospitalAffiliation == null || _selectedDate == null) return;
    setState(() {
      _isLoadingTimeSlots = true;
      _availableTimeSlots = [];
      _selectedSlot = null;
    });
    try {
      dev.log("Fetching time slots for doctor: ${_selectedDoctor!.id}, hospital: ${_selectedHospitalAffiliation!.hospitalId}, date: $_selectedDate");
      DateTime startOfDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));
      Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
      Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

      QuerySnapshot slotSnapshot = await _firestore
          .collection('doctors')
          .doc(_selectedDoctor!.id)
          .collection('availabilitySlots')
          .where('hospitalId', isEqualTo: _selectedHospitalAffiliation!.hospitalId)
          .where('startTime', isGreaterThanOrEqualTo: startTimestamp)
          .where('startTime', isLessThan: endTimestamp)
          .where('isBooked', isEqualTo: false)
          .orderBy('startTime')
          .get();

      if (!mounted) return;
      List<AvailableSlot> fetchedSlots = slotSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        Timestamp startTime = data['startTime'] as Timestamp? ?? Timestamp.now();
        Timestamp endTime = data['endTime'] as Timestamp? ?? Timestamp.now();
        String displayTime = "${DateFormat.jm().format(startTime.toDate())} - ${DateFormat.jm().format(endTime.toDate())}";
        return AvailableSlot(
          slotId: doc.id,
          startTime: startTime.toDate(),
          endTime: endTime.toDate(),
          displayTime: displayTime,
        );
      }).toList();

      if (fetchedSlots.isEmpty) {
        if (mounted) _showError("No available time slots for selected date.");
      }
      if (mounted) {
        setState(() => _availableTimeSlots = fetchedSlots);
      }
    } catch (e, s) {
      dev.log("Error fetching time slots: $e\n$s");
      if (mounted) _showError("Could not load time slots.");
    } finally {
      if (mounted) setState(() => _isLoadingTimeSlots = false);
    }
  }

  Future<void> _bookAppointment() async {
    if (!_formKey.currentState!.validate()) {
      _showError("Please fill all required fields.");
      return;
    }
    if (_selectedSpecialty == null ||
        _selectedDoctor == null ||
        _selectedHospitalAffiliation == null ||
        _selectedDate == null ||
        _selectedSlot == null) {
      _showError("Please complete all selections.");
      return;
    }
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      _showError("Please log in to book an appointment.");
      return;
    }
    if (!mounted) return;
    setState(() => _isBooking = true);
    dev.log("Booking appointment for user: ${currentUser.uid}, doctor: ${_selectedDoctor!.id}, slot: ${_selectedSlot!.slotId}");

    final appointmentRef = _firestore.collection('appointments').doc();
    final slotRef = _firestore.collection('doctors').doc(_selectedDoctor!.id).collection('availabilitySlots').doc(_selectedSlot!.slotId);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot slotDoc = await transaction.get(slotRef);
        if (!slotDoc.exists) throw Exception("Selected time slot no longer exists.");
        var slotData = slotDoc.data() as Map<String, dynamic>;
        if (slotData['isBooked'] == true) throw Exception("This time slot is already booked.");

        transaction.set(appointmentRef, {
          'doctorId': _selectedDoctor!.id,
          'doctorName': _selectedDoctor!.name,
          'specialtyId': _selectedSpecialty!.id,
          'specialtyName': _selectedSpecialty!.name,
          'hospitalId': _selectedHospitalAffiliation!.hospitalId,
          'hospitalName': _selectedHospitalAffiliation!.hospitalName,
          'patientUid': currentUser.uid,
          'patientName': _patientNameController.text.trim(),
          'appointmentStartTime': Timestamp.fromDate(_selectedSlot!.startTime),
          'appointmentEndTime': Timestamp.fromDate(_selectedSlot!.endTime),
          'bookedAt': Timestamp.now(),
          'reasonForVisit': _reasonController.text.trim().isNotEmpty ? _reasonController.text.trim() : null,
          'status': 'confirmed',
          'slotId': _selectedSlot!.slotId,
        });

        transaction.update(slotRef, {
          'isBooked': true,
          'bookedByPatientId': currentUser.uid,
          'appointmentId': appointmentRef.id,
        });
      });

      if (mounted) {
        _showFeedback('Appointment Booked Successfully!', isError: false);
        _tabController.animateTo(1);
        setState(() {
          _selectedSpecialty = null;
          _selectedDoctor = null;
          _selectedHospitalAffiliation = null;
          _selectedDate = null;
          _selectedSlot = null;
          _availableTimeSlots = [];
          _searchController.clear();
          _searchTerm = "";
          _reasonController.clear();
          _filterDoctors();
        });
        _loadMyBookings();
      }
    } catch (e, s) {
      dev.log("Error booking appointment: $e\n$s");
      if (mounted) _showError("Failed to book appointment: ${e.toString().replaceAll("Exception: ", "")}");
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  void _showFeedback(String message, {bool isError = false}) {
    if (!mounted || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: isError ? Theme.of(context).colorScheme.error : Colors.green),
    );
  }

  void _showError(String message) {
    _showFeedback(message, isError: true);
  }
  // --- End Methods for Booking Form ---

  // --- Methods for "My Bookings" Tab ---
  // void _loadMyBookings() {
  //   User? currentUser = _auth.currentUser;
  //   if (currentUser == null) {
  //     if (mounted) setState(() => _myBookingsStream = Stream.value([]));
  //     return;
  //   }
  //   dev.log("MyBookingsTab: Loading appointments for ${currentUser.uid}, filter: $_myBookingsFilterStatus");
  //   Query query = _firestore.collection('appointments').where('patientUid', isEqualTo: currentUser.uid);
  //   DateTime now = DateTime.now();
  //   Timestamp nowTimestamp = Timestamp.fromDate(now);

  //   if (_myBookingsFilterStatus == 'upcoming') {
  //     query = query.where('appointmentStartTime', isGreaterThanOrEqualTo: nowTimestamp).orderBy('appointmentStartTime', descending: false);
  //   } else if (_myBookingsFilterStatus == 'past') {
  //     query = query.where('appointmentStartTime', isLessThan: nowTimestamp).orderBy('appointmentStartTime', descending: true);
  //   } else {
  //     query = query.orderBy('appointmentStartTime', descending: true);
  //   }
  //   if (mounted) {
  //     setState(() {
  //       _myBookingsStream = query.snapshots().map((snapshot) {
  //         return snapshot.docs.map((doc) => BookedUserAppointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
  //       }).handleError((error) {
  //         dev.log("MyBookingsTab: Error fetching appointments: $error");
  //         if (mounted) _showError("Error loading your appointments.");
  //         return <BookedUserAppointment>[];
  //       });
  //     });
  //   }
  // }






  void _loadMyBookings() {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      if (mounted) setState(() => _myBookingsStream = Stream.value([]));
      return;
    }
    dev.log("MyBookingsTab: Loading appointments for ${currentUser.uid}, filter: $_myBookingsFilterStatus");
    Query query = _firestore.collection('appointments').where('patientUid', isEqualTo: currentUser.uid);
    DateTime now = DateTime.now();
    Timestamp nowTimestamp = Timestamp.fromDate(now);

    if (_myBookingsFilterStatus == 'upcoming') {
      query = query.where('appointmentStartTime', isGreaterThanOrEqualTo: nowTimestamp).orderBy('appointmentStartTime', descending: false);
    } else if (_myBookingsFilterStatus == 'past') {
      query = query.where('appointmentStartTime', isLessThan: nowTimestamp).orderBy('appointmentStartTime', descending: true);
    } else {
      query = query.orderBy('appointmentStartTime', descending: true);
    }
    if (mounted) {
      setState(() {
        _myBookingsStream = query.snapshots().map((snapshot) {
          return snapshot.docs.map((doc) => BookedUserAppointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
        }).handleError((error) {
          dev.log("MyBookingsTab: Error fetching appointments: $error");
          if (mounted) _showError("Error loading your appointments.");
          return <BookedUserAppointment>[];
        });
      });
    }
  }

  void _setMyBookingsFilter(String filter) {
    if (_myBookingsFilterStatus == filter || !mounted) return;
    setState(() => _myBookingsFilterStatus = filter);
    _loadMyBookings();
  }

  Future<void> _cancelBookedAppointment(String appointmentId, String doctorId, String slotId) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      if (mounted) _showError("You must be logged in.");
      return;
    }
    if (!mounted) return;
    bool? confirmCancel = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Cancellation'),
        content: const Text('Cancel this appointment?'),
        actions: <Widget>[
          TextButton(child: const Text('No'), onPressed: () => Navigator.of(ctx).pop(false)),
          TextButton(child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)), onPressed: () => Navigator.of(ctx).pop(true)),
        ],
      ),
    );
    if (confirmCancel != true) return;
    if (!mounted) return;
    try {
      final appointmentRef = _firestore.collection('appointments').doc(appointmentId);
      final slotRef = _firestore.collection('doctors').doc(doctorId).collection('availabilitySlots').doc(slotId);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot apptDoc = await transaction.get(appointmentRef);
        if (!apptDoc.exists) throw Exception("Appointment not found.");
        transaction.update(appointmentRef, {'status': 'cancelled_by_patient'});
        transaction.update(slotRef, {'isBooked': false, 'bookedByPatientId': null, 'appointmentId': null});
      });
      if (mounted) _showFeedback("Appointment cancelled.", isError: false);
    } catch (e) {
      dev.log("MyBookingsTab: Error cancelling: $e");
      if (mounted) _showError("Failed to cancel: ${e.toString().replaceAll("Exception: ", "")}");
    }
  }
  // --- End Methods for "My Bookings" Tab ---

  // Widget for the "Book Appointment" Tab
  Widget _buildBookingFormTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Doctor or Specialty',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                hintText: 'e.g., Dr. Smith or Cardiology',
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value.trim();
                  _filterDoctors();
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Specialty>(
              decoration: const InputDecoration(
                labelText: 'Specialty',
                border: OutlineInputBorder(),
              ),
              value: _selectedSpecialty,
              isExpanded: true,
              items: _isLoadingSpecialties
                  ? [
                      const DropdownMenuItem<Specialty>(
                        value: null,
                        child: Text('Loading specialties...'),
                        enabled: false,
                      )
                    ]
                  : [
                      const DropdownMenuItem<Specialty>(
                        value: null,
                        child: Text('Select Specialty'),
                      ),
                      ..._allSpecialties.map((specialty) => DropdownMenuItem<Specialty>(
                            value: specialty,
                            child: Text(specialty.name),
                          )),
                    ],
              onChanged: _isLoadingSpecialties ? null : _onSpecialtySelected,
              validator: (value) => value == null ? 'Please select a specialty' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Doctor>(
              decoration: const InputDecoration(
                labelText: 'Doctor',
                border: OutlineInputBorder(),
              ),
              value: _selectedDoctor,
              isExpanded: true,
              items: _isLoadingDoctors
                  ? [
                      const DropdownMenuItem<Doctor>(
                        value: null,
                        child: Text('Loading doctors...'),
                        enabled: false,
                      )
                    ]
                  : [
                      const DropdownMenuItem<Doctor>(
                        value: null,
                        child: Text('Select Doctor'),
                      ),
                      ..._filteredDoctors.map((doctor) => DropdownMenuItem<Doctor>(
                            value: doctor,
                            child: Text('Dr. ${doctor.name} (${doctor.specialtyName})'),
                          )),
                    ],
              onChanged: _isLoadingDoctors ? null : _onDoctorSelected,
              validator: (value) => value == null ? 'Please select a doctor' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<HospitalAffiliation>(
              decoration: const InputDecoration(
                labelText: 'Hospital',
                border: OutlineInputBorder(),
              ),
              value: _selectedHospitalAffiliation,
              isExpanded: true,
              items: _hospitalAffiliations.isEmpty
                  ? [
                      const DropdownMenuItem<HospitalAffiliation>(
                        value: null,
                        child: Text('Select a doctor first'),
                        enabled: false,
                      )
                    ]
                  : [
                      const DropdownMenuItem<HospitalAffiliation>(
                        value: null,
                        child: Text('Select Hospital'),
                      ),
                      ..._hospitalAffiliations.map((hospital) => DropdownMenuItem<HospitalAffiliation>(
                            value: hospital,
                            child: Text(hospital.hospitalName),
                          )),
                    ],
              onChanged: _selectedDoctor == null ? null : _onHospitalSelected,
              validator: (value) => value == null ? 'Please select a hospital' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
                hintText: _selectedDate == null ? 'Select Date' : DateFormat.yMMMd().format(_selectedDate!),
              ),
              onTap: () => _selectDate(context),
              validator: (value) => _selectedDate == null ? 'Please select a date' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AvailableSlot>(
              decoration: const InputDecoration(
                labelText: 'Time Slot',
                border: OutlineInputBorder(),
              ),
              value: _selectedSlot,
              isExpanded: true,
              items: _isLoadingTimeSlots
                  ? [
                      const DropdownMenuItem<AvailableSlot>(
                        value: null,
                        child: Text('Loading time slots...'),
                        enabled: false,
                      )
                    ]
                  : _availableTimeSlots.isEmpty
                      ? [
                          const DropdownMenuItem<AvailableSlot>(
                            value: null,
                            child: Text('No time slots available'),
                            enabled: false,
                          )
                        ]
                      : [
                          const DropdownMenuItem<AvailableSlot>(
                            value: null,
                            child: Text('Select Time Slot'),
                          ),
                          ..._availableTimeSlots.map((slot) => DropdownMenuItem<AvailableSlot>(
                                value: slot,
                                child: Text(slot.displayTime),
                              )),
                        ],
              onChanged: _isLoadingTimeSlots || _availableTimeSlots.isEmpty ? null : (slot) {
                if (mounted) setState(() => _selectedSlot = slot);
              },
              validator: (value) => value == null ? 'Please select a time slot' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _patientNameController,
              decoration: const InputDecoration(
                labelText: 'Patient Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty ? 'Please enter patient name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _patientContactController,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please enter contact number' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Visit (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isBooking ? null : _bookAppointment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isBooking
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Book Appointment', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the "My Bookings" Tab
  Widget _buildMyBookingsTab() {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return const Center(child: Text("Please log in."));
    if (_myBookingsStream == null) {
      _loadMyBookings();
      return const Center(child: Text("Loading..."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: SegmentedButton<String>(
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(value: 'upcoming', label: Text('Upcoming'), icon: Icon(Icons.event_available_outlined)),
              ButtonSegment<String>(value: 'past', label: Text('Past'), icon: Icon(Icons.history_outlined)),
              ButtonSegment<String>(value: 'all', label: Text('All'), icon: Icon(Icons.list_alt)),
            ],
            selected: <String>{_myBookingsFilterStatus},
            onSelectionChanged: (Set<String> newSelection) => _setMyBookingsFilter(newSelection.first),
            style: SegmentedButton.styleFrom(selectedForegroundColor: Colors.white, selectedBackgroundColor: Theme.of(context).primaryColor),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<BookedUserAppointment>>(
            stream: _myBookingsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                String message = 'You have no appointments.';
                if (_myBookingsFilterStatus == 'upcoming') message = 'No upcoming appointments.';
                else if (_myBookingsFilterStatus == 'past') message = 'No past appointments found.';
                return Center(child: Text(message, style: TextStyle(fontSize: 16, color: Colors.grey[600])));
              }
              List<BookedUserAppointment> appointments = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16.0),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  bool canCancel = appointment.status.toLowerCase() == 'confirmed' && appointment.appointmentStartTime.toDate().isAfter(DateTime.now());
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Dr. ${appointment.doctorName}",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  appointment.status.capitalize(),
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: _getStatusColorForBooking(appointment.status),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          if (appointment.doctorSpecialtyName != null && appointment.doctorSpecialtyName!.isNotEmpty)
                            Text(appointment.doctorSpecialtyName!, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.calendar_today_outlined, DateFormat('EEE, MMM d, yyyy').format(appointment.appointmentStartTime.toDate())),
                          _buildInfoRow(
                              Icons.access_time_outlined, "${DateFormat.jm().format(appointment.appointmentStartTime.toDate())} - ${DateFormat.jm().format(appointment.appointmentEndTime.toDate())}"),
                          _buildInfoRow(Icons.local_hospital_outlined, appointment.hospitalName),
                          if (appointment.reasonForVisit != null && appointment.reasonForVisit!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text("Reason: ${appointment.reasonForVisit}", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[800], fontSize: 13)),
                          ],
                          if (canCancel) ...[
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                style: TextButton.styleFrom(foregroundColor: Colors.redAccent.shade400),
                                onPressed: () => _cancelBookedAppointment(appointment.id, appointment.doctorId, appointment.slotId),
                                child: const Text('Cancel'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[800]))),
        ],
      ),
    );
  }

  Color _getStatusColorForBooking(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.blue.shade600;
      case 'completed':
        return Colors.green.shade600;
      case 'cancelled_by_patient':
      case 'cancelled_by_doctor':
      case 'cancelled':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade500;
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Appointments'),
  //       bottom: TabBar(
  //         controller: _tabController,
  //         labelColor: Theme.of(context).colorScheme.primary,
  //         unselectedLabelColor: Colors.grey[700],
  //         indicatorColor: Theme.of(context).colorScheme.primary,
  //         tabs: const [
  //           Tab(icon: Icon(Icons.edit_calendar_outlined), text: "Book New"),
  //           Tab(icon: Icon(Icons.event_note_outlined), text: "My Bookings"),
  //         ],
  //       ),
  //     ),
  //     body: TabBarView(
  //       controller: _tabController,
  //       children: [
  //         _buildBookingFormTab(),
  //         _buildMyBookingsTab(),
  //       ],
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green, // Default selected text color (fallback)
          unselectedLabelColor: Colors.blue[900], // Default unselected text color (fallback)
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_calendar_outlined,
                    color: _tabController.index == 0 ? Colors.purple : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Book New",
                    style: TextStyle(
                      color: _tabController.index == 0 ? Colors.green : Colors.blue[900],
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_note_outlined,
                    color: _tabController.index == 1 ? Colors.purple : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "My Bookings",
                    style: TextStyle(
                      color: _tabController.index == 1 ? Colors.green : Colors.blue[900],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingFormTab(),
          _buildMyBookingsTab(),
        ],
      ),
    );
  }


}

extension StringExtensionLocal on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}



