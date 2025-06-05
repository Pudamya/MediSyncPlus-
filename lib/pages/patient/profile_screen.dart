import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  // Form data
  String _name = 'Priya Sharma';
  String _email = 'priya@example.com';
  String _phone = '+91 98765 43210';
  DateTime _dob = DateTime(1995, 3, 15); // Default DOB from hardcoded data
  String _address = '123, Green Lane, Mumbai, India';
  String _gender = 'Female';
  String _emergencyContact = '+91 91234 56789';
  String _insuranceProvider = 'MediCare Plus';
  String _policyNumber = 'MC123456789';
  String _preferredLanguage = 'English'; // Added for language management

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    }
  }

  void _changePassword() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    // Hardcoded current password for simulation
    const String hardcodedPassword = 'password123';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.nunito()),
          ),
          TextButton(
            onPressed: () {
              if (currentPasswordController.text != hardcodedPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect current password')),
                );
                return;
              }
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New passwords do not match')),
                );
                return;
              }
              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New password must be at least 6 characters')),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully!')),
              );
            },
            child: Text('Save', style: GoogleFonts.nunito()),
          ),
        ],
      ),
    );
  }

  void _manageLanguages() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage Languages', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
        content: DropdownButton<String>(
          value: _preferredLanguage,
          items: const [
            DropdownMenuItem(value: 'English', child: Text('English')),
            DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
            DropdownMenuItem(value: 'Tamil', child: Text('Tamil')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _preferredLanguage = value;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language updated successfully!')),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 175, 80),
        title: Text(
          'Profile',
          style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color.fromARGB(255, 76, 175, 80),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color.fromARGB(255, 76, 175, 80),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _email,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Edit/Save Button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                    if (!_isEditing) _saveForm();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 76, 175, 80)),
                  child: Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: GoogleFonts.nunito(color: Colors.white),
                  ),
                ),
              ),
            ),
            // User Information Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'User Information',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 76, 175, 80),
                ),
              ),
            ),
            _buildInfoCard(
              context,
              children: [
                _buildTextField(
                  label: 'Name',
                  initialValue: _name,
                  onSaved: (value) => _name = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your name';
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Email',
                  initialValue: _email,
                  onSaved: (value) => _email = value!,
                  validator: (value) {
                    if (value == null || !value.contains('@')) return 'Please enter a valid email';
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Phone Number',
                  initialValue: _phone,
                  onSaved: (value) => _phone = value!,
                  validator: (value) {
                    if (value == null || value.length < 10) return 'Please enter a valid phone number';
                    return null;
                  },
                ),
                _buildDateField(
                  label: 'Date of Birth',
                  selectedDate: _dob,
                  onChanged: (value) => setState(() => _dob = value),
                ),
                _buildTextField(
                  label: 'Address',
                  initialValue: _address,
                  onSaved: (value) => _address = value!,
                ),
              ],
            ),
            // Personal Details Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Personal Details',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 76, 175, 80),
                ),
              ),
            ),
            _buildInfoCard(
              context,
              children: [
                _buildDropdownField(
                  label: 'Gender',
                  value: _gender,
                  items: const ['Female', 'Male', 'Other'],
                  onChanged: (value) => setState(() => _gender = value!),
                ),
                _buildTextField(
                  label: 'Emergency Contact',
                  initialValue: _emergencyContact,
                  onSaved: (value) => _emergencyContact = value!,
                  validator: (value) {
                    if (value != null && value.length < 10) return 'Please enter a valid phone number';
                    return null;
                  },
                ),
              ],
            ),
            // Insurance Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Insurance Info',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 76, 175, 80),
                ),
              ),
            ),
            _buildInfoCard(
              context,
              children: [
                _buildDropdownField(
                  label: 'Insurance Provider',
                  value: _insuranceProvider,
                  items: const ['MediCare Plus', 'HealthGuard', 'InsureLife'],
                  onChanged: (value) => setState(() => _insuranceProvider = value!),
                ),
                _buildTextField(
                  label: 'Policy Number',
                  initialValue: _policyNumber,
                  onSaved: (value) => _policyNumber = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a policy number';
                    return null;
                  },
                ),
              ],
            ),
            // Settings & Security Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Settings & Security',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 76, 175, 80),
                ),
              ),
            ),
            _buildInfoCard(
              context,
              children: [
                const Divider(height: 1, color: Colors.grey),
                _buildSettingsItem(
                  context,
                  icon: Icons.lock,
                  title: 'Change Password',
                  onTap: _changePassword,
                ),
                const Divider(height: 1, color: Colors.grey),
                _buildSettingsItem(
                  context,
                  icon: Icons.language,
                  title: 'Manage Languages',
                  onTap: _manageLanguages,
                ),
                const Divider(height: 1, color: Colors.grey),
                _buildSettingsItem(
                  context,
                  icon: Icons.devices,
                  title: 'Device Access Logs',
                  onTap: () {
                    // TODO: Implement Device Access Logs
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                _buildSettingsItem(
                  context,
                  icon: Icons.download,
                  title: 'Export Health Record (ZIP/PDF)',
                  onTap: () {
                    // TODO: Implement Export Health Record
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                _buildSettingsItem(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    // TODO: Implement Logout
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required List<Widget> children}) {
    return Container(
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
        children: children,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: _isEditing ? initialValue : null,
        enabled: _isEditing,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime selectedDate,
    required ValueChanged<DateTime> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          children: [
            Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: GoogleFonts.nunito(),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _isEditing
                  ? () async {
                      if (!mounted) return;
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && mounted) {
                        onChanged(picked);
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _isEditing ? value : null,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: GoogleFonts.nunito()),
              );
            }).toList(),
            onChanged: _isEditing ? onChanged : null,
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: const Color.fromARGB(255, 76, 175, 80)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
    ),
);
}
}
