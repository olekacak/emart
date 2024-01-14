import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/Stripe/StripeController.dart';
import '../../Model/Cart and Product/CartProductModel.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/Stripe/StripeModel.dart';
import '../Transaction/Payment.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartProductModel> cartItems = [];
  List<ProductModel> product = [];
  final StripeModel stripeModel = StripeModel();
  final StripeController stripeController = StripeController();
  Map<String, dynamic>? paymentIntent;
  int userId = -1;
  int cartId = -1;
  double price = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    for (var cartItem in cartItems) {
      totalAmount += (cartItem.price ?? 0) * cartItem.quantity;
    }
    return totalAmount;
  }

  Future<void> updateCartItem(CartProductModel cartItem) async {
    try {
      bool success = await cartItem.updateCartProduct();
      if (success) {
        print("Cart item updated successfully in the database");
        setState(() {
        });
      } else {
        print("Failed to update cart item in the database");
      }
    } catch (error) {
      print("Error updating cart item: $error");
    }
  }

  void _loadCartItems() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId') ?? -1;
      cartId = prefs.getInt('cartId') ?? -1;

      if (userId != -1) {
        // Load CartProductModel based on userId and cartId
        final List<CartProductModel> items = await CartProductModel.loadAll(userId, cartId);
        print("cartId cartproduct model is ${cartId}");
        setState(() {
          // Update the cartItems list with the fetched items
        });
          cartItems = items;
      } else {
        // Handle the case where userId is not available
        print("User ID not available");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void deleteCartItem(int index) async {
    try {
      int? cartProductId = cartItems[index].cartProductId;
      print("cartproductid is ${cartProductId}");
      bool success = await cartItems[index].deleteCartProduct();

      if (success) {
        // Remove the deleted item from the local list
        setState(() {
          cartItems.removeAt(index);
        });
      } else {
        showMessage(context, "Failed to delete cart item");
      }
    } catch (error) {
      print("Delete failed. Error: $error");
    }
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    bool hasItemsInCart = cartItems.isNotEmpty;
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
                  CartProductModel cartItem = cartItems[index];
                  int quantity = cartItem.quantity ?? 0;

                  void decrementQuantity(int index) {
                    if (cartItems[index].quantity == 1) {
                      // If the quantity is already 1, show a confirmation dialog to remove the item
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Remove Item from Cart?'),
                            content: Text('Are you sure you want to remove this item from your cart?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Remove'),
                                onPressed: () {
                                  // Remove the item from the cart
                                  deleteCartItem(index);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      setState(() {
                        cartItems[index].quantity--;
                        cartItems[index].totalPrice = cartItems[index].price * cartItems[index].quantity;
                        updateCartItem(cartItems[index]);
                      });
                    }
                  }

                  void incrementQuantity(int index) {
                    setState(() {
                      cartItems[index].quantity++;
                      cartItems[index].totalPrice = cartItems[index].price * cartItems[index].quantity; // Update totalPrice
                      updateCartItem(cartItems[index]);
                    });
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
                                  '\RM${(cartItem.totalPrice ?? 0).toStringAsFixed(2)}',
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
                                    onPressed: () => decrementQuantity(index),
                                  ),

                                  Text('$quantity'),

                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () => incrementQuantity(index),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => deleteCartItem(index),
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
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: hasItemsInCart
                    ? () {
                  double totalAmount = calculateTotalAmount();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        totalAmount: totalAmount,
                        cartId: cartId,
                      ),
                    ),
                  );
                }
                    : null, // Disable button if no items in the cart
                child: Text("Checkout"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}