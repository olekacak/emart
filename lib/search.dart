import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: const <Widget>[
                ListTile(title: Text('KitKat')),
                ListTile(title: Text('Roti')),
                ListTile(title: Text('Pen')),
                ListTile(title: Text('Sabun')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}