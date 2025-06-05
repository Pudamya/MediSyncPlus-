import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medi_sync_plus_app/services/firestore_services.dart';
import 'package:medi_sync_plus_app/providers/patient_provider.dart';

class MedicalHistoryPage extends StatefulWidget {
  final String userId;
  final bool isDoctor;

  const MedicalHistoryPage({super.key, required this.userId, required this.isDoctor});

  @override
  State<MedicalHistoryPage> createState() => _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _allergiesController = TextEditingController();
  final _chronicConditionsController = TextEditingController();
  final _familyHistoryController = TextEditingController();
  final _labResultsController = TextEditingController();
  final _vaccinationHistoryController = TextEditingController();

  final List<Map<String, String>> _medications = [];
  final List<TextEditingController> _medicationControllers = [];
  final List<TextEditingController> _dosageControllers = [];
  final List<TextEditingController> _sinceControllers = [];
  final List<TextEditingController> _purposeControllers = [];

  bool _isEditing = true;
  bool _hasSavedData = false;
  bool _isLoading = true;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    if (widget.isDoctor) {
      _isEditing = false; // Doctor view is read-only
      _isLoading = false;
    } else {
      _loadMedicalHistory(widget.userId);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isDoctor) {
      final patientId = Provider.of<PatientProvider>(context).patientId;
      if (patientId != null) {
        _loadMedicalHistory(patientId);
      }
    }
  }

  Future<void> _loadMedicalHistory(String patientId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _firestoreService.getMedicalHistory(patientId: patientId);
      setState(() {
        _allergiesController.text = data['allergies'] ?? '';
        _chronicConditionsController.text = data['chronicConditions'] ?? '';
        _familyHistoryController.text = data['familyHistory'] ?? '';
        _labResultsController.text = data['labResults'] ?? '';
        _vaccinationHistoryController.text = data['vaccinationHistory'] ?? '';

        _medications.clear();
        final medications = data['medications'] as List<dynamic>? ?? [];
        _medications.addAll(medications.map((med) => Map<String, String>.from(med)));
        _syncMedicationControllers();

        _hasSavedData = _medications.isNotEmpty ||
            data.values.any((v) => v is String && v.isNotEmpty);
        if (!widget.isDoctor) {
          _isEditing = !_hasSavedData;
        }
        _isLoading = false;
      });
      // Log access for auditing in doctor view
      if (widget.isDoctor) {
        await _firestoreService.logAccess(patientId, widget.userId);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading medical history: $e')),
      );
    }
  }

  void _syncMedicationControllers() {
    _medicationControllers.clear();
    _dosageControllers.clear();
    _sinceControllers.clear();
    _purposeControllers.clear();
    for (var med in _medications) {
      _medicationControllers.add(TextEditingController(text: med['medication'] ?? ''));
      _dosageControllers.add(TextEditingController(text: med['dosage'] ?? ''));
      _sinceControllers.add(TextEditingController(text: med['since'] ?? ''));
      _purposeControllers.add(TextEditingController(text: med['purpose'] ?? ''));
    }
  }

  void _addMedicationRow() {
    setState(() {
      _medications.add({'medication': '', 'dosage': '', 'since': '', 'purpose': ''});
      _medicationControllers.add(TextEditingController());
      _dosageControllers.add(TextEditingController());
      _sinceControllers.add(TextEditingController());
      _purposeControllers.add(TextEditingController());
    });
  }

  Future<void> _saveOrUpdateMedicalHistory() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        for (int i = 0; i < _medications.length; i++) {
          _medications[i] = {
            'medication': _medicationControllers[i].text,
            'dosage': _dosageControllers[i].text,
            'since': _sinceControllers[i].text,
            'purpose': _purposeControllers[i].text,
          };
        }
        await _firestoreService.saveMedicalHistory(
          allergies: _allergiesController.text,
          chronicConditions: _chronicConditionsController.text,
          familyHistory: _familyHistoryController.text,
          vaccinationHistory: _vaccinationHistoryController.text,
          medications: _medications,
        );
        setState(() {
          _hasSavedData = true;
          _isEditing = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medical history saved successfully!')),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving medical history: $e')),
        );
      }
    }
  }

  void _editMedicalHistory() {
    setState(() {
      _isEditing = true;
    });
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    _chronicConditionsController.dispose();
    _familyHistoryController.dispose();
    _labResultsController.dispose();
    _vaccinationHistoryController.dispose();
    for (var controller in _medicationControllers) {
      controller.dispose();
    }
    for (var controller in _dosageControllers) {
      controller.dispose();
    }
    for (var controller in _sinceControllers) {
      controller.dispose();
    }
    for (var controller in _purposeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientId = widget.isDoctor ? Provider.of<PatientProvider>(context).patientId : widget.userId;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isDoctor ? 'Patient Medical History (Doctor View)' : 'Patient Medical History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 16),
          if (widget.isDoctor && patientId != null)
            Text(
              'Patient ID: $patientId',
              style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
            ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (patientId == null)
            const Center(
              child: Text(
                'Please scan a patient barcode to view their medical history.',
                style: TextStyle(fontSize: 16, fontFamily: 'Roboto', color: Colors.grey),
              ),
            )
          else if (_isEditing || !_hasSavedData) ...[
            Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Allergies'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _allergiesController,
                        decoration: _inputDecoration('Enter allergies'),
                        maxLines: 3,
                        enabled: !widget.isDoctor,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter allergies' : null,
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Chronic Conditions'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _chronicConditionsController,
                        decoration: _inputDecoration('Enter chronic conditions'),
                        maxLines: 3,
                        enabled: !widget.isDoctor,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter chronic conditions' : null,
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Long-Term Medications'),
                      const SizedBox(height: 8),
                      ...List.generate(_medications.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _medicationControllers[index],
                                  decoration: _inputDecoration('Medication'),
                                  enabled: !widget.isDoctor,
                                  validator: (value) => value == null || value.isEmpty ? 'Please enter medication' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _dosageControllers[index],
                                  decoration: _inputDecoration('Dosage'),
                                  enabled: !widget.isDoctor,
                                  validator: (value) => value == null || value.isEmpty ? 'Please enter dosage' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _sinceControllers[index],
                                  decoration: _inputDecoration('Since'),
                                  enabled: !widget.isDoctor,
                                  validator: (value) => value == null || value.isEmpty ? 'Please enter since' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _purposeControllers[index],
                                  decoration: _inputDecoration('Purpose'),
                                  enabled: !widget.isDoctor,
                                  validator: (value) => value == null || value.isEmpty ? 'Please enter purpose' : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (!widget.isDoctor) ...[
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton(
                            onPressed: _addMedicationRow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[900],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: const Text('Add Medication', style: TextStyle(fontSize: 14, fontFamily: 'Roboto')),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      _buildSectionTitle('Family History'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _familyHistoryController,
                        decoration: _inputDecoration('Enter family history'),
                        maxLines: 3,
                        enabled: !widget.isDoctor,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter family history' : null,
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Significant Lab Results'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _labResultsController,
                        decoration: _inputDecoration('Enter lab results'),
                        maxLines: 3,
                        enabled: !widget.isDoctor,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter lab results' : null,
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Vaccination History'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _vaccinationHistoryController,
                        decoration: _inputDecoration('Enter vaccination history'),
                        maxLines: 3,
                        enabled: !widget.isDoctor,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter vaccination history' : null,
                      ),
                      if (!widget.isDoctor) ...[
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            onPressed: _saveOrUpdateMedicalHistory,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[900],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            ),
                            child: const Text('Save', style: TextStyle(fontSize: 16, fontFamily: 'Roboto')),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Allergies'),
                    const SizedBox(height: 8),
                    _buildSavedField('Allergies', _allergiesController.text),
                    const Divider(height: 32),
                    _buildSectionTitle('Chronic Conditions'),
                    const SizedBox(height: 8),
                    _buildSavedField('Chronic Conditions', _chronicConditionsController.text),
                    const Divider(height: 32),
                    _buildSectionTitle('Long-Term Medications'),
                    const SizedBox(height: 8),
                    if (_medications.isNotEmpty) ...[
                      for (var med in _medications.asMap().entries)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(child: _buildSavedField('Medication', med.value['medication'] ?? '')),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildSavedField('Dosage', med.value['dosage'] ?? '')),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildSavedField('Since', med.value['since'] ?? '')),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildSavedField('Purpose', med.value['purpose'] ?? '')),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ] else ...[
                      _buildSavedField('Long-Term Medications', 'No data available'),
                    ],
                    const Divider(height: 32),
                    _buildSectionTitle('Family History'),
                    const SizedBox(height: 8),
                    _buildSavedField('Family History', _familyHistoryController.text),
                    const Divider(height: 32),
                    _buildSectionTitle('Significant Lab Results'),
                    const SizedBox(height: 8),
                    _buildSavedField('Significant Lab Results', _labResultsController.text),
                    const Divider(height: 32),
                    _buildSectionTitle('Vaccination History'),
                    const SizedBox(height: 8),
                    _buildSavedField('Vaccination History', _vaccinationHistoryController.text),
                    if (!widget.isDoctor) ...[
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _editMedicalHistory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[900],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          ),
                          child: const Text('Edit', style: TextStyle(fontSize: 16, fontFamily: 'Roboto')),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.green[900],
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildSavedField(String label, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.green[900],
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content.isNotEmpty ? content : 'No data available',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.green[900], fontFamily: 'Roboto'),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.green[900]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.green[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.green[900]!, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}