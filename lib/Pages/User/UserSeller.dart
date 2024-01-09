import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../Model/User/UserLoginModel.dart';

class UserSellerPage extends StatefulWidget {
  @override
  _UserSellerPageState createState() => _UserSellerPageState();
}

class _UserSellerPageState extends State<UserSellerPage> {
  List<UserLoginModel> users = [];

  @override
  void initState() {
    super.initState();
    _loadAllUsers(); // Load users from your data source
  }

  void _loadAllUsers() async {
    // Load users data. Replace this with actual data loading logic.
    users = await UserLoginModel.loadAll();
    setState(() {});
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        Uint8List? imageBytes;
        try {
          if (user.image != null && user.image!.isNotEmpty) {
            imageBytes = base64Decode(user.image!);
          }
        } catch (e) {
          // Handle image decoding error
          print('Error decoding image: $e');
        }

        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            backgroundImage: imageBytes != null ? MemoryImage(imageBytes) : null,
          ),
          title: Row(
            children: [
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seller: ${user.username}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Add more user details here if needed
                  ],
                ),
              ),
            ],
          ),
          onTap: () => _showUserDetails(user),
        );
      },
    );
  }

  void _showUserDetails(UserLoginModel user) {
    // Implement navigation to user details page or show a dialog
    // Example: Navigator.push(...);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Sellers'),
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildUserList(),
    );
  }
}
