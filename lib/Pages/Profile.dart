import 'dart:convert';
import 'package:flutter/material.dart';
import 'EditProfile.dart';
import '../Model/UserLoginModel.dart';

class ProfilePage extends StatefulWidget {
  final UserLoginModel user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: widget.user.image != null
                        ? MemoryImage(base64Decode(widget.user.image!))
                        : null,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name ?? 'Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.user.email ?? 'user@email.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(user: widget.user),
                            ),
                          );
                        },
                        child: Text('Edit Profile'),
                      ),

                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Card(
                child: ListTile(
                  title: Text(widget.user.phoneNo),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(widget.user.address),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(widget.user.birthDate),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(widget.user.gender),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
