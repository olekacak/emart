import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emartsystem/Pages/User/UserLogin.dart';
import '../../Model/User/UserLoginModel.dart';
import 'ProductSellerChart.dart';
import 'ReviewReport.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String adminName = '';
  String adminEmail = '';
  //String adminImageUrl = '';
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
      adminName = prefs.getString('name') ?? 'Ali';
      adminEmail = prefs.getString('email') ?? 'ali@gmail.com';
      //adminImageUrl = prefs.getString('image') ?? '';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Admin Page',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add any additional widgets or content below
          ],
        ),
      ),
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
              //backgroundImage: NetworkImage(adminImageUrl),
            ),
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Inbox'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewReportPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text('Chart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductSellerChartPage(),
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
}
