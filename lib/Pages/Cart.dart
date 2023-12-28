import 'package:flutter/material.dart';
import '../Model/CartModel.dart';
import '../Model/UserLoginModel.dart';

class CartPage extends StatefulWidget {
  final UserLoginModel user;

  CartPage({required this.user, Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartModel> cartItems = [];
  String checkoutButtonText = 'Checkout';
  double totalPrice = 0; // Store the total price here

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() async {
    try {
      final List<CartModel> items = await CartModel.loadAll();

      setState(() {
        cartItems = items;
        checkoutButtonText = 'Checkout RM${totalPrice.toStringAsFixed(2)}';
      });
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total price
    for (var item in cartItems) {
      totalPrice += (item.price ?? 0);
    }

    // Update the checkout button text with the total price
    checkoutButtonText = 'Checkout RM${totalPrice.toStringAsFixed(2)}';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  CartModel cartItem = cartItems[index];
                  int quantity = cartItem.quantity ?? 0;

                  void decrementQuantity() {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  }

                  void incrementQuantity() {
                    setState(() {
                      quantity++;
                    });
                  }

                  void deleteCartItem() {
                    // Implement the logic to delete the cart item here
                  }

                  bool isChecked = false;

                  return Container(
                    color: Colors.white10, // Set the background color here
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.all(10),
                      child: Container(
                        color: Colors.white30,
                        // Set the background color for the ListTile here
                        child: ListTile(
                          leading: Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                          ),
                          title: Text(
                            cartItem.productName,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '\RM${(cartItem.price ?? 0).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: decrementQuantity,
                                  ),
                                  Text(
                                    '$quantity',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: incrementQuantity,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {
                // Implement checkout functionality here
              },
              child: Text(checkoutButtonText),
            ),
          ),
        ],
      ),
    );
  }
}
