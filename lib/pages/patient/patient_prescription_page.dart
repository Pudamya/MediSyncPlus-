import 'dart:typed_data'; // For Uint8List
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Not importing 'package:flutter/services.dart' show rootBundle;
import 'package:medi_sync_plus_app/services/firestore_services.dart'; // Ensure path is correct
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart'; // For PDF generation
import 'package:pdf/widgets.dart' as pw; // For PDF generation (aliased)
import 'package:printing/printing.dart'; // For PDF preview & printing/sharing
import 'dart:developer' as dev;


class PatientPrescriptionPage extends StatefulWidget {
  final String patientId;

  const PatientPrescriptionPage({super.key, required this.patientId});

  @override
  State<PatientPrescriptionPage> createState() => _PatientPrescriptionPageState();
}

class _PatientPrescriptionPageState extends State<PatientPrescriptionPage> with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy, hh:mm a'); // For UI display
  final DateFormat _pdfDateOnlyFormat = DateFormat('dd MMM yyyy'); // For PDF date
  final Color primaryGreen = Colors.green.shade700; // Your app's primary green

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<Uint8List> _generatePrescriptionPdf(Map<String, dynamic> prescriptionData) async {
    final pdf = pw.Document();

    // Define colors for PDF
    final PdfColor greenColor = PdfColor(
        primaryGreen.red / 255.0,
        primaryGreen.green / 255.0,
        primaryGreen.blue / 255.0,
        primaryGreen.opacity);

    final PdfColor darkTextColor = PdfColors.black;
    final PdfColor lightTextColor = PdfColors.grey600;
    final PdfColor tableHeaderBgColor = PdfColors.grey200;
    final PdfColor tableBorderColor = PdfColors.grey400;
    final PdfColor whiteColor = PdfColors.white;
    final PdfColor whiteAlpha220 = PdfColor(
        whiteColor.red, // Use .r for red component (0.0-1.0)
        whiteColor.green, // Use .g for green component (0.0-1.0)
        whiteColor.blue, // Use .b for blue component (0.0-1.0)
        220 / 255.0); 
    // Extracting data
    final Timestamp? issueTimestamp = prescriptionData['prescriptionIssueDate'] as Timestamp?;
    final String dateIssued = issueTimestamp != null ? _pdfDateOnlyFormat.format(issueTimestamp.toDate()) : 'N/A';
    final String prescriptionIdNum = prescriptionData['prescriptionSystemId'] as String? ?? 'N/A';
    final String patientName = prescriptionData['patientNameAtTimeOfPrescription'] as String? ?? 'Patient N/A';
    final String patientIdFull = widget.patientId;
    final String patientAgeGender = prescriptionData['patientAgeAtTimeOfPrescription'] as String? ?? 'N/A';
    
    String doctorNameFromData = prescriptionData['doctorNameAtTimeOfPrescription'] as String? ?? 'Doctor N/A';
    String pdfDoctorName = doctorNameFromData;
    if (!doctorNameFromData.toLowerCase().startsWith('dr.')) {
      pdfDoctorName = 'Dr. $doctorNameFromData';
    }
    
    final String doctorSpecialization = prescriptionData['doctorSpecializationAtTimeOfPrescription'] as String? ?? 'N/A';
    final String diagnosisText = prescriptionData['diagnosis'] as String? ?? 'Diagnosis N/A';
    final List<dynamic> medicationItemsDynamic = prescriptionData['medicationItems'] as List<dynamic>? ?? [];

    final List<List<pw.Widget>> medicationsTableRows = medicationItemsDynamic.map((item) {
      final itemMap = item as Map<String, dynamic>;
      String brand = itemMap['medicationBrandName'] as String? ?? '';
      String generic = itemMap['medicationGenericName'] as String? ?? 'N/A';
      String medicationDisplayName = brand.isNotEmpty ? '$brand ($generic)' : generic;
      final cellStyle = pw.TextStyle(fontSize: 8.0, color: darkTextColor);
      const cellPadding = pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3);
      return [
        pw.Container(alignment: pw.Alignment.centerLeft, padding: cellPadding, child: pw.Flexible(child: pw.Text(medicationDisplayName, style: cellStyle, softWrap: true))),
        pw.Container(alignment: pw.Alignment.centerLeft, padding: cellPadding, child: pw.Flexible(child: pw.Text(itemMap['dosageAndForm'] as String? ?? 'N/A', style: cellStyle, softWrap: true))),
        pw.Container(alignment: pw.Alignment.centerLeft, padding: cellPadding, child: pw.Flexible(child: pw.Text(itemMap['frequencyInstructions'] as String? ?? 'N/A', style: cellStyle, softWrap: true))),
        pw.Container(alignment: pw.Alignment.center, padding: cellPadding, child: pw.Flexible(child: pw.Text(itemMap['duration'] as String? ?? 'N/A', style: cellStyle, softWrap: true))),
        pw.Container(alignment: pw.Alignment.center, padding: cellPadding, child: pw.Flexible(child: pw.Text(itemMap['quantityToDispense'] as String? ?? 'N/A', style: cellStyle, softWrap: true))),
      ];
    }).toList();

    final String specialInstructionsText = prescriptionData['specialInstructions'] as String? ?? '';
    final String labTestsText = prescriptionData['labTestsRecommended'] as String? ?? '';

    const double pageHorizontalMargin = 25.0; // Define consistent horizontal margin for content
    const double pageTopMargin = 20.0;
    const double pageBottomMargin = 20.0;


    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        // These margins are for the main content block between header and footer
        margin: const pw.EdgeInsets.only(
            left: pageHorizontalMargin,
            right: pageHorizontalMargin,
            top: pageTopMargin,
            bottom: pageBottomMargin),
        
        header: (pw.Context context) {
          return pw.Container(
            // Make header full width by counteracting MultiPage's horizontal content margin
            margin: const pw.EdgeInsets.only(
                left: -pageHorizontalMargin, // Go to edge of page
                right: -pageHorizontalMargin, // Go to edge of page
                bottom: 15.0 // Space after header before main content starts
            ),
            color: greenColor,
            padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: pageHorizontalMargin + 5), // Internal padding
            alignment: pw.Alignment.center,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                 pw.Text(pdfDoctorName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18, color: whiteColor)),
                 pw.SizedBox(height: 2),
                 pw.Text(doctorSpecialization, style: pw.TextStyle(fontSize: 11, color: whiteAlpha220)),
              ]
            )
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            // This container is for the footer content, its width will be constrained by MultiPage's margin
            // If you want the footer to also be edge-to-edge, apply negative margins like the header.
            // For now, let's keep it within content margins for simplicity of page number and signature alignment.
            margin: const pw.EdgeInsets.only(top: 10), // Space above the footer content
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Align(
                   alignment: pw.Alignment.centerRight,
                   child: pw.Container(
                      width: 180,
                      // margin: const pw.EdgeInsets.only(bottom: 5), // Added margin for signature block
                      child: pw.Column(
                          mainAxisSize: pw.MainAxisSize.min,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(height: 0.5, color: darkTextColor, margin: const pw.EdgeInsets.only(bottom: 3)),
                            pw.Text(pdfDoctorName, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: darkTextColor), textAlign: pw.TextAlign.center, softWrap: true),
                            pw.Text(doctorSpecialization, style: pw.TextStyle(fontSize: 8, color: lightTextColor), textAlign: pw.TextAlign.center, softWrap: true),
                          ]))),
                pw.SizedBox(height: 10), // Space between signature and page number
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: pw.TextStyle(color: PdfColors.grey, fontSize: 8),
                  ),
                ),
              ]
            )
          );
        },
        build: (pw.Context context) {
          // The content for the body of the page(s)
          return <pw.Widget>[
            // --- Patient & Prescription Info ---
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(patientName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13, color: darkTextColor), softWrap: true),
                      pw.SizedBox(height: 1),
                      pw.Text('ID: $patientIdFull', style: pw.TextStyle(fontSize: 9, color: lightTextColor), softWrap: true),
                      pw.Text(patientAgeGender, style: pw.TextStyle(fontSize: 9, color: lightTextColor), softWrap: true),
                    ],
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Date: $dateIssued', style: pw.TextStyle(fontSize: 9, color: lightTextColor), softWrap: true),
                      if (prescriptionIdNum != 'N/A' && prescriptionIdNum.isNotEmpty)
                        pw.Text('Prescription ID: $prescriptionIdNum', style: pw.TextStyle(fontSize: 9, color: lightTextColor), softWrap: true),
                    ],
                  ),
                ),
              ],
            ),
            pw.Divider(height: 18, thickness: 0.5, color: tableBorderColor),

            // --- Diagnosis ---
            pw.Text('Diagnosis:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: darkTextColor)),
            pw.SizedBox(height: 2),
            pw.Text(diagnosisText, style: pw.TextStyle(fontSize: 9.5, color: darkTextColor), softWrap: true),
            pw.SizedBox(height: 12),

            // --- Medications Rx Symbol and Table ---
             pw.Row(
               crossAxisAlignment: pw.CrossAxisAlignment.start,
               children: [
                  pw.Container(
                    margin: const pw.EdgeInsets.only(right: 6, top: -2),
                    child: pw.Text('Rx:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: darkTextColor)),
                  ),
                  pw.Expanded(
                    child: medicationItemsDynamic.isNotEmpty
                        ? pw.Table(
                            border: pw.TableBorder.all(color: tableBorderColor, width: 0.5),
                            columnWidths: {
                              0: const pw.FlexColumnWidth(3.2), 1: const pw.FlexColumnWidth(2.3),
                              2: const pw.FlexColumnWidth(2.5), 3: const pw.FlexColumnWidth(1.2),
                              4: const pw.FlexColumnWidth(1.5),
                            },
                            children: [
                              pw.TableRow(
                                decoration: pw.BoxDecoration(color: tableHeaderBgColor),
                                children: [
                                  'Medication', 'Dosage/Form', 'Frequency', 'Duration', 'Qty.'
                                ].map((header) => pw.Container(
                                      alignment: pw.Alignment.centerLeft,
                                      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                      child: pw.Text(header, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7.5, color: darkTextColor)),
                                    )).toList(),
                              ),
                              ...medicationsTableRows.map((rowCells) => pw.TableRow(children: rowCells)),
                            ],
                          )
                        : pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 8), child: pw.Text('No medications listed.', style: pw.TextStyle(fontSize: 9.5, fontStyle: pw.FontStyle.italic, color: lightTextColor))),
                  ),
               ]
             ),
            pw.SizedBox(height: 15),

            // --- Special Instructions ---
            if (specialInstructionsText.isNotEmpty) ...[
              pw.Text('Special Instructions:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: darkTextColor)),
              pw.SizedBox(height: 2),
              pw.Text(specialInstructionsText, style: pw.TextStyle(fontSize: 9.5, color: darkTextColor), softWrap: true),
              pw.SizedBox(height: 8),
            ],

            // --- Lab Tests ---
            if (labTestsText.isNotEmpty) ...[
              pw.Text('Lab Tests Recommended:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: darkTextColor)),
              pw.SizedBox(height: 2),
              pw.Text(labTestsText, style: pw.TextStyle(fontSize: 9.5, color: darkTextColor), softWrap: true),
            ],
            // Spacer is not needed here; MultiPage manages flow to footer.
            // If content is short, footer appears after it. If long, new page is created.
          ];
        },
      ),
    );
    return pdf.save();
  }

  Future<void> _downloadPrescription(Map<String, dynamic> prescriptionData) async {
    try {
      final pdfBytes = await _generatePrescriptionPdf(prescriptionData);
      if (!mounted) return;
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: 'prescription_${prescriptionData['prescriptionIssueDate']?.seconds ?? DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      dev.log('Error generating or sharing PDF: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not generate PDF: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color effectivePrimaryColor = isDarkMode ? Colors.greenAccent.shade400 : primaryGreen;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Health Records',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: effectivePrimaryColor,
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: effectivePrimaryColor,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: effectivePrimaryColor,
            indicatorWeight: 3.0,
            tabs: const [
              Tab(text: "Doctor's Prescriptions"),
              Tab(text: "Pharmacy Dispense History"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDoctorsPrescriptionsList(theme, effectivePrimaryColor),
                _buildDispenseHistoryList(theme, effectivePrimaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsPrescriptionsList(ThemeData theme, Color effectivePrimaryColor) {
    final Color cardColor = theme.brightness == Brightness.dark ? (Colors.grey[850] ?? Colors.grey.shade900) : Colors.white;
    final Color? textColor = theme.brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[800];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getPrescriptionsForPatient(widget.patientId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            dev.log("Error fetching patient prescriptions: ${snapshot.error}");
            return Card(color: cardColor, child: Padding(padding: const EdgeInsets.all(16), child: Text('Error: ${snapshot.error}')));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Text('No doctor prescriptions found.', style: TextStyle(fontSize: 16, color: textColor ?? Colors.grey)),
              ),
            );
          }
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final Timestamp? issueTimestamp = data['prescriptionIssueDate'] as Timestamp?;
              
              String doctorNameFromData = data['doctorNameAtTimeOfPrescription'] as String? ?? 'N/A';
              String doctorNameDisplay = doctorNameFromData;
              if (!doctorNameFromData.toLowerCase().startsWith('dr.')) {
                doctorNameDisplay = 'Dr. $doctorNameFromData';
              }

              final String doctorSpecDisplay = data['doctorSpecializationAtTimeOfPrescription'] as String? ?? 'N/A';
              final String diagnosisDisplay = data['diagnosis'] as String? ?? 'No diagnosis provided.';
              final List<dynamic> medicationItems = data['medicationItems'] as List<dynamic>? ?? [];
              final String specialInstructionsDisplay = data['specialInstructions'] as String? ?? '';
              final String labTestsDisplay = data['labTestsRecommended'] as String? ?? '';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doctorNameDisplay, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: effectivePrimaryColor)),
                                Text(doctorSpecDisplay, style: TextStyle(fontSize: 13, color: Colors.grey[theme.brightness == Brightness.dark ? 400: 600])),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.download_for_offline_outlined, color: effectivePrimaryColor),
                            tooltip: 'Download Prescription PDF',
                            onPressed: () => _downloadPrescription(data),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                       _buildSectionTitle('Diagnosis:', effectivePrimaryColor.withAlpha((255 * 0.8).round())),
                      Text(diagnosisDisplay, style: TextStyle(fontSize: 14, color: textColor ?? Colors.grey)),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Medications:', effectivePrimaryColor.withAlpha((255 * 0.8).round())),
                      if (medicationItems.isNotEmpty)
                        ...medicationItems.map((item) {
                          final itemMap = item as Map<String, dynamic>;
                          final String brand = itemMap['medicationBrandName'] as String? ?? '';
                          final String generic = itemMap['medicationGenericName'] as String? ?? 'N/A';
                          final String medNameDisplay = brand.isNotEmpty ? '$brand ($generic)' : generic;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• $medNameDisplay', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor ?? Colors.grey)),
                                _buildMedicationDetailRow('  Dosage & Form:', itemMap['dosageAndForm'] as String?, textColor),
                                _buildMedicationDetailRow('  Frequency:', itemMap['frequencyInstructions'] as String?, textColor),
                                _buildMedicationDetailRow('  Duration:', itemMap['duration'] as String?, textColor),
                                _buildMedicationDetailRow('  Quantity:', itemMap['quantityToDispense'] as String?, textColor),
                                if((itemMap['itemSpecificInstructions'] as String?)?.isNotEmpty ?? false)
                                   _buildMedicationDetailRow('  Notes:', itemMap['itemSpecificInstructions'] as String?, textColor),
                              ],
                            ),
                          );
                        })
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                          child: Text('No medications listed.', style: TextStyle(fontSize: 14, color: textColor?.withAlpha(150) ?? Colors.grey.withAlpha(150), fontStyle: FontStyle.italic)),
                        ),
                      if (specialInstructionsDisplay.isNotEmpty) ...[
                        const SizedBox(height:16),
                        _buildSectionTitle('Special Instructions:', effectivePrimaryColor.withAlpha((255 * 0.8).round())),
                        Text(specialInstructionsDisplay, style: TextStyle(fontSize: 14, color: textColor ?? Colors.grey)),
                       ],
                      if (labTestsDisplay.isNotEmpty) ...[
                        const SizedBox(height:10),
                        _buildSectionTitle('Lab Tests Recommended:', effectivePrimaryColor.withAlpha((255 * 0.8).round())),
                        Text(labTestsDisplay, style: TextStyle(fontSize: 14, color: textColor ?? Colors.grey)),
                       ],
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey[theme.brightness == Brightness.dark ? 700 : 400]),
                      const SizedBox(height: 8),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              issueTimestamp != null ? _dateFormat.format(issueTimestamp.toDate()) : 'Date N/A',
                              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                              overflow: TextOverflow.ellipsis, softWrap: false, maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDispenseHistoryList(ThemeData theme, Color effectivePrimaryColor) {
    final Color cardColor = theme.brightness == Brightness.dark ? (Colors.grey[850] ?? Colors.grey.shade900) : Colors.white;
    final Color? textColor = theme.brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[800];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dispense_records')
            .where('patientId', isEqualTo: widget.patientId)
            .orderBy('dispenseTimestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            dev.log("Error fetching dispense history: ${snapshot.error}");
            return Card(color: cardColor, child: Padding(padding: const EdgeInsets.all(16), child: Text('Error: ${snapshot.error}')));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Text('No dispense history found.', style: TextStyle(fontSize: 16, color: textColor ?? Colors.grey)),
              ),
            );
          }

          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final Timestamp? dispenseTimestamp = data['dispenseTimestamp'] as Timestamp?;
              final String pharmacistName = data['pharmacistName'] as String? ?? 'Unknown Pharmacist';
              final List<dynamic> dispensedItems = data['dispensedItems'] as List<dynamic>? ?? [];

              return Card(
                elevation: 1.5,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dispensed by: $pharmacistName', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: effectivePrimaryColor.withAlpha((255 * 0.8).round()))),
                      Text('Date: ${dispenseTimestamp != null ? _dateFormat.format(dispenseTimestamp.toDate()) : 'N/A'}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 6),
                      if (dispensedItems.isNotEmpty)
                        ...dispensedItems.map((item) {
                          final itemMap = item as Map<String, dynamic>;
                          final String brand = itemMap['medicationBrandName'] as String? ?? '';
                          final String generic = itemMap['medicationGenericName'] as String? ?? 'N/A';
                          final String medNameDisplay = brand.isNotEmpty ? '$brand ($generic)' : generic;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0, bottom: 2.0, left: 4.0),
                            child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                Text('• $medNameDisplay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor ?? Colors.grey)),
                                _buildMedicationDetailRow('  Form:', itemMap['dosageAndForm'] as String?, textColor),
                                _buildMedicationDetailRow('  Quantity Dispensed:', itemMap['quantityDispensed'] as String?, textColor),
                                if((itemMap['notesByPharmacist'] as String?)?.isNotEmpty ?? false)
                                   _buildMedicationDetailRow('  Pharmacist Notes:', itemMap['notesByPharmacist'] as String?, textColor),
                               ],
                            ),
                          );
                        })
                      else
                        Text('No specific items detailed for this dispense record.', style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: textColor?.withAlpha(150))),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _buildMedicationDetailRow(String label, String? value, Color? textColor) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 2.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 13, color: textColor?.withAlpha(230) ?? Colors.grey.shade700.withAlpha(230)),
          children: [
            TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.w500)),
            TextSpan(text: ' $value'),
          ]
        ),
      ),
    );
  }
}