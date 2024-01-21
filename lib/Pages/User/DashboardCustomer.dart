import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/User/UserProfileModel.dart';
import '../Cart and Product/About.dart';
import '../Cart and Product/Help.dart';
import 'DashboardSeller.dart';
import 'Profile.dart';
import 'UserLogin.dart';

class DashboardCustomerPage extends StatefulWidget {
  @override
  _DashboardCustomerPageState createState() => _DashboardCustomerPageState();
}

class RegisterSeller extends StatelessWidget {
  final UserProfileModel user;
  final Function() onRegisterAsSeller;

  RegisterSeller({required this.user, required this.onRegisterAsSeller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Register as Seller"),
      content: Text("Do you want to register as a seller?"),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            print("Current sellerAccount value: ${user.sellerAccount}");
            user.sellerAccount = "true";
            print("New sellerAccount value: ${user.sellerAccount}");
            await user.updateProfile();

            onRegisterAsSeller(); // Call the callback function

            // Check if the user is a seller and navigate accordingly
            if (user.sellerAccount == "true") {
              Navigator.of(context).pop(); // Close the dialog

              // Navigate to DashboardSellerPage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLoginPage(),
                ),
              );
            } else {
              // Handle the case where the update was not successful or the user is not a seller
              print("Failed to update as a seller or user is not a seller");
              // You might want to show an error message or take appropriate action
            }
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
  late Future<UserProfileModel> userFuture;

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
      body: FutureBuilder<UserProfileModel>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('User data not found'));
          }

          UserProfileModel user = snapshot.data!;

          return SingleChildScrollView(
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
                          backgroundImage: user.image != null
                              ? MemoryImage(base64Decode(user.image!))
                              : null,
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name ?? 'Loading...',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              user.email ?? 'Loading...',
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
                                  setState(() {
                                    userFuture = loadUser();
                                  });
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
                                      return RegisterSeller( onRegisterAsSeller: () {  }, user: user);
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
          );
        },
      ),
    );
  }
}
