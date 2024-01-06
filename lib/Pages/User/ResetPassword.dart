import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../Model/User/UserLoginModel.dart';
import 'UserLogin.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  ResetPasswordPage({required this.email});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  UserLoginModel? user;

  // User data variables
  String username = '';
  String userImage = ''; // URL or path to the image
  String? errorText;
  String? confirmErrorText;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Check for a mix of special characters, numbers, and uppercase and lowercase letters
    RegExp regex = RegExp(
        r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!regex.hasMatch(password)) {
      return '''
    Minimum length of 8 characters.
    At least one uppercase letter.
    At least one lowercase letter.
    At least one digit.
    At least one special character (!@#\$&*~).
    ''';
    }

    return null; // Return null if the password is valid
  }


  String? validateConfirmPassword(String confirmPassword) {
    if (confirmPassword != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void resetPassword() async {
    String newPassword = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Basic validation for demonstration purposes
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Update the user's password in the database
    UserLoginModel? user = await UserLoginModel.getUserByEmail(widget.email);
    if (user != null) {
      user.password = newPassword; // Set the new password
      bool updateSuccess = await user.updateUser(); // Update user in database

      if (updateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UserLoginPage(),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update password')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    var fetchedUser = await UserLoginModel.getUserByEmail(widget.email);
    if (fetchedUser != null) {
      setState(() {
        user = fetchedUser; // Set the user property with fetched data
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
          backgroundColor: Colors.purple
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView to avoid overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user?.image != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ClipOval(
                  child: Image.memory(
                    base64Decode(user!.image!),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Text(user?.username ?? 'Username not available',
                style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,)
            ),
            SizedBox(width: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  hintText: 'Enter minimum 8 characters',
                  border: OutlineInputBorder(), // Add an outline border
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),
                  ),
                  errorText: errorText,
                  errorMaxLines: 5,
                  labelStyle: TextStyle(color: Colors.purple),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Change the icon based on the state of passwordVisible
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible; // Toggle the state
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    errorText = validatePassword(value);
                  });
                },
              ),
            ),
            SizedBox(width: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: confirmPasswordController,
                obscureText: !confirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  hintText: 'Re-enter your password',
                  border: OutlineInputBorder(), // Add an outline border
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),
                  ),
                  errorText: confirmErrorText,  // Different error text variable for confirm password
                  errorMaxLines: 5,
                  labelStyle: TextStyle(color: Colors.purple),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Change the icon based on the state of passwordVisible
                      confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      setState(() {
                        confirmPasswordVisible = !confirmPasswordVisible; // Toggle the state
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {  // Validation to check if passwords match
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    confirmErrorText = validateConfirmPassword(value);
                  });
                },
              ),
            ),
            SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: resetPassword,
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