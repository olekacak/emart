import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../Model/UserLoginModel.dart';
import 'Profile.dart';
import 'UserLogin.dart';

class DashboardCustomerPage extends StatefulWidget {
  final UserLoginModel user;

  DashboardCustomerPage({required this.user, Key? key}) : super(key: key);

  @override
  _DashboardCustomerPageState createState() => _DashboardCustomerPageState();
}

class _DashboardCustomerPageState extends State<DashboardCustomerPage> {

  @override
  Widget build(BuildContext context) {

    UserLoginModel user = widget.user;

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
                      backgroundImage: widget.user.image != null
                          ? MemoryImage(base64Decode(widget.user.image!))
                          : null,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.user.email ?? 'Loading...',
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilePage(user: widget.user)),
                              );
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
