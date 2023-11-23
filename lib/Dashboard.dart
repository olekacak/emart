import 'package:flutter/material.dart';
import 'package:emartsystem/Profile.dart';
import 'package:emartsystem/CustomerLogin.dart';

void main() {
  runApp(DashboardPage());
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key});
  // User-provided image URL
  final String userImageUrl =
      'https://wallpapers.com/images/hd/profile-picture-f67r1m9y562wdtin.jpg';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
        ),
        body: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userImageUrl),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Name',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'youremail@example.com',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        // Add any additional information here
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      height: 200, // Adjust the height as needed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            leading: Icon(Icons.account_circle),
                            title: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                                );
                              },
                              child: Text('My Profile'),
                            ),
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.favorite),
                            title: ElevatedButton(
                              onPressed: () {},
                              child: Text('Wishlist'),
                            ),
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.swap_horiz),
                            title: ElevatedButton(
                              onPressed: () {},
                              child: Text('Switch Hosting'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'More information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 200, // Adjust the height as needed
                          color: Colors.white60, // Add your desired background color
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListTile(
                                leading: Icon(Icons.info),
                                title: ElevatedButton(
                                  onPressed: () {},
                                  child: Text('About'),
                                ),
                              ),
                              SizedBox(height: 10),
                              ListTile(
                                leading: Icon(Icons.help),
                                title: ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Help'),
                                ),
                              ),
                              SizedBox(height: 10),
                              ListTile(
                                leading: Icon(Icons.settings),
                                title: ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Setting'),
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // Logout button, navigate back to the login page
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => CustomerLoginPage()),
                                        (route) => false, // Remove all existing routes
                                  );
                                },
                                child: Text('Logout'),
                              ),
                            ],
                          ),
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
