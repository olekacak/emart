import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/User/UserProfileModel.dart';
import 'Profile.dart';
import 'Setting.dart';
import 'UserLogin.dart';

class DashboardCustomerPage extends StatefulWidget {
  @override
  _DashboardCustomerPageState createState() => _DashboardCustomerPageState();
}

class RegisterSeller extends StatelessWidget {
  final Function(bool) onSellerStatusChanged;

  RegisterSeller({required this.onSellerStatusChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Register as Seller"),
      content: Text("Do you want to register as a seller?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Update the seller status and notify the parent widget
            onSellerStatusChanged(true);
            Navigator.of(context).pop();
          },
          child: Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            // Handle the "No" button press here.
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("No"),
        ),
      ],
    );
  }
}


class _DashboardCustomerPageState extends State<DashboardCustomerPage> {
  int userId = -1;
  UserProfileModel? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    if (userId != -1) {
      user = UserProfileModel(
        -1,
        userId = userId,
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
      try {
        await user?.loadByUserId();
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        // Handle errors during user loading
        print("Error loading user: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Align(
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
                      backgroundImage: user?.image != null
                          ? MemoryImage(base64Decode(user!.image!))
                          : null,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          user?.email ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                              // After returning from ProfilePage, reload the user data
                              loadUser();
                            },
                            child: ListTile(
                              leading: Icon(Icons.account_circle),
                              title: Text('My Profile'),
                            ),
                          ),

                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.favorite),
                            title: Text('Wishlist'),
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.swap_horiz),
                            title: Text('Start Selling'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Return the RegisterAsSellerDialog widget here
                                  return RegisterSeller(onSellerStatusChanged: (bool ) {  },);
                                },
                              );
                            },
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
                    child: Container(
                      width: double.infinity,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.info),
                                  title: Text('About'),
                                ),
                                SizedBox(height: 10),
                                ListTile(
                                  leading: Icon(Icons.help),
                                  title: Text('Help'),
                                ),
                                SizedBox(height: 10),
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SettingPage()),
                                    );
                                  },
                                  leading: Icon(Icons.settings),
                                  title: Text('Setting'),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => UserLoginPage()),
                                          (route) => false,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
