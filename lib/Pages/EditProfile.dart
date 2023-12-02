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
              // Update the user object with the latest values
              updateUserObject();

              // Save changes to the database
              bool success = await widget.user.updateUser();

              if (success) {
                _showMessage("Profile updated successfully.");
              } else {
                _showMessage("Failed to update profile. Please try again.");
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
          // No need to update the controller as the user types
          // The controller will be automatically updated by the TextFormField
        },
      ),
    );
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


  void _showMessage(String msg) {
    if (mounted) {
      // Make sure this context is still mounted/exist
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
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
