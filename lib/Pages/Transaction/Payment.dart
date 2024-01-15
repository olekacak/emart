import 'package:emartsystem/Model/Cart%20and%20Product/CartModel.dart';
import 'package:emartsystem/Pages/HomeSeller.dart';
import 'package:flutter/material.dart';
import '../../Controller/Stripe/StripeController.dart';
import '../../Model/Cart and Product/CartProductModel.dart';
import '../../Model/Stripe/StripeModel.dart';
import '../../Model/Transaction/TransactionModel.dart';
import '../HomeCustomer.dart';
import '../User/Order.dart';

class GroupedCartItem {
  int productId;
  String productName;
  double price;
  int quantity;
  bool isSelected;
  GroupedCartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.isSelected = false,
  });
}

class PaymentPage extends StatefulWidget {
  final double discountAmount;
  final double totalAmount;
  final int cartId;

  PaymentPage({
    this.discountAmount = 0.0, required this.totalAmount, required this.cartId,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<CartProductModel> cartItems = [];
  List<CartModel> cart = [];
  String checkoutButtonText = 'Checkout';
  double totalPrice = 0;
  final StripeModel stripeModel = StripeModel();
  final StripeController stripeController = StripeController();
  int userId = -1;
  int _rating = 0;
  String selectedPaymentOption = 'Online Banking';

  @override
  void initState() {
    super.initState();
  }

  Future<void> updateCartStatus() async {
    List<CartModel> cart = await CartModel.loadAll();

    for (CartModel cart in cart) {
      cart.status = 'Pending';
      await cart.updateCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Total Amount: RM${widget.totalAmount..toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (widget.discountAmount > 0)
              Text(
                'Discount: -RM${widget.discountAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Payment Option:'),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedPaymentOption,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentOption = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Online Banking',
                      child: Text('Online Banking'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Cash on Delivery',
                      child: Text('Cash on Delivery'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Selected Payment Option: ${selectedPaymentOption == 'Online Banking' ? 'Online Banking' : 'Cash on Delivery'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                _handleCheckout(selectedPaymentOption == 'Online Banking');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment),
                  SizedBox(width: 8),
                  Text('Pay Now'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCheckout(bool onlinePayment) async {
    if (selectedPaymentOption == 'Online Banking') {
      int totalPriceStripe = (widget.totalAmount * 100).toInt();
        Map<String, dynamic>? paymentIntent = await stripeModel.createPaymentIntent(totalPriceStripe.toString(), 'MYR');

        if (paymentIntent != null) {
          await stripeController.initializePaymentSheet(paymentIntent!);
          await stripeController.displayPaymentSheet();

          if (paymentIntent['paymentStatus'] == 'succeeded') {
            // Payment succeeded
            final DateTime now = DateTime.now();
            final String formattedDate = "${now.year}-${now.month}-${now.day}";

            TransactionModel transaction = TransactionModel(
              transactionId: -1,
              transactionDate: formattedDate,
              status: "Pending",
              deliveryStatus: "Pending",
              cartId: widget.cartId,
              paymentOption: selectedPaymentOption, // Use selectedPaymentOption
              voucher: "Free Shipping",
              totalPayment: widget.totalAmount, // Set totalPayment to the actual total amount
              cartProductId: -1,
              price: widget.totalAmount, // Set price to the actual total amount
              quantity: 1, // You can adjust the quantity as needed
              image: '',
              userId: userId,
              productId: -1,
              productName: '',
            );

            bool success = await transaction.saveTransaction();

            if (success) {
              print("Payment Successfully");
              updateCartStatus();
              placeOrder(); // Pass true to indicate success
            } else {
              print("Failed to save transaction data.");
              placeOrder(); // Pass false to indicate failure
            }
          } else {
            // Payment failed
            print("Payment failed.");
            placeOrder(); // Pass false to indicate failure
          }
        } else {
          // PaymentIntent is null
          print("PaymentIntent is null.");
          placeOrder(); // Pass false to indicate failure
        }
      } else {
        // Cash on Delivery
        final DateTime now = DateTime.now();
        final String formattedDate = "${now.year}-${now.month}-${now.day}";

        TransactionModel transaction = TransactionModel(
          transactionId: -1,
          transactionDate: formattedDate,
          status: "Pending",
          deliveryStatus: "Pending",
          cartId: widget.cartId,
          paymentOption: selectedPaymentOption,
          voucher: "Free Shipping",
          totalPayment: widget.totalAmount, // Set totalPayment to the actual total amount
          cartProductId: -1,
          price: widget.totalAmount, // Set price to the actual total amount
          quantity: 1, // You can adjust the quantity as needed
          image: '',
          userId: userId,
          productId: -1,
          productName: '',
        );

        print("cartid cod = ${widget.cartId}");
        bool success = await transaction.saveTransaction();

        if (success) {
          print("Cash on Delivery Successful");
          updateCartStatus();
          placeOrder(); // Pass true to indicate success
        } else {
          print("Failed to save transaction data.");
          placeOrder(); // Pass false to indicate failure
        }
      }
  }


  Future<void> placeOrder() async {
    await Future.delayed(Duration(seconds: 2));
    bool success = true;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Center(child: Text('Payment Success')),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.check_circle, size: 100, color: Colors.purple),
                        Text(
                          'Order placed successfully!',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'You will receive a confirmation letter through your email',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListTile(
                          title: Text('Subtotal'),
                          trailing: Text('RM ${widget.totalAmount.toStringAsFixed(2)}'),
                        ),
                        ListTile(
                          title: Text('Voucher'),
                          trailing: Text('Free Shipping'),
                        ),
                        ListTile(
                          title: Text('Shipping Subtotal'),
                          trailing: Text('RM 0.00'),
                        ),
                        ListTile(
                          title: Text(selectedPaymentOption == 'Online Banking' ? 'Online Banking' : 'Cash on Delivery'),
                          trailing: selectedPaymentOption == 'Online Banking'
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.account_balance_wallet, size: 20),
                              Text(' **** 4242'),
                            ],
                          )
                              : Text('To be paid upon delivery'),
                        ),
                        ListTile(
                          title: Text('Total'),
                          trailing: Text('RM ${widget.totalAmount.toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text('How was your experience?'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                // Changed 'rating' to '_rating' for better encapsulation
                                _rating = index + 1;
                              });
                            },
                            child: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple, // Use backgroundColor to set the button color
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeSellerPage(),
                            ),
                                (route) => false, // Remove all previous routes
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.home, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Back to Home',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
            (route) => false, // Remove all previous routes
      );
    } else {
      // Handle the case where the transaction failed
    }
  }
}
