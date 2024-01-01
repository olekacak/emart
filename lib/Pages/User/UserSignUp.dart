import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import '../../Model/UserSignUpModel.dart';
import 'UserLogin.dart';

class UserSignUpPage extends StatefulWidget {
  UserSignUpPage({Key? key}) : super(key: key);

  @override
  _UserSignUpPageState createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();
  final addressController = TextEditingController();
  final birthDateController = TextEditingController();
  final genderController = TextEditingController();

  String? errorText;

  // Validate password
  String? validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Check for a mix of special characters, numbers, and uppercase and lowercase letters
    RegExp regex = RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!regex.hasMatch(password)) {
      return '''
      Minimum length of 8 characters.
      At least one uppercase letter.
      At least one lowercase letter.
      At least one digit.
      At least one special character (!@#\$&*~).
      ''';
    }

    return ''; // Return null if the password is valid
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        birthDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

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
              Tooltip(
                message: validatePassword(passwordController.text) ?? '',
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter minimum 8 characters',
                    errorText: errorText,
                    errorMaxLines: 5,
                  ),
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
              TextField(
                controller: birthDateController,
                decoration: InputDecoration(
                  labelText: 'Birth Date',
                  hintText: 'Select your birth date',
                ),
                onTap: () {
                  _selectBirthDate(context);
                },
              ),
              DropdownButtonFormField<String>(
                value: null,
                hint: Text('Gender'),
                onChanged: (String? newValue) {
                  setState(() {
                    genderController.text = newValue!;
                  });
                },
                items: <String>['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
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
                  String birthDate = birthDateController.text;
                  String gender = genderController.text;

                  String? passwordError = validatePassword(passwordController.text);

                  // Create an instance of UserSignUpModel
                  UserSignUpModel user = UserSignUpModel(
                    username: username,
                    password: password,
                    name: name,
                    email: email,
                    phoneNo: phoneNo,
                    address: address,
                    birthDate: birthDate,
                    gender: gender,
                    sellerAccount: '',
                    status: '',
                    roleId: '',
                  );

                  if (passwordError != null && passwordError.isNotEmpty) {
                    // Display the password error
                    setState(() {
                      errorText = passwordError;
                    });
                    return;
                  }

                  try {
                    // Call the saveUserSignUp method to send data to the server
                    int signUpResult = await user.saveUserSignUp();

                    if (signUpResult == 0) {
                      // Successful signup
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Successful Sign Up'),
                            content: Text('You have successfully signed up.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  // Navigate to the login page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserLoginPage()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (signUpResult == 1) {
                      // Username already in use
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Username Exists'),
                            content: Text(
                                'The username already exists. Please choose another one.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (signUpResult == 2) {
                      // Email already in use
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Email Exists'),
                            content: Text(
                                'The email already exists. Please use another one.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Other errors
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Sign Up Failed'),
                            content:
                                Text('Failed to sign up. Please try again.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
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
                          title: Text('Server Error'),
                          content: Text(
                              'There was an error connecting to the server.'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
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
                child: Text('Sign Up'),
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
                              MaterialPageRoute(
                                  builder: (context) => UserLoginPage()),
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
