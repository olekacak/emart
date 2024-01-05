import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/User/UserProfileModel.dart';
import 'EditProfile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProfileModel user;
  int userId = -1;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    if (userId != -1) {
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
        '',
        null,
        null,
      );

      // Fetch user data from the server
      await user.loadByUserId();
    }
    print("userIf from pref: ${userId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Reload user data when navigating back
            loadUser();
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: loadUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.image != null
                              ? MemoryImage(base64Decode(user.image!))
                              : null,
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name ?? 'Name',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user.email ?? 'user@email.com',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                final updatedUser = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(),
                                  ),
                                );
                                if (updatedUser != null) {
                                  // Update the state or reload the data
                                  setState(() {
                                    user = updatedUser;
                                  });

                                  // Reload data from the database
                                  await loadUser();
                                }

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
                        title: Text(user.phoneNo),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(user.address),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(user.birthDate),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(user.gender),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // You can show a loading indicator while waiting for the data
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
