import 'package:flutter/material.dart';
import '../Model/UserLoginModel.dart';

class EditProfilePage extends StatefulWidget {
  final UserLoginModel user;

  const EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;
  late TextEditingController _addressController;
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;

  // Check for changes method
  bool hasChanges() {
    return _nameController.text != widget.user.name ||
        _emailController.text != widget.user.email ||
        _phoneNoController.text != widget.user.phoneNo ||
        _addressController.text != widget.user.address ||
        _birthDateController.text != widget.user.birthDate ||
        _genderController.text != widget.user.gender;
  }

  // Method to update the user object with the latest values
  void updateUserObject() {
    widget.user.name = _nameController.text ?? '';
    widget.user.email = _emailController.text ?? '';
    widget.user.phoneNo = _phoneNoController.text ?? '';
    widget.user.address = _addressController.text ?? '';
    widget.user.birthDate = _birthDateController.text ?? '';
    widget.user.gender = _genderController.text ?? '';
  }


  @override
  void initState() {
    super.initState();

    // Initialize controllers with the current user data
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneNoController = TextEditingController(text: widget.user.phoneNo);
    _addressController = TextEditingController(text: widget.user.address);
    _birthDateController = TextEditingController(text: widget.user.birthDate);
    _genderController = TextEditingController(text: widget.user.gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              print('Save button pressed!');

              // Check for changes before making the update request
              if (hasChanges()) {
                print('Changes detected. Updating user...');

                // Update the user object with the latest values
                updateUserObject();

                // Save changes to the database
                print('Before updating user...');
                print('Request JSON: ${widget.user.toJson()}');

                bool success = await widget.user.updateUser();

                if (success) {
                  // Update the SnackBar content to show the success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profile updated successfully.'),
                    ),
                  );

                  // Show log to verify success message
                  print('After updating user, success: $success');

                  // Navigate back after showing the success message
                  Navigator.pop(context);
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update profile. Please try again.'),
                    ),
                  );
                }
              } else {
                // No changes, display a message or handle accordingly
                print('No changes detected. Update not performed.');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ... other widgets ...

            buildTextFormField(controller: _nameController, label: 'Name'),
            buildTextFormField(controller: _emailController, label: 'Email'),
            buildTextFormField(controller: _phoneNoController, label: 'Phone Number'),
            buildTextFormField(controller: _addressController, label: 'Address'),
            buildTextFormField(controller: _birthDateController, label: 'Birth Date'),
            buildTextFormField(controller: _genderController, label: 'Gender'),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: (value) {
          // Update the controller as the user types
          setState(() {
            controller.text = value;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    super.dispose();
  }
}
