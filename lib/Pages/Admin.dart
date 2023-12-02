import 'package:emartsystem/Pages/UserLogin.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Add any necessary variables or controllers here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add your admin-related widgets here
            Text(
              'Welcome to the Admin Page!',
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
              onPressed: () {
                // Handle "Create Account" logic here
                // After clicking, navigate to SignUpPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserLoginPage()),
                );
              },
              child: Text('Log out'),
            ),
            SizedBox(height: 16),
            // Add more widgets as needed
          ],
        ),
      ),
      // Add any other components, like a drawer or bottom navigation bar
    );
  }
}