import 'package:flutter/material.dart';

class PatientProvider with ChangeNotifier {
  String? _patientId;

  String? get patientId => _patientId;

  void setPatientId(String id) {
    _patientId = id;
    notifyListeners();
  }

  void clearPatientId() {
    _patientId = null;
    notifyListeners();
}
}