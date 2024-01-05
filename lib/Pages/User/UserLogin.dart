import 'package:shared_preferences/shared_preferences.dart';
import 'package:emartsystem/Model/User/UserLoginModel.dart';
import 'package:emartsystem/Pages/User/UserSignUp.dart';
import 'package:flutter/material.dart';

import 'Admin.dart';
import '../HomeCustomer.dart';
import '../HomeSeller.dart';

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
            "Welcome Back",
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
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
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
                      -1,
                      -1,
                      -1,
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

                    bool loginSuccessful = await user.saveUser();

                    if (loginSuccessful) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      //await prefs.clear();

                      int? adminId = prefs.getInt('adminId');
                      int? userId = prefs.getInt('userId');

                      print("userId login pref ${userId}");

                      if (adminId != null && adminId > 0) {
                        // Navigate to AdminPage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminPage(),
                          ),
                        );
                      } else if (userId != null && userId > 0) {
                        if (user.sellerAccount != null) {
                          // Navigate to HomeSellerPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeSellerPage(),
                            ),
                          );
                        } else {
                          // Navigate to HomeCustomerPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeCustomerPage(),
                            ),
                          );
                        }
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