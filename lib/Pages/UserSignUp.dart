import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Model/UserSignUpModel.dart';
import 'UserLogin.dart';

class UserSignUpPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();
  final addressController = TextEditingController();
  final birthYearController = TextEditingController();
  final birthMonthController = TextEditingController();
  final birthDayController = TextEditingController();
  final genderController = TextEditingController();

  UserSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Icon(
                Icons.lock,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Create username',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter minimum 8 characters',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'email@gmail.com',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneNoController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter your address',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      hint: Text('Year'),
                      onChanged: (String? newValue) {
                        birthYearController.text = newValue!;
                      },
                      items: List.generate(30, (index) => (2023 - index).toString())
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      hint: Text('Month'),
                      onChanged: (String? newValue) {
                        birthMonthController.text = newValue!;
                      },
                      items: List.generate(12, (index) => (index + 1).toString())
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      hint: Text('Day'),
                      onChanged: (String? newValue) {
                        birthDayController.text = newValue!;
                      },
                      items: List.generate(31, (index) => (index + 1).toString())
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: null,
                hint: Text('Gender'),
                onChanged: (String? newValue) {
                  genderController.text = newValue!;
                },
                items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Get values from controllers
                  String username = usernameController.text;
                  String password = passwordController.text;
                  String name = nameController.text;
                  String email = emailController.text;
                  String phoneNo = phoneNoController.text;
                  String address = addressController.text;
                  String birthDate = '${birthYearController.text}-${birthMonthController.text}-${birthDayController.text}';
                  String gender = genderController.text;

                  // Create an instance of UserSignUpModel
                  UserSignUpModel userSignUpModel = UserSignUpModel(
                    username,
                    password,
                    name,
                    email,
                    phoneNo,
                    address,
                    birthDate,
                    gender,
                    '',
                    '',
                    '',
                  );

                  try {
                    // Call the saveUserSignUp method to send data to the server
                    bool signUpResult = await userSignUpModel.saveUserSignUp();

                    if (signUpResult) {
                      // If sign up is successful, show a success message
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Successful Sign Up'),
                            content: const Text('You have successfully signed up.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  // Navigate to the login page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UserLoginPage()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // If sign up fails, show an error message
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Sign Up Failed'),
                            content: const Text('Failed to sign up. Please try again.'),
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
                  } catch (error) {
                    // Handle server errors
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Server Error'),
                          content: const Text('There was an error connecting to the server.'),
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
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to the LoginPage when 'Log in' is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserLoginPage()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
