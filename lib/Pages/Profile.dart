import 'package:flutter/material.dart';
import 'EditProfile.dart';
import '../Model/UserLoginModel.dart';

class ProfilePage extends StatelessWidget {
  final UserLoginModel user;

  // Constructor to receive the user information
  const ProfilePage({Key? key, required this.user}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://wallpapers.com/images/hd/profile-picture-f67r1m9y562wdtin.jpg',
                  ),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfilePage()),
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
                title: Text('Phone Number: +1234567890'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Location: City, Country'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Birthday: January 1, 2000'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Gender: Male'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
