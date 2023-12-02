import 'dart:typed_data';

import 'package:emartsystem/Model/UserLoginModel.dart';
import 'package:emartsystem/Pages/UserSignUp.dart';
import 'package:flutter/material.dart';

import 'Admin.dart';
import 'DashboardCustomer.dart';
import 'HomeCustomer.dart';
import 'HomeSeller.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserLoginPage(),
    );
  }
}

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Log In",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.deepPurple,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String username = usernameController.text;
                    String password = passwordController.text;

                    // Validate that the username and password are not empty
                    if (username.isEmpty || password.isEmpty) {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter both username and password.'),
                        ),
                      );
                      return;
                    }

                    // Create an instance of UserLoginModel with only username and password
                    UserLoginModel user = UserLoginModel(
                      0,
                      0,
                      username,
                      password,
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                    );

                    // Call the saveUser method
                    bool loginSuccessful = await user.saveUser();
                    setState(() {
                      if (loginSuccessful) {
                        print(user.username);
                        if (user.adminId != 0) {
                          // Navigate to AdminPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminPage(),
                            ),
                          );
                        } else if (user.sellerAccount == 'true') {
                          print(user.sellerAccount);
                          // Navigate to HomeSellerPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeSellerPage(user: user),
                            ),
                          );
                        } else {
                          // Navigate to HomeCustomerPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeCustomerPage(user: user),
                            ),
                          );
                        }
                      } else {
                        // Handle unsuccessful login
                        // You can show an error message or take other actions
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid username or password. Please try again.'),
                          ),
                        );
                      }
                    });
                    print(user.userId);
                    print(user.image);
                  },
                  child: Text('Log In'),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Handle "Forgot Password" logic here
                  },
                  child: Text('Forgot Password?'),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Handle "Create Account" logic here
                    // After clicking, navigate to SignUpPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserSignUpPage()),
                    );
                  },
                  child: Text('Create Account'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
