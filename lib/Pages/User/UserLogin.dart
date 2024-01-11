import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emartsystem/Model/User/UserLoginModel.dart';
import 'package:emartsystem/Pages/User/UserSignUp.dart';
import 'package:flutter/material.dart';

import 'Admin.dart';
import '../HomeCustomer.dart';
import '../HomeSeller.dart';
import 'ForgotPassword.dart';

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
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Welcome Back",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Set to false to remove the back button
        backgroundColor: Colors.purple, // Set the background color to purple
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
                    prefixIcon: Icon(Icons.person,
                      color: Colors.purple,
                    ),
                    border: OutlineInputBorder(), // Normal border
                    focusedBorder: OutlineInputBorder( // Border when TextField is focused
                      borderSide: BorderSide(color: Colors.purple, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder( // Border when TextField is enabled but not focused
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder( // Border when TextField has an error
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                    labelStyle: TextStyle(color: Colors.purple),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible, // Toggle password visibility
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock,
                      color: Colors.purple,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.purple,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(), // Normal border
                    focusedBorder: OutlineInputBorder( // Border when TextField is focused
                      borderSide: BorderSide(color: Colors.purple, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder( // Border when TextField is enabled but not focused
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder( // Border when TextField has an error
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                    labelStyle: TextStyle(color: Colors.purple),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.purple), // Set text color to purple
                    ),
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
                      } else if (userId! > 0) {
                        print("Seller Account Value: ${user.sellerAccount}");

                        if (user.sellerAccount == "true") {
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
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Create Account',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to the SignUpPage when 'Create Account' is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserSignUpPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
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
