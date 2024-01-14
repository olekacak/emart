import 'dart:convert';

import 'package:emartsystem/Pages/Cart%20and%20Product/MyShop.dart';
import 'package:emartsystem/Pages/User/Setting.dart';
import 'package:emartsystem/Pages/User/Wishlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/User/UserProfileModel.dart';
import '../Cart and Product/About.dart';
import '../Cart and Product/Help.dart';
import 'Order.dart';
import 'Profile.dart';
import 'UserLogin.dart';

class DashboardSellerPage extends StatefulWidget {
  @override
  _DashboardSellerPageState createState() => _DashboardSellerPageState();
}

class _DashboardSellerPageState extends State<DashboardSellerPage> {
  int userId = -1;
  Future<UserProfileModel>? userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = loadUser();
  }

  Future<UserProfileModel> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    if (userId != -1) {
      UserProfileModel user = UserProfileModel(
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
      return user;
    } else {
      throw Exception('User ID not found');
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
        child: FutureBuilder<UserProfileModel>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              UserProfileModel user = snapshot.data!;
              return buildDashboard(user);
            } else {
              return Center(child: Text('User not found'));
            }
          },
        ),
      ),
    );
  }

  Widget buildDashboard(UserProfileModel user) {
    return Align(
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
                  backgroundImage: user.image != null
                      ? MemoryImage(base64Decode(user.image!))
                      : null,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      user.email,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          ).then((value) {
                            // This callback runs when the ProfilePage is popped and you're back in DashboardSellerPage.
                            setState(() {
                              userFuture = loadUser(); // Fetch fresh data after navigating back.
                            });
                          });
                        },
                        child: ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text('My Profile'),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WishlistPage()),
                          );
                        },
                        leading: Icon(Icons.favorite),
                        title: Text('Wishlist'),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyShopPage()),
                          );
                        },
                        leading: Icon(Icons.swap_horiz),
                        title: Text('Switch Hosting'),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OrderPage()),
                          );
                        },
                        leading: Icon(Icons.receipt_long_rounded),
                        title: Text('Order'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutPage(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            ListTile(
                              leading: Icon(Icons.help),
                              title: Text('Help'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HelpPage(),
                                  ),
                                );
                              },
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
    );
  }
}
