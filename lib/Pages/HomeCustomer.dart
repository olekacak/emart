import 'dart:convert';

import 'package:flutter/material.dart';

import '../Model/ProductModel.dart';
import '../Model/UserLoginModel.dart';
import 'Cart.dart';
import 'DashboardCustomer.dart';
import 'Filter.dart';
import 'Inbox.dart';
import 'ProductDetails.dart';
import 'Search.dart';

class MyTab extends StatelessWidget {
  final String iconPath;
  final String name;

  const MyTab({Key? key, required this.iconPath, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        height: 50, // Set the desired height for the image in the tab
        child: Column(
          children: [
            Image.asset(
              iconPath,
              height: 100, // Set the desired height for the image
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            Text(name), // Display the name below the image
          ],
        ),
      ),
    );
  }
}

class CustomTab {
  final String iconPath;
  final String name;

  CustomTab({required this.iconPath, required this.name});
}

class HomeCustomerPage extends StatefulWidget {
  final UserLoginModel user;

  HomeCustomerPage({required this.user, Key? key}) : super(key: key);

  @override
  _HomeCustomerPageState createState() => _HomeCustomerPageState();
}

class _HomeCustomerPageState extends State<HomeCustomerPage> {
  late int _currentIndex;
  late List<Widget> _pages;

  List<CustomTab> myTabs = [
    CustomTab(iconPath: 'assets/snack.png', name: 'Foods'),
    CustomTab(iconPath: 'assets/stationary.png', name: 'Stationary'),
    CustomTab(iconPath: 'assets/essential.png', name: 'Daily Essential'),
  ];

  //List<String> tabTitles = ["Foods", "Stationary", "Daily Essential"];
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;

    _pages = [
      HomeCustomerPage(user: widget.user),
      const SearchPage(),
      const InboxPage(),
      DashboardCustomerPage(user: widget.user),
    ];

    _loadProducts(); // Call the method to load products
  }

  _loadProducts() async {
    try {
      // Get the currently selected tab
      CustomTab selectedTab = myTabs[_currentIndex];

      // Load products based on the category of the selected tab
      List<ProductModel> loadedProducts = await ProductModel.loadAll(category: selectedTab.name.toLowerCase());

      setState(() {
        products = loadedProducts;
      });
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  void _showMessage(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "eMart",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardCustomerPage(user: widget.user),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.filter_list_sharp, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilterPage(user: widget.user),
                    ),
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: DefaultTabController(
              length: myTabs.length,
              child: Column(
                children: [
                  TabBar(
                    tabs: myTabs
                        .map((tab) => MyTab(iconPath: tab.iconPath, name: tab.name))
                        .toList(),
                    indicatorColor: Colors.purpleAccent,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: myTabs.asMap().entries.map(
                            (entry) {
                          int index = entry.key;
                          CustomTab tab = entry.value;

                          if (index == 0) {
                            // Filter products for the 'Foods' tab
                            List<ProductModel> foodProducts = products
                                .where((product) => product.category.toLowerCase() == 'food')
                                .toList();

                            return Column(
                              children: [
                                SizedBox(height: 16),
                                //MyTab(iconPath: tab.iconPath, name: tab.name),
                                SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Find Results",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      ElevatedButton(
                                        onPressed: () {
                                          _showMessage("See All clicked");
                                        },
                                        child: Text("See All"),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.7, // Adjust the aspect ratio as needed
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 8,
                                    ),
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      ProductModel product = products[index];

                                      // Add 'return' keyword here
                                      return GestureDetector(
                                        onTap: () {
                                          // Navigate to ProductDetailsPage when tapped
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProductDetailsPage(product: product),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.memory(
                                                base64.decode(product.image),
                                                height: 150,
                                                width: double.infinity,
                                                fit: BoxFit.contain,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  product.productName,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  '\RM${product.price.toString()}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  'Description: ${product.description}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  'Quantity: ${product.stockQuantity}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else{
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  // Image.asset(tab.iconPath),
                                ],
                              ),
                            );
                          }
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.blueGrey,
        currentIndex: _currentIndex,
        onTap: (index) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _pages[index]),
          );
        },
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