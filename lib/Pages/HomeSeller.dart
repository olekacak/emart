import 'dart:convert';

import 'package:flutter/material.dart';
import '../Model/Cart and Product/ProductModel.dart';
import 'Cart and Product/Cart.dart';
import 'Cart and Product/Filter.dart';
import 'Cart and Product/ProductDetails.dart';
import 'User/DashboardCustomer.dart';
import 'User/DashboardSeller.dart';
import 'Inbox.dart';
import 'Cart and Product/Search.dart';

class MyTab extends StatelessWidget {
  final String iconPath;
  final String name;

  const MyTab({Key? key, required this.iconPath, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        height: 50,
        child: Column(
          children: [
            Flexible(
              child: Image.asset(
                iconPath,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 5),
            Text(name),
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

class HomeSellerPage extends StatefulWidget {
  @override
  _HomeSellerPageState createState() => _HomeSellerPageState();
}

class _HomeSellerPageState extends State<HomeSellerPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  List<ProductModel> products = [];
  Map<String, List<ProductModel>> categorizedProducts = {};

  final List<CustomTab> myTabs = [
    CustomTab(iconPath: 'assets/all_product.png', name: 'All Products'),
    CustomTab(iconPath: 'assets/snacks.png', name: 'Snacks'),
    CustomTab(iconPath: 'assets/instant_food.png', name: 'Instant Food'),
    CustomTab(iconPath: 'assets/sweets.png', name: 'Sweets'),
    CustomTab(iconPath: 'assets/drinks.png', name: 'Drinks'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
    _loadProducts();
  }

  _loadProducts() async {
    try {
      products = await ProductModel.loadAll(category: '');

      // Shuffle the products list randomly
      products.shuffle();

      setState(() {
        categorizedProducts = {
          'All Products': products,
          'Snacks': products.where((p) => p.category.toLowerCase() == 'snacks').toList(),
          'Instant Food': products.where((p) => p.category.toLowerCase() == 'instant food').toList(),
          'Sweets': products.where((p) => p.category.toLowerCase() == 'sweets').toList(),
          'Drinks': products.where((p) => p.category.toLowerCase() == 'drinks').toList(),
        };
      });
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      HomeSellerPage(),
      const SearchPage(),
      const InboxPage(),
      DashboardSellerPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "eMart",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardCustomerPage(),
                ),
              );
            },
          ),
        ],
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
                      builder: (context) => FilterPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          TabBar(
            controller: _tabController,
            tabs: myTabs.map((tab) => MyTab(iconPath: tab.iconPath, name: tab.name)).toList(),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(), // Make it non-swipeable
              controller: _tabController,
              children: myTabs.map((tab) => _buildProductGridView(categorizedProducts[tab.name] ?? [])).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.blueGrey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _pages[index]),
            );
          });
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

  Widget _buildProductGridView(List<ProductModel> products) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5, // Adjust the aspect ratio for more space
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        ProductModel product = products[index];
        return GestureDetector(
          onTap: () {
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
                  height: 120,
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
    );
  }
}