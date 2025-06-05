import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:medi_sync_plus_app/services/firestore_services.dart';
import 'package:medi_sync_plus_app/providers/patient_provider.dart';
import 'dart:developer' as dev;
import 'package:intl/intl.dart';
import 'dart:async'; // For Timer

// --- Data Model for each Medication Item ---
class MedicationItemData {
  String? selectedBrandName;
  TextEditingController genericNameController = TextEditingController();
  TextEditingController dosageAndFormController = TextEditingController();
  TextEditingController itemSpecificInstructionsController = TextEditingController();
  TextEditingController freqMNController = TextEditingController(text: '0');
  TextEditingController freqAFController = TextEditingController(text: '0');
  TextEditingController freqENController = TextEditingController(text: '0');
  TextEditingController freqNTController = TextEditingController(text: '0');
  String? selectedMealTiming;

  TextEditingController durationController = TextEditingController();
  TextEditingController quantityToDispenseController = TextEditingController();

  final GlobalKey<FormFieldState> genericNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> dosageAndFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> freqMNKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> freqAFKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> freqENKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> freqNTKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> mealTimingKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> durationKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> quantityKey = GlobalKey<FormFieldState>();

  // Cache for fetched brands specific to this item
  List<String>? _fetchedBrands;
  String? _lastFetchedGenericNameForCache; // Tracks the generic name for which brands were cached

  MedicationItemData({this.selectedMealTiming = "Anytime"});

  Map<String, dynamic> toMap() {
    String frequencyInstructions =
        "${freqMNController.text}-${freqAFController.text}-${freqENController.text}-${freqNTController.text} ${selectedMealTiming ?? 'Anytime'}";
    return {
      'medicationGenericName': genericNameController.text.trim(),
      'medicationBrandName': selectedBrandName ?? '',
      'dosageAndForm': dosageAndFormController.text.trim(),
      'itemSpecificInstructions': itemSpecificInstructionsController.text.trim(),
      'frequencyInstructions': frequencyInstructions.trim(),
      'duration': durationController.text.trim(),
      'quantityToDispense': quantityToDispenseController.text.trim(),
    };
  }

  void dispose() {
    genericNameController.dispose();
    dosageAndFormController.dispose();
    itemSpecificInstructionsController.dispose();
    freqMNController.dispose();
    freqAFController.dispose();
    freqENController.dispose();
    freqNTController.dispose();
    durationController.dispose();
    quantityToDispenseController.dispose();
  }

  bool validateAllFields() {
    bool isValid = true;
    if (!(genericNameKey.currentState?.validate() ?? false)) isValid = false;
    if (!(dosageAndFormKey.currentState?.validate() ?? false)) isValid = false;
    if (!(freqMNKey.currentState?.validate() ?? false)) isValid = false;
    if (!(freqAFKey.currentState?.validate() ?? false)) isValid = false;
    if (!(freqENKey.currentState?.validate() ?? false)) isValid = false;
    if (!(freqNTKey.currentState?.validate() ?? false)) isValid = false;
    if (!(mealTimingKey.currentState?.validate() ?? false)) isValid = false;
    if (!(durationKey.currentState?.validate() ?? false)) isValid = false;
    if (!(quantityKey.currentState?.validate() ?? false)) isValid = false;
    return isValid;
  }
}

class PrescriptionCard extends StatelessWidget {
  final String date;
  final String doctorName;
  final String diagnosis;
  final List<dynamic> medicationItems;
  final String? specialInstructions;
  final String? labTestsRecommended;

  const PrescriptionCard({
    super.key,
    required this.date,
    required this.doctorName,
    required this.diagnosis,
    required this.medicationItems,
    this.specialInstructions,
    this.labTestsRecommended,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date: $date', style: TextStyle(color: Colors.grey[600])),
                Text('By: $doctorName', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8),
            Text('Diagnosis: $diagnosis', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Medications:', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
            ...medicationItems.map((item) {
              final brand = item['medicationBrandName'] as String? ?? '';
              final generic = item['medicationGenericName'] as String? ?? 'N/A';
              final dosageForm = item['dosageAndForm'] as String? ?? '';
              final displayName = brand.isNotEmpty ? '$brand ($generic)' : generic;
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: Text('- $displayName $dosageForm', style: TextStyle(color: Colors.grey[800])),
              );
            }),
            if (specialInstructions != null && specialInstructions!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Special Instructions: $specialInstructions', style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
            ],
            if (labTestsRecommended != null && labTestsRecommended!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Lab Tests: $labTestsRecommended', style: TextStyle(color: Colors.grey[600])),
            ],
          ],
        ),
      ),
    );
  }
}

class DoctorPrescriptionPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String specialization;

  const DoctorPrescriptionPage({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
  });

  @override
  State<DoctorPrescriptionPage> createState() => _DoctorPrescriptionPageState();
}

class _DoctorPrescriptionPageState extends State<DoctorPrescriptionPage> {
  final _prescriptionFormKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  List<MedicationItemData> _medicationItems = [];
  final _specialInstructionsController = TextEditingController();
  final _labTestController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;
  bool _showPrescriptionForm = false;

  final Color primaryGreen = Colors.green.shade700;
  final List<String> _mealTimings = ["Before food", "After food", "Anytime"];

  String _currentPatientName = "N/A";
  String _currentPatientAgeGender = "N/A";

  final Debouncer _debouncer = Debouncer(milliseconds: 700); // Increased debounce slightly

  @override
  void initState() {
    super.initState();
    _addInitialMedicationItem();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientId = Provider.of<PatientProvider>(context, listen: false).patientId;
      dev.log('DoctorPrescriptionPage initState: patientId from provider = $patientId');
      if (patientId != null) {
        _fetchPatientDetails(patientId);
      }
      Provider.of<PatientProvider>(context, listen: false).addListener(_patientChanged);
    });
  }

  void _patientChanged() {
    final patientId = Provider.of<PatientProvider>(context, listen: false).patientId;
    dev.log('DoctorPrescriptionPage _patientChanged: patientId from provider = $patientId');
    if (mounted) { // Ensure widget is still in the tree
      if (patientId != null) {
        _fetchPatientDetails(patientId);
      } else {
        setState(() {
          _currentPatientName = "N/A";
          _currentPatientAgeGender = "N/A";
          _showPrescriptionForm = false;
          _clearForm(resetPatientDependent: false);
        });
      }
    }
  }

  Future<void> _fetchPatientDetails(String patientId) async {
    dev.log('Fetching details for patientId: $patientId');
    try {
      DocumentSnapshot? patientDoc = await _firestoreService.getUserProfile(patientId);
      if (!mounted) return; // Check mounted after await

      if (patientDoc != null && patientDoc.exists) {
        setState(() {
          _currentPatientName = patientDoc.get('displayName') ?? 'Unknown Patient';
          Timestamp? dobTimestamp = patientDoc.get('dateOfBirth');
          String gender = patientDoc.get('gender') ?? 'N/A';
          if (dobTimestamp != null) {
            DateTime dob = dobTimestamp.toDate();
            int age = DateTime.now().year - dob.year;
            if (DateTime.now().month < dob.month ||
                (DateTime.now().month == dob.month && DateTime.now().day < dob.day)) {
              age--;
            }
            _currentPatientAgeGender = "$age / $gender";
          } else {
            _currentPatientAgeGender = "Age N/A / $gender";
          }
          dev.log('Patient details fetched: $_currentPatientName, $_currentPatientAgeGender');
        });
      } else {
        setState(() {
          _currentPatientName = "Patient not found";
          _currentPatientAgeGender = "N/A";
          dev.log('Patient not found in Firestore for ID: $patientId');
        });
      }
    } catch (e) {
      dev.log('Error fetching patient details from DoctorPrescriptionPage: $e');
      if (mounted) {
        setState(() {
          _currentPatientName = "Error fetching name";
          _currentPatientAgeGender = "N/A";
        });
      }
    }
  }

  Future<List<String>> _fetchBrandsForGenericName(MedicationItemData item, String genericName) async {
    final currentGenericTrimmed = genericName.trim();
    dev.log('Fetching brands for: "$currentGenericTrimmed" (Item cache was for: "${item._lastFetchedGenericNameForCache}")');

    // Use cached data if generic name hasn't changed (and cache exists)
    if (item._lastFetchedGenericNameForCache == currentGenericTrimmed && item._fetchedBrands != null) {
      dev.log('Using cached brands for "$currentGenericTrimmed"');
      return item._fetchedBrands!;
    }
    item._lastFetchedGenericNameForCache = currentGenericTrimmed; // Update cache key

    if (currentGenericTrimmed.isEmpty) {
      dev.log('Generic name empty, fetching all brands (or returning empty).');
      // Option A: Fetch all brands (requires getAllBrandNamesOnly in FirestoreService)
      // item._fetchedBrands = await _firestoreService.getAllBrandNamesOnly();
      // Option B: Return empty list (current implementation)
      item._fetchedBrands = [];
      if(mounted && item.selectedBrandName != null) {
         // No direct setState here; FutureBuilder will handle UI update
         item.selectedBrandName = null;
      }
      return [];
    }

    try {
      dev.log('Querying Firestore for brands of "$currentGenericTrimmed"...');
      final medicines = await _firestoreService.getGenericMedicines();
      final matchingMedicine = medicines.firstWhere(
        (medicine) => (medicine['genericName'] as String).toLowerCase() == currentGenericTrimmed.toLowerCase(),
        orElse: () => <String, dynamic>{'medicineId': ''},
      );

      final medicineId = matchingMedicine['medicineId'] as String? ?? '';
      if (medicineId.isEmpty) {
        dev.log('No matching medicineId found for "$currentGenericTrimmed".');
        item._fetchedBrands = [];
        if(mounted && item.selectedBrandName != null) { item.selectedBrandName = null; }
        return [];
      }

      dev.log('Found medicineId "$medicineId" for "$currentGenericTrimmed". Fetching brands...');
      final brandDocs = await _firestoreService.getBrandNamesForGeneric(medicineId);
      final brands = brandDocs.map((doc) => doc['brandName'] as String).toList();
      dev.log('Fetched ${brands.length} brands for "$currentGenericTrimmed": $brands');
      
      item._fetchedBrands = brands;
      if (item.selectedBrandName != null && !brands.contains(item.selectedBrandName)) {
         if(mounted) {
           // No direct setState here to avoid build loop; FutureBuilder handles UI.
           // The Dropdown's value logic will handle if selectedBrandName is not in new items.
           item.selectedBrandName = null; 
         }
      }
      return brands;
    } catch (e) {
      dev.log('Error in _fetchBrandsForGenericName for "$currentGenericTrimmed": $e');
      item._fetchedBrands = [];
      if(mounted && item.selectedBrandName != null) { item.selectedBrandName = null; }
      return [];
    }
  }

  void _addInitialMedicationItem() {
    if (_medicationItems.isEmpty) {
      _medicationItems.add(MedicationItemData());
    }
  }

  @override
  void dispose() {
    Provider.of<PatientProvider>(context, listen: false).removeListener(_patientChanged);
    _diagnosisController.dispose();
    for (var item in _medicationItems) {
      item.dispose();
    }
    _specialInstructionsController.dispose();
    _labTestController.dispose();
    _debouncer.dispose();
    super.dispose();
   }

  void _addMedicationItem() {
     setState(() {
      _medicationItems.add(MedicationItemData());
    });
  }

  void _removeMedicationItem(int index) {
     setState(() {
      if (_medicationItems.length > 1) {
        _medicationItems[index].dispose();
        _medicationItems.removeAt(index);
      } else {
        _medicationItems[index].dispose();
        _medicationItems[index] = MedicationItemData();
      }
    });
  }

  Future<void> _savePrescription(String patientId) async {
     if (!(_prescriptionFormKey.currentState?.validate() ?? false)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the diagnosis field.'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_medicationItems.isEmpty || _medicationItems.every((item) => item.genericNameController.text.trim().isEmpty)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one medication item.'), backgroundColor: Colors.orange),
      );
      return;
    }

    bool allItemsValid = true;
    for (var item in _medicationItems) {
      if (!item.validateAllFields()) {
        allItemsValid = false;
        break;
      }
    }

    if (!allItemsValid) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields for each medication item correctly.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    List<Map<String, dynamic>> medicationDataToSave = _medicationItems.map((item) => item.toMap()).toList();

    try {
      await _firestoreService.savePrescription(
        patientId: patientId,
        patientNameAtTimeOfPrescription: _currentPatientName,
        patientAgeAtTimeOfPrescription: _currentPatientAgeGender,
        doctorId: widget.doctorId,
        doctorNameAtTimeOfPrescription: widget.doctorName,
        doctorSpecializationAtTimeOfPrescription: widget.specialization,
        prescriptionIssueDate: Timestamp.now(),
        diagnosis: _diagnosisController.text.trim(),
        medicationItems: medicationDataToSave,
        specialInstructions: _specialInstructionsController.text.trim().isNotEmpty
            ? _specialInstructionsController.text.trim()
            : null,
        labTestsRecommended: _labTestController.text.trim().isNotEmpty ? _labTestController.text.trim() : null,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Prescription saved successfully!'), backgroundColor: primaryGreen),
      );
      _clearForm();
      setState(() => _showPrescriptionForm = false);
    } catch (e) {
      dev.log('Error saving prescription from DoctorPrescriptionPage: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving prescription: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
   }

  void _clearForm({bool resetPatientDependent = true}) {
    if (_prescriptionFormKey.currentState != null) {
      _prescriptionFormKey.currentState!.reset();
    }
    _diagnosisController.clear();
    for (var item in _medicationItems) {
      item.dispose();
    }
    _medicationItems = [];
    _addInitialMedicationItem();
    _specialInstructionsController.clear();
    _labTestController.clear();
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildPreviousPrescriptions(String patientIdForQuery, ThemeData theme) {
    dev.log('_buildPreviousPrescriptions CALLED with patientIdForQuery: $patientIdForQuery, doctorId: ${widget.doctorId}');

    if (patientIdForQuery.isEmpty) {
      dev.log('Patient ID is empty for _buildPreviousPrescriptions, returning message.');
      return const Card(
          elevation: 1,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Valid patient ID required to show previous prescriptions.', textAlign: TextAlign.center),
              )));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top:10.0, bottom: 8.0),
          child: Text(
            'Previous Prescriptions for $_currentPatientName',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getPrescriptionsForDoctorPatient(widget.doctorId, patientIdForQuery),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              dev.log('Error loading prescriptions in StreamBuilder: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: const Text('No previous prescriptions found for this patient by you.', textAlign: TextAlign.center),
                ),
              );
            }

            final prescriptions = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = prescriptions[index].data() as Map<String, dynamic>;
                final medicationItems = prescription['medicationItems'] as List<dynamic>? ?? [];
                final issueDate = (prescription['prescriptionIssueDate'] as Timestamp?)?.toDate();
                final formattedDate = issueDate != null
                    ? DateFormat('dd MMM yyyy, hh:mm a').format(issueDate)
                    : 'Date N/A';

                return PrescriptionCard(
                  date: formattedDate,
                  doctorName: prescription['doctorNameAtTimeOfPrescription'] ?? 'Unknown Doctor',
                  diagnosis: prescription['diagnosis'] ?? 'N/A',
                  medicationItems: medicationItems,
                  specialInstructions: prescription['specialInstructions'],
                  labTestsRecommended: prescription['labTestsRecommended'],
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use listen: true here to react to patient changes for the whole page
    final patientIdFromProvider = Provider.of<PatientProvider>(context).patientId;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color effectivePrimaryColor = isDarkMode ? Colors.greenAccent.shade400 : primaryGreen;
    dev.log('DoctorPrescriptionPage MAIN BUILD: patientIdFromProvider is $patientIdFromProvider, _currentPatientName is $_currentPatientName');


    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentPatientName, // This will update when _fetchPatientDetails calls setState
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: effectivePrimaryColor,
              ),
            ),
            if (_currentPatientAgeGender != "N/A")
              Text(
                _currentPatientAgeGender,
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
            const SizedBox(height: 4),
            Text(
              'Prescribing Doctor: Dr. ${widget.doctorName} (${widget.specialization})',
              style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),

            if (patientIdFromProvider == null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_search, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text(
                        'Please select a patient to manage prescriptions.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: [
                  if (!_showPrescriptionForm)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_medicationItems.isEmpty) _addInitialMedicationItem();
                          setState(() => _showPrescriptionForm = true);
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Create New Prescription', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: effectivePrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  if (_showPrescriptionForm) _buildPrescriptionFormUI(theme, patientIdFromProvider, effectivePrimaryColor),
                  const SizedBox(height: 24),
                  // Conditionally build previous prescriptions only if patientId is valid
                  if (patientIdFromProvider.isNotEmpty)
                     _buildPreviousPrescriptions(patientIdFromProvider, theme)
                  else
                     const Center(child: Text("Select a patient to view previous prescriptions.")),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionFormUI(ThemeData theme, String currentPatientId, Color effectivePrimaryColor) {
     return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _prescriptionFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Prescription Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: effectivePrimaryColor,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _diagnosisController,
                decoration: _inputDecorationWithIcon(
                  Icons.medical_services_outlined,
                  'Diagnosis*',
                  effectivePrimaryColor,
                  hint: 'e.g., Viral Fever, Hypertension',
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Diagnosis is required' : null,
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              Text(
                'Medication Items',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: effectivePrimaryColor.withAlpha(200),
                ),
              ),
              const Divider(height: 16, thickness: 0.5),
              if (_medicationItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "No medication items added yet. Click 'Add Item' below.",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _medicationItems.length,
                  itemBuilder: (context, index) {
                    return _buildMedicationItemInputWidget(
                      _medicationItems[index],
                      index,
                      theme,
                      effectivePrimaryColor,
                    );
                  },
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _addMedicationItem,
                  icon: Icon(Icons.add_circle_outline, color: effectivePrimaryColor),
                  label: Text(
                    'Add Medication Item',
                    style: TextStyle(
                      color: effectivePrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _specialInstructionsController,
                decoration: _inputDecorationWithIcon(
                  Icons.speaker_notes_outlined,
                  'Special Instructions (Optional)',
                  effectivePrimaryColor,
                  hint: 'e.g., Take with plenty of water, Avoid dairy',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _labTestController,
                decoration: _inputDecorationWithIcon(
                  Icons.science_outlined,
                  'Lab Tests Recommended (Optional)',
                  effectivePrimaryColor,
                  hint: 'e.g., CBC, LFT',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _clearForm();
                      setState(() => _showPrescriptionForm = false);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _savePrescription(currentPatientId),
                    icon: _isLoading
                        ? Container()
                        : const Icon(Icons.save_alt_outlined, color: Colors.white, size: 18),
                    label: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : const Text('Save Prescription', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: effectivePrimaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationItemInputWidget(
      MedicationItemData itemData, int index, ThemeData theme, Color pColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300, width: 0.7),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Medication Item ${index + 1}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, color: pColor.withAlpha(220)),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade300, size: 22),
                  tooltip: 'Remove this item',
                  onPressed: () => _removeMedicationItem(index),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const Divider(height: 15, thickness: 0.5),
            const SizedBox(height: 5),
            TextFormField(
              key: itemData.genericNameKey,
              controller: itemData.genericNameController,
              decoration: _inputDecoration('Generic Name*', hint: 'e.g., Paracetamol'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Generic name is required' : null,
              onChanged: (value) {
                 _debouncer.run(() {
                  if (mounted) {
                    setState(() {
                       if (itemData.selectedBrandName != null && value.trim() != itemData._lastFetchedGenericNameForCache) {
                         itemData.selectedBrandName = null;
                       }
                       // This setState will trigger the FutureBuilder below to re-evaluate its future
                    });
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<String>>(
              // Use a key that changes when the generic name text changes to ensure FutureBuilder refetches
              key: ValueKey<String>("brands_for_${itemData.genericNameController.text.trim()}"),
              future: _fetchBrandsForGenericName(itemData, itemData.genericNameController.text),
              builder: (context, snapshot) {
                Widget dropdownWidget;
                List<String> brandsToShow = snapshot.data ?? itemData._fetchedBrands ?? [];

                if (snapshot.connectionState == ConnectionState.waiting && itemData.genericNameController.text.isNotEmpty) {
                  dropdownWidget = const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(child: SizedBox(width:20, height:20, child: CircularProgressIndicator(strokeWidth: 2))),
                  );
                } else if (snapshot.hasError) {
                  dropdownWidget = Text('Error loading brands: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                } else {
                    String? validSelection = itemData.selectedBrandName;
                    if (validSelection != null && !brandsToShow.contains(validSelection)) {
                        validSelection = null; // Reset if current selection is not in the new list
                    }

                    dropdownWidget = DropdownButtonFormField<String>(
                      value: validSelection,
                      hint: Text(itemData.genericNameController.text.isEmpty
                                  ? 'Enter Generic Name first'
                                  : brandsToShow.isEmpty ? 'No brands found' : 'Select Brand (Optional)'),
                      isExpanded: true,
                      items: brandsToShow.map((String brand) {
                        return DropdownMenuItem<String>(
                          value: brand,
                          child: Text(brand, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: brandsToShow.isEmpty ? null : (String? newValue) {
                        setState(() {
                          itemData.selectedBrandName = newValue;
                        });
                      },
                      decoration: _inputDecoration('Brand Name'),
                    );
                }
                 return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: dropdownWidget,
                    key: ValueKey<String>("dropdown_anim_key_${itemData.genericNameController.text.trim()}_${brandsToShow.length}")
                 );
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: itemData.dosageAndFormKey,
              controller: itemData.dosageAndFormController,
              decoration: _inputDecoration('Dosage & Form*', hint: 'e.g., 500mg Tablet, 1 Puff'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Dosage & Form is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: itemData.itemSpecificInstructionsController,
              decoration: _inputDecoration('Specific Instructions (e.g., meals)',
                  hint: 'With meals, Before bedtime'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Text(
              'Frequency (MN-AF-EN-NT)*',
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFreqInput(itemData.freqMNController, "MN", itemData.freqMNKey),
                _buildFreqInput(itemData.freqAFController, "AF", itemData.freqAFKey),
                _buildFreqInput(itemData.freqENController, "EN", itemData.freqENKey),
                _buildFreqInput(itemData.freqNTController, "NT", itemData.freqNTKey),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: itemData.mealTimingKey,
              value: itemData.selectedMealTiming,
              items: _mealTimings.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  itemData.selectedMealTiming = newValue;
                });
              },
              decoration: _inputDecoration('Relation to Meal*'),
              validator: (v) => v == null ? 'Meal timing is required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: itemData.durationKey,
                    controller: itemData.durationController,
                    decoration: _inputDecoration('Duration*', hint: 'e.g., 7 days, STAT'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Duration is required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: itemData.quantityKey,
                    controller: itemData.quantityToDispenseController,
                    decoration: _inputDecoration('Qty to Dispense*', hint: 'e.g., 14 tablets'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Quantity is required' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFreqInput(
      TextEditingController controller, String label, GlobalKey<FormFieldState> key) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: TextFormField(
          key: key,
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
          decoration: _inputDecoration(
            label,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Req';
            if (int.tryParse(v) == null) return 'Num';
            return null;
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label,
      {String? hint, bool isDense = false, EdgeInsets? contentPadding}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryGreen, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
      ),
      isDense: isDense,
      contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,
    );
  }

  InputDecoration _inputDecorationWithIcon(
      IconData icon, String label, Color iconColor, {String? hint}) {
    return _inputDecoration(label, hint: hint).copyWith(
      prefixIcon: Icon(icon, color: iconColor.withAlpha(180), size: 20),
    );
  }
}

// Helper class for debouncing
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
}
}