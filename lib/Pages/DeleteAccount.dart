import 'package:flutter/material.dart';

import '../Model/UserLoginModel.dart';
import 'UserLogin.dart';

class DeleteAccountPage extends StatefulWidget {
  final UserLoginModel user;
  DeleteAccountPage({required this.user, Key? key}) : super(key: key);
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _isAgreed = false;
  String _selectedReason = 'I no longer want to use eMart';
  TextEditingController _customReasonController = TextEditingController();

  @override
  void dispose() {
    _customReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'We regret your decision to leave, but please be aware that deleting your account is a permanent action and cannot be reversed.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Deletion Reason',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedReason,
                items: <String>[
                  'I no longer want to use eMart',
                  'I found an alternative platform',
                  'I am not satisfied with the service',
                  'Other reason',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedReason = value!;
                  });
                },
              ),
              if (_selectedReason == 'Other reason')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Enter your reason',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _customReasonController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isAgreed,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isAgreed = newValue!;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isAgreed = !_isAgreed;
                      }),
                      child: Text('I understand and would like to continue.'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Background color
                  ),
                  onPressed: _isAgreed ? _deleteAccount : null,
                  child: Text('Delete Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteAccount() async {
    if (!_isAgreed) {
      print('Please agree to delete your account.');
      return;
    }

    // If the reason is 'Other', capture the custom reason
    if (_selectedReason == 'Other reason') {
      String customReason = _customReasonController.text;
      print('Custom Reason: $customReason');
    }

    // Attempt to delete the user account regardless of the reason
    bool success = await widget.user.deleteUser();
    if (success) {
      print('Account deleted successfully');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UserLoginPage()),
            (route) => false,
      );
    } else {
      print('Failed to delete account');
      // Show error message to the user
    }
  }
}
