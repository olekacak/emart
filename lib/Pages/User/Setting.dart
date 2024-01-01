import 'package:flutter/material.dart';
import '../../Model/UserLoginModel.dart';
import 'DeleteAccount.dart';

class SettingPage extends StatefulWidget {
  final UserLoginModel user;

  SettingPage({required this.user, Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _notificationEnabled = true;
  int _selectedLanguage = 0;

  List<String> _languages = ['English', 'Spanish', 'French', 'German'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
        centerTitle: true,
        backgroundColor: Colors.purple, // Customize the color to match your theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // Navigate to the Delete Account page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteAccountPage(user: widget.user,)),
                );
              },
              child: Text(
                'Delete Account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            Text(
              'Language Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: _selectedLanguage,
              items: _languages.asMap().entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save settings logic
                _saveSettings();
              },
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAccount() {
    // Implement your delete account logic here
    print('Account deleted');
  }

  void _saveSettings() {
    // Implement your save settings logic here
    print('Settings saved');
  }
}
