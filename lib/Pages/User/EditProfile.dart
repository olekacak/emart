import 'dart:convert';
import 'dart:typed_data';
import 'package:emartsystem/Model/User/EditProfileModel.dart';
import 'package:emartsystem/Model/User/UserProfileModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {

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
  String base64String = '';
  late UserProfileModel user;
  int userId = -1;

  late Future<void> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = loadUser();
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNoController = TextEditingController();
    _addressController = TextEditingController();
    _birthDateController = TextEditingController();
    _genderController = TextEditingController();

    user = UserProfileModel(
      -1,
      userId,
      -1,
      null,
      null,
      '',
      '',
      '',
      '',
      '',
      '',
      null,
      '',
      null,
    );

    if (userId != -1) {
      await user.loadByUserId();

      setState(() {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneNoController.text = user.phoneNo;
        _addressController.text = user.address;
        _birthDateController.text = user.birthDate;
        _genderController.text = user.gender;
      });
    } else {
      print('userId not found in SharedPreferences');
    }
  }

  pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        base64String = base64Encode(imageBytes);

        setState(() {
          user.image = base64String;
        });

        updateUserObject();

        bool success = await user.updateProfile();

        if (success) {
          _showMessage("Profile updated successfully.");
        } else {
          _showMessage("Failed to update profile. Please try again.");
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<void>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading user data'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  buildAvatarSection(),
                  buildTextFormField(controller: _nameController, label: 'Name'),
                  buildTextFormField(controller: _emailController, label: 'Email'),
                  buildTextFormField(controller: _phoneNoController, label: 'Phone Number'),
                  buildTextFormField(controller: _addressController, label: 'Address'),
                  buildTextFormField(controller: _birthDateController, label: 'Birth Date'),
                  buildTextFormField(controller: _genderController, label: 'Gender'),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () async {
            updateUserObject();

            bool success = await user.updateProfile();

            if (success) {
              _showMessage("Profile updated successfully.");
              Navigator.pop(context, user);
            } else {
              _showMessage("Failed to update profile. Please try again.");
            }
          },
          child: Text(
            'Save',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildAvatarSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: user.image != null ? MemoryImage(base64Decode(user.image!)) : null,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: pickImage,
          child: Text('Add / Edit Profile Picture'),
        ),
      ],
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

  void updateUserObject() {
    user.name = _nameController.text ?? '';
    user.email = _emailController.text ?? '';
    user.phoneNo = _phoneNoController.text ?? '';
    user.address = _addressController.text ?? '';
    user.birthDate = _birthDateController.text ?? '';
    user.gender = _genderController.text ?? '';

    if (base64String != null && base64String.isNotEmpty) {
      user.image = base64String;
    }
  }

  void _showMessage(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    super.dispose();
  }
}
