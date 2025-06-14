import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

// Placeholder for LoginScreen (replace with your actual login screen)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Login Screen')),
    );
  }
}

// Main Dashboard Screen
class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navDestinationsData = [
    {'icon': Icons.dashboard_outlined, 'selectedIcon': Icons.dashboard, 'label': 'Dashboard'},
    {'icon': Icons.search, 'selectedIcon': Icons.search_rounded, 'label': 'Search'},
    {'icon': Icons.calendar_today_outlined, 'selectedIcon': Icons.calendar_today, 'label': 'Appointments'},
    {'icon': Icons.settings_outlined, 'selectedIcon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.science_outlined, 'selectedIcon': Icons.science, 'label': 'Lab Orders'},
    {'icon': Icons.logout_outlined, 'selectedIcon': Icons.logout, 'label': 'Logout'},
  ];

  void _onNavItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 5) _logout();
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  final List<Map<String, dynamic>> _patients = [
    {'name': 'Priya Sharma', 'lastVisit': DateTime(2025, 6, 3), 'id': 'P001'},
    {'name': 'Amit Patel', 'lastVisit': DateTime(2025, 6, 2), 'id': 'P002'},
    {'name': 'Sara Khan', 'lastVisit': DateTime(2025, 6, 1), 'id': 'P003'},
  ];

  final List<Map<String, dynamic>> _appointments = [
    {'patientName': 'Priya Sharma', 'time': DateTime(2025, 6, 4, 13, 0), 'status': 'Active'},
    {'patientName': 'Amit Patel', 'time': DateTime(2025, 6, 4, 11, 30), 'status': 'Completed'},
    {'patientName': 'Sara Khan', 'time': DateTime(2025, 6, 4, 14, 0), 'status': 'Scheduled'},
  ];

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return DashboardContent(profileMenuBuilder: _buildProfileMenu);
      case 1:
        return PatientSearchContent(patients: _patients);
      case 2:
        return AppointmentsContent(appointments: _appointments);
      case 3:
        return const SettingsContent();
      case 4:
        return const LabOrdersContent();
      default:
        return DashboardContent(profileMenuBuilder: _buildProfileMenu);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 800) {
            return buildMobileLayout();
          } else {
            return buildDesktopLayout();
          }
        },
      ),
    );
  }

  Widget buildMobileLayout() {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(icon: const Icon(Icons.email_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          const SizedBox(width: 8),
          _buildProfileMenu(),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF4796FF)),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ..._buildMobileNavItems(),
          ],
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget buildDesktopLayout() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onNavItemSelected,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF4796FF).withAlpha(51),
          extended: true,
          minExtendedWidth: 180,
          destinations: _buildDesktopNavDestinations(),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  List<Widget> _buildMobileNavItems() {
    return _navDestinationsData.asMap().entries.map((entry) {
      int idx = entry.key;
      var dest = entry.value;
      return ListTile(
        leading: Icon(dest['icon'] as IconData),
        title: Text(dest['label'] as String),
        selected: _selectedIndex == idx,
        onTap: () {
          Navigator.pop(context);
          _onNavItemSelected(idx);
        },
      );
    }).toList();
  }

  List<NavigationRailDestination> _buildDesktopNavDestinations() {
    return _navDestinationsData.map((dest) {
      return NavigationRailDestination(
        icon: Icon(dest['icon'] as IconData),
        selectedIcon: Icon(dest['selectedIcon'] as IconData, color: const Color(0xFF4796FF)),
        label: Text(dest['label'] as String),
      );
    }).toList();
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      icon: const CircleAvatar(
        radius: 18,
        child: Icon(Icons.person, size: 22),
      ),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'profile',
          child: Text('View Profile'),
        ),
        const PopupMenuItem<String>(
          value: 'settings',
          child: Text('Settings'),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Text('Logout'),
          onTap: () => _logout(),
        ),
      ],
    );
  }
}

// New Dashboard Content Widget
class DashboardContent extends StatelessWidget {
  final Widget Function() profileMenuBuilder;
  const DashboardContent({super.key, required this.profileMenuBuilder});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 800;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) ...[
            _buildHeader(context, profileMenuBuilder),
            const SizedBox(height: 24),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1100) {
                return _buildMobileAndTabletLayout();
              } else {
                return _buildDesktopLayout();
              }
            },
          ),
        ],
      ),
    );
  }

  // ***** FIX: DESKTOP LAYOUT *****
  // This layout uses fixed heights and calls the DESKTOP versions of the card builders.
  Widget _buildDesktopLayout() {
    const spacing = SizedBox(height: 24);
    const hSpacing = SizedBox(width: 24);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildSummaryCard(icon: Icons.people_outline, title: "Total Patient", value: "2000+", subtitle: "Till Today")),
            hSpacing,
            Expanded(child: _buildSummaryCard(icon: Icons.local_hospital_outlined, title: "Today Patient", value: "068", subtitle: "21 Dec-2021")),
            hSpacing,
            Expanded(child: _buildSummaryCard(icon: Icons.access_time, title: "Today Appointments", value: "085", subtitle: "21 Dec-2021")),
          ],
        ),
        spacing,
        SizedBox(
          height: 350,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildDesktopPatientSummaryChart()),
              hSpacing,
              Expanded(child: _buildDesktopTodayAppointmentList()),
              hSpacing,
              Expanded(child: _buildDesktopNextPatientDetails()),
            ],
          ),
        ),
        spacing,
        SizedBox(
          height: 300,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildDesktopPatientsReview()),
              hSpacing,
              Expanded(child: _buildDesktopAppointmentRequestList()),
              hSpacing,
              Expanded(child: _buildDesktopCalendar()),
            ],
          ),
        ),
      ],
    );
  }

  // ***** FIX: MOBILE LAYOUT *****
  // This layout uses a Wrap and calls the MOBILE versions of the card builders.
  Widget _buildMobileAndTabletLayout() {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: [
        _buildSummaryCard(icon: Icons.people_outline, title: "Total Patient", value: "2000+", subtitle: "Till Today"),
        _buildSummaryCard(icon: Icons.local_hospital_outlined, title: "Today Patient", value: "068", subtitle: "21 Dec-2021"),
        _buildSummaryCard(icon: Icons.access_time, title: "Today Appointments", value: "085", subtitle: "21 Dec-2021"),
        _buildMobilePatientSummaryChart(),
        _buildMobileTodayAppointmentList(),
        _buildMobileNextPatientDetails(),
        _buildMobilePatientsReview(),
        _buildMobileAppointmentRequestList(),
        _buildMobileCalendar(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Widget Function() profileMenuBuilder) {
    return Row(
      children: [
        Text(
          "Dashboard",
          style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(icon: const Icon(Icons.email_outlined), onPressed: () {}),
        IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        const SizedBox(width: 16),
        SizedBox(
          width: 200,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        const SizedBox(width: 16),
        profileMenuBuilder(),
      ],
    );
  }

  // --- UNIVERSAL CARD WIDGETS (Work in both layouts) ---
  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(minHeight: 115),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF4796FF).withAlpha(26),
            child: Icon(icon, color: const Color(0xFF4796FF), size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: GoogleFonts.nunito(color: Colors.grey[600]), overflow: TextOverflow.ellipsis),
                Text(value, style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(subtitle, style: GoogleFonts.nunito(color: Colors.grey[600]), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title1, String value1, String title2, String value2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title1, style: GoogleFonts.nunito(color: Colors.grey)),
                Text(value1, style: GoogleFonts.nunito(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title2, style: GoogleFonts.nunito(color: Colors.grey)),
                Text(value2, style: GoogleFonts.nunito(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: GoogleFonts.nunito())),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: color.withAlpha(51),
              color: color,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestTile(String name, String reason) {
    return Row(
      children: [
        const CircleAvatar(radius: 20, child: Icon(Icons.person)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.nunito(fontWeight: FontWeight.w600)),
              Text(reason, style: GoogleFonts.nunito(color: Colors.grey)),
            ],
          ),
        ),
        const Icon(Icons.check_circle, color: Colors.green),
        const SizedBox(width: 8),
        const Icon(Icons.cancel, color: Colors.red),
        const SizedBox(width: 8),
        const Icon(Icons.chat_bubble, color: Colors.blue),
      ],
    );
  }

  // --- DESKTOP-ONLY CARD BUILDERS (Use Expanded/Spacer) ---
  Widget _buildDesktopPatientSummaryChart() {
    final Map<String, double> dataMap = {"New Patients": 25, "Old Patients": 45, "Total Patients": 30};
    final colorList = <Color>[Colors.lightBlue.shade200, Colors.orange.shade400, Colors.blue.shade800];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Patients Summary December 2021", style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                dataMap: dataMap,
                chartType: ChartType.ring,
                chartRadius: 120,
                ringStrokeWidth: 40,
                colorList: colorList,
                legendOptions: const LegendOptions(showLegends: true, legendPosition: LegendPosition.right),
                chartValuesOptions: const ChartValuesOptions(showChartValues: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTodayAppointmentList() {
    final appointments = [
      {'name': 'M.J. Mical', 'diagnosis': 'Health Checkup', 'time': 'On Going'},
      {'name': 'Sanath Deo', 'diagnosis': 'Health Checkup', 'time': '12:30 PM'},
      {'name': 'Loeara Phanj', 'diagnosis': 'Report', 'time': '01:00 PM'},
      {'name': 'Komola Haris', 'diagnosis': 'Common Cold', 'time': '01:30 PM'},
    ];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Today Appointment", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: appointments.map((appt) => _buildRequestTile(appt['name']!, appt['diagnosis']!)).toList(),
              ),
            ),
            Center(child: Text("See All", style: GoogleFonts.nunito(color: const Color(0xFF4796FF)))),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNextPatientDetails() => _buildMobileNextPatientDetails();

  Widget _buildDesktopPatientsReview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Patients Review", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 18)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildReviewBar("Excellent", 0.8, Colors.blue),
                  _buildReviewBar("Great", 0.6, Colors.green),
                  _buildReviewBar("Good", 0.4, Colors.orange),
                  _buildReviewBar("Average", 0.2, Colors.teal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopAppointmentRequestList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Appointment Request", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 18)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRequestTile("Maria Sarafat", "Cold"),
                  _buildRequestTile("Jhon Deo", "Over sweating"),
                ],
              ),
            ),
            Center(child: Text("See All", style: GoogleFonts.nunito(color: const Color(0xFF4796FF)))),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopCalendar() => _buildMobileCalendar();

  // --- MOBILE-ONLY CARD BUILDERS (Use flexible layouts, no vertical Expanded/Spacer) ---
  Widget _buildMobilePatientSummaryChart() {
    final Map<String, double> dataMap = {"New Patients": 25, "Old Patients": 45, "Total Patients": 30};
    final colorList = <Color>[Colors.lightBlue.shade200, Colors.orange.shade400, Colors.blue.shade800];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Patients Summary December 2021", style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              chartRadius: 120,
              ringStrokeWidth: 40,
              colorList: colorList,
              legendOptions: const LegendOptions(showLegends: true, legendPosition: LegendPosition.right),
              chartValuesOptions: const ChartValuesOptions(showChartValues: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTodayAppointmentList() {
    final appointments = [
      {'name': 'M.J. Mical', 'diagnosis': 'Health Checkup', 'time': 'On Going'},
      {'name': 'Sanath Deo', 'diagnosis': 'Health Checkup', 'time': '12:30 PM'},
      {'name': 'Loeara Phanj', 'diagnosis': 'Report', 'time': '01:00 PM'},
      {'name': 'Komola Haris', 'diagnosis': 'Common Cold', 'time': '01:30 PM'},
    ];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Today Appointment", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ...appointments.map((appt) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildRequestTile(appt['name']!, appt['diagnosis']!),
            )).toList(),
            Center(child: Text("See All", style: GoogleFonts.nunito(color: const Color(0xFF4796FF)))),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNextPatientDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Next Patient Details", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const CircleAvatar(radius: 25, child: Icon(Icons.person)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sanath Deo", style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                        Text("Health Checkup", style: GoogleFonts.nunito(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Patient ID", style: GoogleFonts.nunito(color: Colors.grey)),
                      Text("0220092020005", style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const Divider(height: 32),
              _buildDetailRow("D.O.B", "15 January 1989", "Sex", "Male"),
              _buildDetailRow("Weight", "59 Kg", "Height", "172 cm"),
              _buildDetailRow("Last Appointment", "15 Dec - 2021", "Reg. Date", "10 Dec 2021"),
              const SizedBox(height: 16),
              Text("Patient History", style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Wrap(
                spacing: 8.0,
                children: [
                  Chip(label: Text("Asthma"), backgroundColor: Color(0xFFFFF2D8)),
                  Chip(label: Text("Hypertension"), backgroundColor: Color(0xFFE3F2FD)),
                  Chip(label: Text("Fever"), backgroundColor: Color(0xFFFFEBEE)),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call_outlined),
                    label: const Text("(308) 555-0102"),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.description_outlined),
                    label: const Text("Document"),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text("Chat"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobilePatientsReview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Patients Review", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            _buildReviewBar("Excellent", 0.8, Colors.blue),
            _buildReviewBar("Great", 0.6, Colors.green),
            _buildReviewBar("Good", 0.4, Colors.orange),
            _buildReviewBar("Average", 0.2, Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileAppointmentRequestList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Appointment Request", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            _buildRequestTile("Maria Sarafat", "Cold"),
            const SizedBox(height: 16),
            _buildRequestTile("Jhon Deo", "Over sweating"),
            const SizedBox(height: 16),
            Center(child: Text("See All", style: GoogleFonts.nunito(color: const Color(0xFF4796FF)))),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileCalendar() {
    final today = 21;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Calendar", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("December - 2021", style: GoogleFonts.nunito(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ["Sa", "Su", "Mo", "Tu", "We", "Th", "Fr"]
                  .map((day) => Text(day, style: GoogleFonts.nunito(fontWeight: FontWeight.bold)))
                  .toList(),
            ),
            const Divider(),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: 21,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final List<int> calendarDays = [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 01, 02, 03, 04, 05, 06, 07];
                int day = calendarDays[index];
                bool isToday = day == today;
                return Container(
                  alignment: Alignment.center,
                  decoration: isToday ? const BoxDecoration(color: Color(0xFF4796FF), shape: BoxShape.circle) : null,
                  child: Text("$day", style: GoogleFonts.nunito(color: isToday ? Colors.white : Colors.black)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- Placeholder Content Widgets and other classes remain the same ---
class PatientSearchContent extends StatelessWidget {
  final List<Map<String, dynamic>> patients;
  const PatientSearchContent({super.key, required this.patients});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Patient Search', style: GoogleFonts.nunito(fontSize: 24)));
  }
}

class AppointmentsContent extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;
  const AppointmentsContent({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Appointments', style: GoogleFonts.nunito(fontSize: 24)));
  }
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Settings', style: GoogleFonts.nunito(fontSize: 24)));
  }
}

class LabOrdersContent extends StatelessWidget {
  const LabOrdersContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Lab Orders', style: GoogleFonts.nunito(fontSize: 24)));
  }
}

class PatientDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> patient;
  final List<Map<String, dynamic>> patients;
  final List<Map<String, dynamic>> appointments;
  final bool emergencyOverride = false;

  const PatientDetailsScreen({
    super.key,
    required this.patient,
    required this.patients,
    required this.appointments,
  });

  bool _isAuthorizedPatient() {
    return patients.any((p) => p['id'] == patient['id']);
  }

  bool _isActiveConsultation() {
    final now = DateTime.now();
    return appointments.any((appt) =>
        appt['patientName'] == patient['name'] &&
        appt['status'] == 'Active' &&
        appt['time'].isBefore(now.add(const Duration(hours: 1))) &&
        appt['time'].isAfter(now.subtract(const Duration(hours: 1))));
  }

  bool _isWithinHistoricalLimit(DateTime date) {
    final limit = DateTime.now().subtract(const Duration(days: 365 * 2));
    return date.isAfter(limit);
  }

  Map<String, dynamic> _getPatientData() {
    return {
      'prescriptions': ['Amlodipine 5mg - 2025-06-01', 'Lisinopril 10mg - 2025-05-15'],
      'testResults': ['Blood Pressure: 130/85 mmHg - 2025-06-03', 'Cholesterol: 200 mg/dL - 2025-05-20'],
      'diagnoses': ['Hypertension - 2025-06-03'],
      'allergies': ['Penicillin'],
      'chronicConditions': ['Hypertension'],
      'visitHistory': [
        {'date': DateTime(2025, 6, 3), 'notes': 'Routine checkup'},
        {'date': DateTime(2025, 5, 15), 'notes': 'Initial diagnosis'},
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthorizedPatient() && !emergencyOverride) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 76, 175, 80),
          title: const Text(
            'Access Denied',
            style: TextStyle(color: Colors.white, fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: Text(
            'You do not have access to this patient\'s records.',
            style: TextStyle(fontFamily: 'Nunito'),
          ),
        ),
      );
    }

    final patientData = _getPatientData();
    final isActive = _isActiveConsultation();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 175, 80),
        title: Text(
          'Patient Details: ${patient['name']}',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Patient Details",
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 76, 175, 80),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(51),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 76, 175, 80),
                    ),
                    title: const Text(
                      "Name",
                      style: TextStyle(fontFamily: 'Nunito'),
                    ),
                    subtitle: Text(
                      patient['name'],
                      style: GoogleFonts.nunito(),
                    ),
                  ),
                  if (isActive || emergencyOverride)
                    ...[
                      ListTile(
                        leading: const Icon(
                          Icons.medication,
                          color: Color.fromARGB(255, 76, 175, 80),
                        ),
                        title: const Text(
                          "Past Prescriptions",
                          style: TextStyle(fontFamily: 'Nunito'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: patientData['prescriptions']
                              .where((p) => _isWithinHistoricalLimit(DateFormat('yyyy-MM-dd').parse(p.split(' - ')[1])))
                              .map<Widget>((p) => Text(p, style: GoogleFonts.nunito()))
                              .toList(),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.analytics,
                          color: Color.fromARGB(255, 76, 175, 80),
                        ),
                        title: const Text(
                          "Test Results",
                          style: TextStyle(fontFamily: 'Nunito'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: patientData['testResults']
                              .where((t) => _isWithinHistoricalLimit(DateFormat('yyyy-MM-dd').parse(t.split(' - ')[1])))
                              .map<Widget>((t) => Text(t, style: GoogleFonts.nunito()))
                              .toList(),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.local_hospital,
                          color: Color.fromARGB(255, 76, 175, 80),
                        ),
                        title: const Text(
                          "Diagnoses & Allergies",
                          style: TextStyle(fontFamily: 'Nunito'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ...patientData['diagnoses']
                                .where((d) => _isWithinHistoricalLimit(DateFormat('yyyy-MM-dd').parse(d.split(' - ')[1])))
                                .map<Widget>((d) => Text(d, style: GoogleFonts.nunito())),
                            if (patientData['allergies'].isNotEmpty)
                              Text('Allergies: ${patientData['allergies'].join(', ')}', style: GoogleFonts.nunito()),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(255, 76, 175, 80),
                        ),
                        title: const Text(
                          "Visit History",
                          style: TextStyle(fontFamily: 'Nunito'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: patientData['visitHistory']
                              .where((v) => _isWithinHistoricalLimit(v['date']))
                              .map<Widget>((v) => Text('${DateFormat('dd/MM/yyyy').format(v['date'])} - ${v['notes']}', style: GoogleFonts.nunito()))
                              .toList(),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.health_and_safety,
                          color: Color.fromARGB(255, 76, 175, 80),
                        ),
                        title: const Text(
                          "Chronic Conditions",
                          style: TextStyle(fontFamily: 'Nunito'),
                        ),
                        subtitle: Text(
                          patientData['chronicConditions'].join(', '),
                          style: GoogleFonts.nunito(),
                        ),
                      ),
                    ],
                  if (!isActive && !emergencyOverride)
                    const ListTile(
                      title: Text(
                        'Limited access outside active consultation. Request emergency override if needed.',
                        style: TextStyle(fontFamily: 'Nunito', color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> patients;

  DoctorSearchDelegate({required this.patients});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = patients
        .where((patient) => patient['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final patient = results[index];
        return ListTile(
          leading: const Icon(
            Icons.person,
            color: Color.fromARGB(255, 76, 175, 80),
          ),
          title: Text(
            patient['name'],
            style: GoogleFonts.nunito(),
          ),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientDetailsScreen(
                  patient: patient,
                  patients: patients,
                  appointments: const [],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = patients
        .where((patient) => patient['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final patient = suggestions[index];
        return ListTile(
          leading: const Icon(
            Icons.person,
            color: Color.fromARGB(255, 76, 175, 80),
          ),
          title: Text(
            patient['name'],
            style: GoogleFonts.nunito(),
          ),
          onTap: () {
            query = patient['name'];
            showResults(context);
          },
        );
      },
    );
  }
}