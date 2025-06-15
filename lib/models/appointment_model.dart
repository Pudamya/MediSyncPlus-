// lib/models/appointment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting helpers if needed directly in model

class BookedUserAppointment {
  final String id; // Firestore document ID of the appointment
  final String doctorId;
  final String doctorName;
  final String? doctorSpecialtyName; // The specialty name as stored in the appointment
  final String hospitalId;
  final String hospitalName;
  final String patientUid; // UID of the patient who booked
  final String patientName; // Name of the patient at the time of booking
  final String? patientContact; // Contact of the patient at the time of booking (optional)
  final Timestamp appointmentStartTime; // Firestore Timestamp
  final Timestamp appointmentEndTime;   // Firestore Timestamp
  final Timestamp bookedAt;             // Firestore Timestamp of when booking was made
  final String? reasonForVisit;
  final String status; // e.g., "confirmed", "completed", "cancelled_by_patient", "pending_payment"
  final String slotId;   // ID of the specific slot booked from doctors/{doctorId}/availabilitySlots

  BookedUserAppointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    this.doctorSpecialtyName,
    required this.hospitalId,
    required this.hospitalName,
    required this.patientUid,
    required this.patientName,
    this.patientContact,
    required this.appointmentStartTime,
    required this.appointmentEndTime,
    required this.bookedAt,
    this.reasonForVisit,
    required this.status,
    required this.slotId,
  });

  // Factory constructor to create an instance from a Firestore document
  factory BookedUserAppointment.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!; // data() will not be null if doc.exists

    // Helper to safely get a Timestamp, providing a default if null or wrong type
    Timestamp _getTimestamp(dynamic value, {Timestamp? defaultValue}) {
      if (value is Timestamp) {
        return value;
      }
      return defaultValue ?? Timestamp.now(); // Fallback to current time if absolutely necessary
    }

    return BookedUserAppointment(
      id: doc.id,
      doctorId: data['doctorId'] as String? ?? '',
      doctorName: data['doctorName'] as String? ?? 'N/A',
      doctorSpecialtyName: data['specialtyName'] as String?, // Matches field from booking logic
      hospitalId: data['hospitalId'] as String? ?? '',
      hospitalName: data['hospitalName'] as String? ?? 'N/A',
      patientUid: data['patientUid'] as String? ?? '',
      patientName: data['patientName'] as String? ?? 'N/A',
      patientContact: data['patientContact'] as String?,
      appointmentStartTime: _getTimestamp(data['appointmentStartTime']),
      appointmentEndTime: _getTimestamp(data['appointmentEndTime']),
      bookedAt: _getTimestamp(data['bookedAt']),
      reasonForVisit: data['reasonForVisit'] as String?,
      status: data['status'] as String? ?? 'Unknown',
      slotId: data['slotId'] as String? ?? '',
    );
  }

  // Helper getters to easily access DateTime objects
  DateTime get startTimeAsDateTime => appointmentStartTime.toDate();
  DateTime get endTimeAsDateTime => appointmentEndTime.toDate();
  DateTime get bookedAtAsDateTime => bookedAt.toDate();

  // Example of a formatted string directly in the model (optional)
  String get formattedStartTime => DateFormat('EEE, MMM d, yyyy  hh:mm a').format(startTimeAsDateTime.toLocal());
  String get formattedTimeRange => 
    "${DateFormat.jm().format(startTimeAsDateTime.toLocal())} - ${DateFormat.jm().format(endTimeAsDateTime.toLocal())}";
  String get formattedDate => DateFormat('EEE, MMM d, yyyy').format(startTimeAsDateTime.toLocal());


  // You might add a toJson method if you ever need to convert it back for some reason,
  // but it's less common for models used purely for display from Firestore.
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialtyName': doctorSpecialtyName,
      'hospitalId': hospitalId,
      'hospitalName': hospitalName,
      'patientUid': patientUid,
      'patientName': patientName,
      'patientContact': patientContact,
      'appointmentStartTime': appointmentStartTime,
      'appointmentEndTime': appointmentEndTime,
      'bookedAt': bookedAt,
      'reasonForVisit': reasonForVisit,
      'status': status,
      'slotId': slotId,
      // 'appointmentId': id, // Often the document ID is not stored inside the document itself unless needed for denormalization
    };
  }

  @override
  String toString() {
    return 'BookedUserAppointment(id: $id, doctorName: $doctorName, patientName: $patientName, startTime: $formattedStartTime, status: $status)';
  }
}