import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/Stripe/StripeController.dart';
import '../../Model/Cart and Product/CartModel.dart';
import '../../Model/Stripe/StripeModel.dart';
import '../../Model/Transaction/TransactionModel.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartModel> cartItems = [];
  String checkoutButtonText = 'Checkout';
  double totalPrice = 0; // Store the total price here
  final StripeModel stripeModel = StripeModel();
  final StripeController stripeController = StripeController();
  Map<String, dynamic>? paymentIntent;
  int userId = -1;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
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

  void _loadCartItems() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId') ?? -1;

      if (userId != -1) {
        final List<CartModel> items = await CartModel.loadAll();

        setState(() {
          cartItems = items;
          checkoutButtonText = 'Checkout RM${totalPrice.toStringAsFixed(2)}';
        });
      } else {
        // Handle the case where userId is not available
        // You might want to show an error message or redirect the user to login.
        print("User ID not available");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void _handleCheckout() async {
    try {

      await makePayment();

      // Get the current date as a string
      final DateTime now = DateTime.now();
      final String formattedDate = "${now.year}-${now.month}-${now.day}";

      // Create a new TransactionModel object
      TransactionModel transaction = TransactionModel(
        transactionId: 1,
        transactionDate: formattedDate,
        status: "Completed",
        deliveryStatus: "Pending",
        cartId: 1, // You may need to set this value appropriately based on your data
      );

      // Save the transaction data
      bool success = await transaction.saveTransaction();

      if (success) {
        // Transaction saved successfully, you can show a success message or navigate to a confirmation page.
      } else {
        // Transaction failed to save, you can show an error message.
      }
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
              onPressed: _handleCheckout, // Call the checkout function
              child: Text(checkoutButtonText),
            ),
          ),
        ],
      ),
    );
  }
}
