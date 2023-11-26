import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../Model/UserLoginModel.dart';
import 'Cart.dart';
import 'DashboardCustomer.dart';
import 'Filter.dart';
import 'Inbox.dart';
import 'Search.dart';

class HomeCustomerPage extends StatefulWidget {
  final UserLoginModel user;

  HomeCustomerPage({required this.user, Key? key}) : super(key: key);

  @override
  _HomeCustomerpageState createState() => _HomeCustomerpageState();
}

class _HomeCustomerpageState extends State<HomeCustomerPage> {
  late int _currentIndex;
  late List<Widget> _pages;

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
                  MaterialPageRoute(builder: (context) => DashboardCustomerPage(user: widget.user)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for a product",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list_sharp, color: Colors.blueGrey),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FilterPage(user: widget.user)));
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
                      width: MediaQuery.of(context).size.width,
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.blueGrey,
        currentIndex: _currentIndex,
        onTap: (index) {
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
  const CategorySection({Key? key});

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
  const CategoryItem({Key? key});

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
  const FeaturedProductsSection({Key? key});

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
  const ProductCard({Key? key});

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
