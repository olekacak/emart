import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inbox UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InboxPage(),
    );
  }
}


class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications tap
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('eMart payment'),
            subtitle: const Text('You\'ve paid MYR 10.00 to the seller for purchase.'),
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              // Handle tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('New user login'),
            onTap: () {
              // Handle tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('eMart payment'),
            subtitle: const Text('You\'ve paid MYR 5.10 to the seller for purchase.'),
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              // Handle tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Updates your account.'),
            onTap: () {
              // Handle tap
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.blueGrey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: "Inbox",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
      ),
    );
  }
}

/*class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  // This will hold the index of the currently selected segment ('Messages' or 'Notifications').
  int _segmentedControlValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Adjust the color to match the design.
        title: Text('Inbox'),
      ),
      body: Column(
        children: [
          _buildSegmentedControl(),
          Expanded(
            child: ListView(
              children: [
                _buildListItem(
                  icon: Icons.shopping_cart,
                  title: 'eMart payment',
                  subtitle: 'You\'ve paid MYR 10.00 to the seller for purch...',
                  date: '29 Oct',
                  isNew: true,
                ),
                _buildListItem(
                  icon: Icons.person_add,
                  title: 'New user login',
                  subtitle: 'New device logged in to your account.',
                  date: '29 Oct',
                  isNew: true,
                ),
                _buildListItem(
                  icon: Icons.shopping_cart,
                  title: 'eMart payment',
                  subtitle: 'You\'ve paid MYR 51.00 to the seller for purch...',
                  date: '27 Oct',
                  isNew: false,
                ),
                _buildListItem(
                  icon: Icons.update,
                  title: 'Updates your account.',
                  subtitle: 'We have updated our privacy policy.',
                  date: '1 Oct',
                  isNew: false,
                ),
                // ... more list items
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple, // Adjust the color to match the design.
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Assuming the Inbox is the third item in the BottomNavigationBar.
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildSegmentedControlButton('Messages', 0),
          _buildSegmentedControlButton('Notifications', 1),
        ],
      ),
    );
  }

  Widget _buildSegmentedControlButton(String title, int value) {
    final bool isSelected = _segmentedControlValue == value;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: isSelected ? Colors.deepPurple : Colors.grey[300],
            onPrimary: isSelected ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {
            setState(() {
              _segmentedControlValue = value;
            });
          },
          child: Text(title),
        ),
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String date,
    required bool isNew,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple), // Adjust the color to match the design.
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Wrap(
        spacing: 12, // space between two icons
        children: <Widget>[
          Text(date),
          isNew ? Icon(Icons.brightness_1, color: Colors.red, size: 10.0) : Container(),
        ],
      ),
    );
  }
}*/
