import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'Cart.dart';
import 'DashboardCustomer.dart';
import 'Filter.dart';
import 'Inbox.dart';
import 'Search.dart';

class HomeCustomerPage extends StatefulWidget {

  HomeCustomerPage({ Key? key}) : super(key: key);

  @override
  _HomeCustomerpageState createState() => _HomeCustomerpageState();
}

class _HomeCustomerpageState extends State<HomeCustomerPage> {
  final int _currentIndex = 0;

  // Define a list of pages to navigate to when bottom navigation items are tapped
  final List<Widget> _pages = [
    HomeCustomerPage(),
    const SearchPage(),
    const InboxPage(),
    const DashboardCustomerPage(),
  ];

  void _showMessage(String msg) {
    if (mounted) {
      // Make sure this context is still mounted/exist
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
        title: const Row(
          children: [
            Text(
              "eMart",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const CartPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const DashboardCustomerPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for a product",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list_sharp, color: Colors.blueGrey),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const FilterPage()));
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          CarouselSlider(
            options: CarouselOptions(height: 150.0),
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: const BoxDecoration(color: Colors.pinkAccent),
                    child: Text('Banner $i', style: const TextStyle(fontSize: 16.0)),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          const CategorySection(),
          const SizedBox(height: 10),
          const FeaturedProductsSection(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.blueGrey,
        currentIndex: _currentIndex,
        onTap: (index) {
          // Use Navigator to push the respective page onto the navigation stack
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => _pages[index]));
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

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return const CategoryItem();
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: Text('Category')),
    );
  }
}

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ProductCard();
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.pinkAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: Text('Product')),
    );
  }
}