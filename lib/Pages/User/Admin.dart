import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emartsystem/Pages/User/UserLogin.dart';
import '../../Model/User/UserLoginModel.dart';
import 'InboxReport.dart';
import 'ProductChart.dart';
import 'ReviewReport.dart';
import 'User.dart';
import 'UserSeller.dart';  // Replace with your actual model import path

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String adminName = '';
  String adminEmail = '';
  String adminImageUrl = '';
  List<UserLoginModel> users = [];

  @override
  void initState() {
    super.initState();
    _loadAdminDetails();
    _loadAllUsers();
  }

  void _loadAdminDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString('name') ?? 'Admin';
      adminEmail = prefs.getString('email') ?? 'admin@example.com';
      adminImageUrl = prefs.getString('image') ?? 'https://via.placeholder.com/150';
    });
  }

  void _loadAllUsers() async {
    // Load users data. Replace this with actual data loading logic.
    users = await UserLoginModel.loadAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      drawer: _buildDrawer(),
      //body: _buildUserList(),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(adminName),
            accountEmail: Text(adminEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(adminImageUrl),
            ),
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Inbox'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InboxReportPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text('Product'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductChartPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('User'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserSellerPage(),
                ),
              );
              },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLoginPage(),
                ),
              );
              },
          ),
        ],
      ),
    );
  }



  void _showUserDetails(UserLoginModel user) {
    // Implement this method to navigate to a detailed user view
    // ...
  }
}
