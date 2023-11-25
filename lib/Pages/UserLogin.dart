import 'package:emartsystem/Model/UserLoginModel.dart';
import 'package:flutter/material.dart';

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

class UserLoginPage extends StatelessWidget {
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

                    // Create an instance of UserLoginModel with all required arguments
                    UserLoginModel user = UserLoginModel(
                      username,
                      password,
                      'name',
                      'email',
                      'phoneNo',
                      'address',
                      'sellerAccount',
                      'status',
                      'roleId',
                    );

                    // Call the saveUser method
                    bool loginSuccessful = await user.saveUser();

                    if (loginSuccessful) {
                      // Check if the user is a seller based on the role or any other criteria
                      if (user.sellerAccount == 'true') {
                        // Navigate to HomeSellerPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeSellerPage(),
                          ),
                        );
                      } else {
                        // Navigate to HomeCustomerPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeCustomerPage(),
                          ),
                        );
                      }
                    } else {
                      // Handle unsuccessful login
                      // You can show an error message or take other actions
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
                      MaterialPageRoute(builder: (context) => DashboardCustomerPage()),
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
