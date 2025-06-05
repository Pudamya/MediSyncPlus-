// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'profile_screen.dart';

// class PatientHomeScreen extends StatelessWidget {
//   const PatientHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bool isWeb = MediaQuery.of(context).size.width > 800;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 76, 175, 80),
//         title: Text(
//           'MediSyncPlus',
//           style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           if (isWeb)
//             IconButton(
//               icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Barcode scanning not implemented yet')),
//                 );
//               },
//             ),
//           IconButton(
//             icon: const Icon(Icons.notifications, color: Colors.white),
//             onPressed: () {
//               // TODO: Navigate to Notifications
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.person, color: Colors.white),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ProfileScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       drawer: isWeb
//           ? Drawer(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   DrawerHeader(
//                     decoration: const BoxDecoration(
//                       color: Color.fromARGB(255, 76, 175, 80),
//                     ),
//                     child: Text(
//                       'MediSyncPlus',
//                       style: GoogleFonts.nunito(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   _buildDrawerItem(Icons.home, 'Home', () {}),
//                   _buildDrawerItem(Icons.history, 'History', () {}),
//                   _buildDrawerItem(Icons.add, 'Book', () {}),
//                   _buildDrawerItem(Icons.folder, 'Records', () {}),
//                 ],
//               ),
//             )
//           : null,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final int crossAxisCount = isWeb ? 4 : 2;
//           final double padding = isWeb ? 32 : 16;

//           return Stack(
//             children: [
//               Column(
//                 children: [
//                   // Greeting Card
//                   Container(
//                     padding: EdgeInsets.all(padding),
//                     color: const Color.fromARGB(255, 76, 175, 80),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.waving_hand, color: Colors.yellow, size: 32),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Hi Priya, Welcome back!',
//                               style: GoogleFonts.nunito(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Here\'s your health summary for today',
//                           style: GoogleFonts.nunito(fontSize: 16, color: Colors.white70),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Grid Tiles
//                   Expanded(
//                     child: GridView.count(
//                       crossAxisCount: crossAxisCount,
//                       padding: EdgeInsets.all(padding),
//                       crossAxisSpacing: padding,
//                       mainAxisSpacing: padding,
//                       children: [
//                         _buildGridTile(
//                           context,
//                           icon: Icons.calendar_today,
//                           title: 'My Appointments',
//                           description: 'View upcoming bookings & past visits',
//                           onTap: () {},
//                         ),
//                         _buildGridTile(
//                           context,
//                           icon: Icons.local_pharmacy,
//                           title: 'My Prescriptions',
//                           description: 'View all prescriptions linked to barcode',
//                           onTap: () {},
//                         ),
//                         _buildGridTile(
//                           context,
//                           icon: Icons.add_box,
//                           title: 'Book Appointment',
//                           description: 'Book or reschedule appointment',
//                           onTap: () {},
//                         ),
//                         _buildGridTile(
//                           context,
//                           icon: Icons.local_hospital,
//                           title: 'Health Records',
//                           description: 'View and export medical history',
//                           onTap: () {},
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               // Barcode Scanner for phone view (bottom right)
//               if (!isWeb)
//                 Positioned(
//                   right: 16,
//                   bottom: 70,
//                   child: GestureDetector(
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Barcode scanning not implemented yet')),
//                       );
//                     },
//                     child: const Icon(Icons.qr_code_scanner, size: 40, color: Color.fromARGB(255, 76, 175, 80)),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//       bottomNavigationBar: isWeb
//           ? null
//           : BottomNavigationBar(
//               backgroundColor: Colors.white,
//               selectedItemColor: const Color.fromARGB(255, 76, 175, 80),
//               unselectedItemColor: Colors.grey,
//               type: BottomNavigationBarType.fixed,
//               items: const [
//                 BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//                 BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
//                 BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Book'),
//                 BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Records'),
//               ],
//               currentIndex: 0,
//               onTap: (index) {
//                 // TODO: Handle navigation
//               },
//             ),
//     );
//   }

//   Widget _buildGridTile(BuildContext context,
//       {required IconData icon, required String title, required String description, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withAlpha(51),
//               spreadRadius: 2,
//               blurRadius: 6,
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 48, color: const Color.fromARGB(255, 76, 175, 80)),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 6),
//             Text(
//               description,
//               style: GoogleFonts.nunito(fontSize: 14, color: Colors.black54),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, color: const Color.fromARGB(255, 76, 175, 80)),
//       title: Text(title, style: GoogleFonts.nunito(fontSize: 16)),
//       onTap: onTap,
//     );
//   }
// }

























import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medi_sync_plus_app/pages/patient/profile_screen.dart';
import 'package:medi_sync_plus_app/pages/patient/medical_history_page.dart';
import 'package:medi_sync_plus_app/pages/patient/patient_prescription_page.dart';
import 'package:medi_sync_plus_app/pages/patient/appointment_booking_page.dart';
import 'package:provider/provider.dart';
import 'package:medi_sync_plus_app/providers/patient_provider.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 800;
    final String patientId = Provider.of<PatientProvider>(context).patientId ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 175, 80),
        title: Text(
          'MediSyncPlus',
          style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (isWeb)
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Barcode scanning not implemented yet')),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to Notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      drawer: isWeb
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 76, 175, 80),
                    ),
                    child: Text(
                      'MediSyncPlus',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildDrawerItem(Icons.home, 'Home', () {
                    Navigator.pop(context); // Close drawer
                  }),
                  _buildDrawerItem(Icons.history, 'History', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PatientPrescriptionPage(patientId: '')),
                    );
                  }),
                  _buildDrawerItem(Icons.add, 'Book', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AppointmentBookingPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.folder, 'Records', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicalHistoryPage(userId: patientId, isDoctor: false)),
                    );
                  }),
                ],
              ),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final int crossAxisCount = isWeb ? 4 : 2;
          final double padding = isWeb ? 32 : 16;

          return Stack(
            children: [
              Column(
                children: [
                  // Greeting Card
                  Container(
                    padding: EdgeInsets.all(padding),
                    color: const Color.fromARGB(255, 76, 175, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.waving_hand, color: Colors.yellow, size: 32),
                            const SizedBox(width: 8),
                            Text(
                              'Hi Priya, Welcome back!',
                              style: GoogleFonts.nunito(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Here\'s your health summary for today',
                          style: GoogleFonts.nunito(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  // Grid Tiles
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: crossAxisCount,
                      padding: EdgeInsets.all(padding),
                      crossAxisSpacing: padding,
                      mainAxisSpacing: padding,
                      children: [
                        _buildGridTile(
                          context,
                          icon: Icons.calendar_today,
                          title: 'My Appointments',
                          description: 'View upcoming bookings & past visits',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PatientPrescriptionPage(patientId: '')),
                            );
                          },
                        ),
                        _buildGridTile(
                          context,
                          icon: Icons.local_pharmacy,
                          title: 'My Prescriptions',
                          description: 'View all prescriptions linked to barcode',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PatientPrescriptionPage(patientId: '')),
                            );
                          },
                        ),
                        _buildGridTile(
                          context,
                          icon: Icons.add_box,
                          title: 'Book Appointment',
                          description: 'Book or reschedule appointment',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AppointmentBookingPage()),
                            );
                          },
                        ),
                        _buildGridTile(
                          context,
                          icon: Icons.local_hospital,
                          title: 'Health Records',
                          description: 'View and export medical history',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MedicalHistoryPage(userId: patientId, isDoctor: false)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Barcode Scanner for phone view (bottom right)
              if (!isWeb)
                Positioned(
                  right: 16,
                  bottom: 70,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Barcode scanning not implemented yet')),
                      );
                    },
                    child: const Icon(Icons.qr_code_scanner, size: 40, color: Color.fromARGB(255, 76, 175, 80)),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: isWeb
          ? null
          : BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: const Color.fromARGB(255, 76, 175, 80),
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
                BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Book'),
                BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Records'),
              ],
              currentIndex: 0,
              onTap: (index) {
                switch (index) {
                  case 0: // Home (already on this screen)
                    break;
                  case 1: // History
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PatientPrescriptionPage(patientId: '')),
                    );
                    break;
                  case 2: // Book
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AppointmentBookingPage()),
                    );
                    break;
                  case 3: // Records
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicalHistoryPage(userId: patientId, isDoctor: false)),
                    );
                    break;
                }
              },
            ),
    );
  }

  Widget _buildGridTile(BuildContext context,
      {required IconData icon, required String title, required String description, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(51),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color.fromARGB(255, 76, 175, 80)),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: GoogleFonts.nunito(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 76, 175, 80)),
      title: Text(title, style: GoogleFonts.nunito(fontSize: 16)),
      onTap: onTap,
    );
  }
}