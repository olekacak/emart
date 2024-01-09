import 'package:flutter/material.dart';

import 'ReviewReport.dart';

class InboxReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox Report'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Product Report'),
            onTap: () {
              // Navigate to Product Reports Page
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProductReportPage(), // Replace with your Product Report Page
              //   ),
              // );
            },
          ),
          ListTile(
            leading: Icon(Icons.rate_review),
            title: Text('Review Report'),
            onTap: () {
              // Navigate to Review Reports Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewReportPage(), // Replace with your Review Report Page
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}