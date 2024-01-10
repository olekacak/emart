import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/Stripe/StripeController.dart';
import '../../Model/Cart and Product/CartModel.dart';
import '../../Model/Cart and Product/CartProductModel.dart';
import '../../Model/Stripe/StripeModel.dart';
import '../../Model/Transaction/TransactionModel.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartProductModel> cartItems = [];
  String checkoutButtonText = 'Checkout';
  double totalPrice = 0;
  final StripeModel stripeModel = StripeModel();
  final StripeController stripeController = StripeController();
  Map<String, dynamic>? paymentIntent;
  int userId = -1;
  int cartId = -1;


  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void updateTotalPrice() {
    totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += (item.price ?? 0) * item.quantity;
    }
    setState(() {
      checkoutButtonText = 'Checkout RM${totalPrice.toStringAsFixed(2)}';
    });
  }


  Future<void> updateCartItem(CartProductModel cartItem) async {
    try {
      bool success = await cartItem.updateCartProduct();
      if (success) {
        print("Cart item updated successfully in the database");
      } else {
        print("Failed to update cart item in the database");
      }
    } catch (error) {
      print("Error updating cart item: $error");
    }
  }

  Future<void> makePayment() async {
    try {
      int totalPriceStripe = (totalPrice * 100).toInt();
      paymentIntent = await stripeModel.createPaymentIntent(totalPriceStripe.toString(), 'MYR');
      await stripeController.initializePaymentSheet(paymentIntent!);
      await stripeController.displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  // Inside _CartPageState class
  void _loadCartItems() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId') ?? -1;

      if (userId != -1) {
        // Load CartModel to get the cartId
        List<CartModel> carts = await CartModel.loadAll();
          // Load CartProductModel based on userId and cartId
          final List<CartProductModel> items = await CartProductModel.loadAll(userId, cartId);

          setState(() {
            cartItems = items;
            checkoutButtonText = 'Checkout RM${totalPrice.toStringAsFixed(2)}';
          });
      } else {
        // Handle the case where userId is not available
        print("User ID not available");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void _handleCheckout(BuildContext context) async {
    try {
      await makePayment();

      final DateTime now = DateTime.now();
      final String formattedDate = "${now.year}-${now.month}-${now.day}";

      TransactionModel transaction = TransactionModel(
        transactionId: 0,
        transactionDate: formattedDate,
        status: "Completed",
        deliveryStatus: "Pending",
        cartId: 1,
      );

      bool success = await transaction.saveTransaction();

      if (success) {
        showMessage(context, "Payment success");
      } else {
        showMessage(context, "Failed to make payment");
      }
    } catch (error) {
      print("Error: $error");
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
                    if (cartItems[index].quantity > 1) {
                      setState(() {
                        cartItems[index].quantity--;
                        updateTotalPrice();
                        updateCartItem(cartItems[index]);
                      });
                    }
                  }

                  void incrementQuantity(int index) {
                    setState(() {
                      cartItems[index].quantity++;
                      updateTotalPrice();
                      updateCartItem(cartItems[index]);
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
                                    onPressed: () => decrementQuantity(index),
                                  ),

                                  Text('$quantity'),

                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () => incrementQuantity(index),
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
              onPressed: () => _handleCheckout(context),
              child: Text(checkoutButtonText),
            ),
          ),
        ],
      ),
    );
  }
}