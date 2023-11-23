import 'package:flutter/material.dart';
import 'package:emartsystem/EditProfile.dart';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
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
                        'Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'user@email.com',
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
      ),
    );
  }
}
