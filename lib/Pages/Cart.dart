import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Placeholder for cart items
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Pantene Shampoo',
      'price': 'RM 12.72',
      'quantity': 1,
      'selected': false, // A 'selected' key to track if item is selected or not
    },
    {
      'name': 'Samyang Ramen Carbonara',
      'price': 'RM 20.50',
      'quantity': 1,
      'selected': false,
    },
    {
      'name': 'Colgate High Definition Charcoal Toothbrush Valuepack (3 Ultra Soft)',
      'price': 'RM 14.16',
      'quantity': 1,
      'selected': false,
    },
    {
      'name': 'Roti Gardenia Original Classic (600g)',
      'price': 'RM 20.50',
      'quantity': 1,
      'selected': false,
    },
  ];

  void _goToCheckout() {
    // Implement your checkout logic here
    // You can filter the cartItems to get only those selected
    var selectedItems = cartItems.where((item) => item['selected']).toList();
    print('Going to checkout with ${selectedItems.length} items');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shopping_cart), // Shopping cart icon
            SizedBox(width: 10),
            Text('Cart'),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          // ... other UI components like delivery options
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Checkbox(
                    value: item['selected'],
                    onChanged: (bool? value) {
                      setState(() {
                        item['selected'] = value!;
                      });
                    },
                  ),
                  title: Text(item['name']),
                  subtitle: Text(item['price']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (item['quantity'] > 1) {
                              item['quantity']--;
                            }
                          });
                        },
                      ),
                      Text('${item['quantity']}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            item['quantity']++;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Bottom part of the UI
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total: RM ${calculateTotal()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _goToCheckout,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.purple, // foreground
                    ),
                    child: const Text('Go to checkout'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String calculateTotal() {
    double total = 0;
    for (var item in cartItems.where((item) => item['selected'])) {
      total += double.parse(item['price'].replaceAll('RM ', '')) * item['quantity'];
    }
    return total.toStringAsFixed(2);
  }
}

