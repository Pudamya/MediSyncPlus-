// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:medi_sync_plus_app/services/firestore_services.dart'; // Adjust import path

// class DoctorAppointmentsPage extends StatelessWidget {
//   const DoctorAppointmentsPage({super.key});

//   Future<void> _updateAppointmentStatus(
//     BuildContext context,
//     String appointmentId,
//     String status,
//     String successMessage,
//   ) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('appointments')
//           .doc(appointmentId)
//           .update({'status': status});
//       // It's generally safer to check if the widget is still mounted
//       // before showing a SnackBar, especially after an async operation.
//       // However, for StatelessWidget, 'mounted' isn't directly available.
//       // If this becomes an issue, consider converting to StatefulWidget
//       // or passing context carefully. For now, this is a common pattern.
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(successMessage)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to update appointment: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text("Please log in to view appointments")),
//       );
//     }

//     final firestoreService = FirestoreService();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Appointments"),
//         backgroundColor: Colors.green[700], // Match theme from splash_screen.dart
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: firestoreService.getDoctorAppointments(user.uid),
//         builder: (
//           BuildContext context,
//           AsyncSnapshot<QuerySnapshot> snapshot,
//         ) {
//           if (snapshot.hasError) {
//             return const Center(child: Text("Error loading appointments"));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting ||
//               !snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final appointments = snapshot.data!.docs;

//           if (appointments.isEmpty) {
//             return const Center(child: Text("No appointments booked"));
//           }

//           return ListView.builder(
//             itemCount: appointments.length,
//             itemBuilder: (context, index) {
//               final appointment = appointments[index];
//               final data = appointment.data() as Map<String, dynamic>;

//               return Card(
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ListTile(
//                   title: Text(
//                       "Patient: ${data['patient_name'] ?? 'N/A'}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                           "Date: ${data['date'] ?? 'Unknown'} at ${data['time'] ?? 'Unknown'}"),
//                       Text(
//                           "Hospital: ${data['hospital_name'] ?? 'N/A'}"),
//                       Text(
//                           "Specialty: ${data['specialty'] ?? 'N/A'}"),
//                       if (data['status'] != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4.0),
//                           child: Text(
//                             "Status: ${data['status']}",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: data['status'] == 'completed'
//                                   ? Colors.green
//                                   : data['status'] == 'canceled'
//                                       ? Colors.red
//                                       : Colors.orange,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   trailing: (data['status'] == 'pending' || data['status'] == null) // Only show actions if pending
//                       ? Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.check_circle,
//                                   color: Colors.green),
//                               tooltip: "Mark as Completed",
//                               onPressed: () => _updateAppointmentStatus(
//                                 context,
//                                 appointment.id,
//                                 'completed',
//                                 "Appointment marked as completed",
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.cancel, color: Colors.red),
//                               tooltip: "Cancel Appointment",
//                               onPressed: () => _updateAppointmentStatus(
//                                 context,
//                                 appointment.id,
//                                 'canceled',
//                                 "Appointment canceled",
//                               ),
//                             ),
//                           ],
//                         )
//                       : null, // No actions if already completed or canceled
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }














// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:medi_sync_plus_app/services/firestore_services.dart'; // Adjust to your project name

// class DoctorAppointmentsPage extends StatelessWidget {
//   const DoctorAppointmentsPage({super.key});

//   // Helper method to update appointment status
//   Future<void> _updateAppointmentStatus(
//     BuildContext context, // Pass context for ScaffoldMessenger
//     String appointmentId,
//     String newStatus,
//     String successMessage,
//     String failureMessagePrefix,
//   ) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('appointments')
//           .doc(appointmentId)
//           .update({'status': newStatus});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(successMessage)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("$failureMessagePrefix: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text("Please log in to view appointments.")),
//       );
//     }

//     final firestoreService = FirestoreService();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Appointments"),
//         backgroundColor: Colors.green[700],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         // Assuming getDoctorAppointments fetches appointments where status is 'booked'
//         // or you might want to fetch all and filter/display status differently.
//         stream: firestoreService.getDoctorAppointments(user.uid),
//         builder: (
//           BuildContext context,
//           AsyncSnapshot<QuerySnapshot> snapshot,
//         ) {
//           if (snapshot.hasError) {
//             return Center(
//                 child: Text("Error loading appointments: ${snapshot.error}"));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting ||
//               !snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final List<DocumentSnapshot> appointments = snapshot.data!.docs;

//           if (appointments.isEmpty) {
//             return const Center(child: Text("No appointments currently booked."));
//           }

//           return ListView.builder(
//             itemCount: appointments.length,
//             itemBuilder: (context, index) {
//               final appointment = appointments[index];
//               final data = appointment.data() as Map<String, dynamic>?;

//               if (data == null) {
//                 // Handle cases where data might be unexpectedly null
//                 return const Card(
//                   margin:
//                       EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: ListTile(title: Text("Invalid appointment data")),
//                 );
//               }

//               final String currentStatus = data['status'] as String? ?? 'booked'; // Default to 'booked' if null

//               return Card(
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ListTile(
//                   title:
//                       Text("Patient: ${data['patient_name'] ?? 'N/A'}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                           "Date: ${data['date'] ?? 'Unknown'} at ${data['time'] ?? 'Unknown'}"),
//                       Text(
//                           "Hospital: ${data['hospital_name'] ?? 'N/A'}"),
//                       Text(
//                           "Specialty: ${data['specialty'] ?? 'N/A'}"),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 4.0),
//                         child: Text(
//                           "Status: ${currentStatus[0].toUpperCase()}${currentStatus.substring(1)}", // Capitalize
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: currentStatus == 'completed'
//                                 ? Colors.green
//                                 : currentStatus == 'canceled'
//                                     ? Colors.red
//                                     : currentStatus == 'booked'
//                                         ? Colors.blue // Or orange, etc.
//                                         : Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   // Only show action buttons if the appointment is still 'booked' (or 'pending')
//                   trailing: currentStatus == 'booked'
//                       ? Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.check_circle,
//                                   color: Colors.green),
//                               tooltip: "Mark as Completed",
//                               onPressed: () => _updateAppointmentStatus(
//                                 context,
//                                 appointment.id,
//                                 'completed',
//                                 "Appointment marked as completed.",
//                                 "Failed to mark as completed",
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.cancel, color: Colors.red),
//                               tooltip: "Cancel Appointment",
//                               onPressed: () => _updateAppointmentStatus(
//                                 context,
//                                 appointment.id,
//                                 'canceled',
//                                 "Appointment canceled.",
//                                 "Failed to cancel appointment",
//                               ),
//                             ),
//                           ],
//                         )
//                       : null, // No actions if already completed or canceled
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
























import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Not directly used, can be removed if not needed later

class DoctorAppointmentsPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  const DoctorAppointmentsPage({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  State<DoctorAppointmentsPage> createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage> {
  // Helper to get status icon and color
  Widget _getStatusIcon(String? status) {
    IconData iconData;
    Color iconColor;

    switch (status?.toLowerCase()) {
      case 'confirmed':
      case 'booked': // Assuming 'booked' is also a valid active status
        iconData = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case 'completed':
        iconData = Icons.check_circle;
        iconColor = Colors.blue;
        break;
      case 'canceled':
        iconData = Icons.cancel_outlined;
        iconColor = Colors.red;
        break;
      case 'pending':
        iconData = Icons.hourglass_empty_outlined;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.help_outline;
        iconColor = Colors.grey;
    }
    return Icon(iconData, color: iconColor);
  }

  String _formatStatus(String? status) {
    if (status == null || status.isEmpty) return 'Unknown';
    return status[0].toUpperCase() + status.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments for Dr. ${widget.doctorName}"),
        backgroundColor: Colors.teal[700], // Consistent with theme
        // foregroundColor: Colors.white, // Already handled by theme in main.dart
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( // Explicit type
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctor_id', isEqualTo: widget.doctorId)
            // Optionally, order by date/time
            .orderBy('date', descending: false) // Or 'created_at'
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.hasError) {
            print("Error loading appointments: ${snapshot.error}"); // Log error
            return const Center(
                child: Text('Error loading appointments. Please try again.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No appointments scheduled at the moment.'));
          }

          final List<QueryDocumentSnapshot<Map<String, dynamic>>> appointments =
              snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> appointmentData =
                  appointments[index].data();
              // final String appointmentId = appointments[index].id; // If needed for actions

              final String patientName =
                  appointmentData['patient_name'] as String? ?? 'Unknown Patient';
              final String date = appointmentData['date'] as String? ?? 'N/A';
              final String time = appointmentData['time'] as String? ?? 'N/A';
              final String status =
                  appointmentData['status'] as String? ?? 'pending';

              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  title: Text('Patient: $patientName',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Date: $date'),
                      Text('Time: $time'),
                      Text('Status: ${_formatStatus(status)}'),
                    ],
                  ),
                  trailing: _getStatusIcon(status),
                  // Example: Add actions if needed
                  // onTap: () {
                  //   // Show appointment details or allow actions
                  //   print('Tapped on appointment: $appointmentId');
                  // },
                ),
              );
            },
          );
        },
      ),
    );
  }
}