import 'package:flutter/material.dart';
import 'package:emartsystem/Home.dart';
import 'package:emartsystem/SignUp.dart';
import '../Model/CustomerLoginModel.dart';
import '../Controller/CustomerLoginController.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomerLoginPage(),
    );
  }
}

class CustomerLoginPage extends StatelessWidget {

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
                  onPressed: () {
                    String username = usernameController.text;
                    String password = passwordController.text;

                    // Create an instance of CustomerLoginModel
                    CustomerLoginController customer = CustomerLoginController(
                        path: "/api/workshop2/customer_login.php");

                    // Perform the login using the provided username and password
                    customer.login(username, password).then((bool loginResult) {
                      if (loginResult) {
                        // If login is successful, navigate to the daily expense screen with the username
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Homepage(username: username),
                          ),
                        );
                      } else {
                        // If login is unsuccessful, show an error message
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Login Failed'),
                              content: const Text('Invalid username or password.'),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
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
                      MaterialPageRoute(builder: (context) => SignUpPage()),
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
