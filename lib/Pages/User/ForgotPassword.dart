import 'package:flutter/material.dart';

import '../../Model/User/UserLoginModel.dart';
import 'ResetPassword.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(), // Add an outline border
                enabledBorder: OutlineInputBorder( // Border style when TextField is enabled
                  borderSide: BorderSide(color: Colors.purple, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder( // Border style when TextField is focused
                  borderSide: BorderSide(color: Colors.purple, width: 2.0),
                ),
                labelStyle: TextStyle(color: Colors.purple),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text;
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter your email.')),
                  );
                  return;
                }

                UserLoginModel? user = await UserLoginModel.getUserByEmail(email);

                if (user != null) {
                  // User exists, proceed to show the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Email Found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        content: Text('Email matched in our records.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ResetPasswordPage(email: email),
                              ));
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // User does not exist
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Email Not Found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('No email matched in our records.'),
                            SizedBox(height: 8), // Add some spacing
                            Text('Please try again.'),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK',
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Reset Password',
                style: TextStyle(
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}