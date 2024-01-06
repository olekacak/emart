import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../Model/User/UserSignUpModel.dart';
import 'UserLogin.dart';

class UserSignUpPage extends StatefulWidget {
  UserSignUpPage({Key? key}) : super(key: key);

  @override
  _UserSignUpPageState createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();
  final imageController = TextEditingController();
  final dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? errorText;
  String? confirmErrorText;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  // Validate password
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

  // Method to pick an image from the gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(imageBytes);

      print("Picked image base64: $base64String"); // Debugging

      setState(() {
        imageController.text = base64String;
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1954),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(selected);
      });
    }
  }


  Widget buildAvatarSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight, // Aligns the icon to the bottom right corner
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: imageController.text.isNotEmpty
                  ? MemoryImage(base64Decode(imageController.text) as Uint8List)
                  : AssetImage('assets/logo.png') as ImageProvider, // Explicitly cast AssetImage
            ),
            Container(
              width: 40, // Adjust the size of the circle as needed
              height: 40, // Adjust the size of the circle as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purpleAccent, // Change the color as needed
              ),
              child: IconButton(
                onPressed: pickImage,
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white, // Change the icon color as needed
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
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
          backgroundColor: Colors.purple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              children: [
                buildAvatarSection(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Create username',
                    // Normal border
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    // Border when TextField is focused
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    // Border when TextField is enabled but not focused
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter minimum 8 characters',
                    focusedBorder: OutlineInputBorder(  // Changed to OutlineInputBorder
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: you can adjust the border radius
                    ),
                    enabledBorder: OutlineInputBorder(  // Added enabledBorder for a consistent look
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: adjust border radius
                    ),
                    errorBorder: OutlineInputBorder(  // Added errorBorder to define the border when an error occurs
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: adjust border radius
                    ),
                    focusedErrorBorder: OutlineInputBorder(  // Added focusedErrorBorder
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: adjust border radius
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,  // Different controller for confirm password
                  obscureText: !confirmPasswordVisible, // Use the state variable for toggling text visibility
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(5.0),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    focusedBorder: OutlineInputBorder(  // Changed to OutlineInputBorder
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: you can adjust the border radius
                    ),
                    enabledBorder: OutlineInputBorder(  // Added enabledBorder for a consistent look
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: adjust border radius
                    ),
                    labelStyle: TextStyle(color: Colors.purple),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'email@gmail.com',
                    focusedBorder: OutlineInputBorder(  // Changed to OutlineInputBorder
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: adjust border radius
                    ),
                    enabledBorder: OutlineInputBorder(  // Added enabledBorder for a consistent look
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: adjust border radius
                    ),
                    labelStyle: TextStyle(color: Colors.purple),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Optional: Add email validation logic here if needed
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneNoController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    focusedBorder: OutlineInputBorder(  // Changed to OutlineInputBorder
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: you can adjust the border radius
                    ),
                    enabledBorder: OutlineInputBorder(  // Added enabledBorder for a consistent look
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: adjust border radius
                    ),
                    labelStyle: TextStyle(color: Colors.purple),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter your address',
                    focusedBorder: OutlineInputBorder(  // Changed to OutlineInputBorder
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: you can adjust the border radius
                    ),
                    enabledBorder: OutlineInputBorder(  // Added enabledBorder for a consistent look
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: adjust border radius
                    ),
                    labelStyle: TextStyle(color: Colors.purple),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    // Optional: Add additional validation logic here if needed
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    hintText: 'Date of Birth',
                    fillColor: Colors.purple,
                    filled: true,
                    suffixIcon: const Icon(Icons.calendar_month_outlined, color: Colors.white),
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(  // Changed to OutlineInputBorder
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(5.0),  // Optional: adjust border radius
                    ),
                    enabledBorder: OutlineInputBorder(  // Added enabledBorder for a consistent look
                      borderSide: BorderSide(color: Colors.purple.withOpacity(0.5)), // Semi-transparent purple
                      borderRadius: BorderRadius.circular(5.0),  // Optional: adjust border radius
                    ),
                  ),
                  readOnly: true, // Prevents keyboard from appearing
                  onTap: _selectDate, // Opens date picker when the field is tapped
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: null,
                  hint: Text('Gender',style: TextStyle(color: Colors.purple)),
                  onChanged: (String? newValue) {
                    setState(() {
                      genderController.text = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.purple), // Set text color to purple
                        ),
                      );
                    },
                  ).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Trigger form validation
                    if (_formKey.currentState!.validate()) {
                      // Get values from controllers
                      String username = usernameController.text;
                      String password = passwordController.text;
                      String name = nameController.text;
                      String email = emailController.text;
                      String phoneNo = phoneNoController.text;
                      String address = addressController.text;
                      String birthDate = '${dateController.text}';
                      String gender = genderController.text;
                      String image = imageController.text;
                      String? passwordError =
                      validatePassword(passwordController.text);

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
                        status: '',
                        sellerAccount: '',
                        roleId: '',
                        image: image,
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
                                content:
                                Text('You have successfully signed up.'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      // Navigate to the login page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserLoginPage()),
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
                        // Print the error details to the console
                        print('Error during sign up: $error');

                        // Display a snackbar with the error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Error during sign up. Please try again.'),
                            backgroundColor:
                            Colors.red, // Set snackbar background color to red
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
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
                            color: Colors.purple,
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
      ),
    );
  }
}
