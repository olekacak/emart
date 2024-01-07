import 'package:flutter/material.dart';
import '../../Model/User/UserLoginModel.dart';
import '../HomeCustomer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final double discountAmount;

  PaymentPage({
    required this.totalAmount,
    this.discountAmount = 0.0,

  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isOnlinePayment = true;
  int rating = 0;

  Future<void> placeOrder() async {
    // Perform any necessary logic before placing the order

    // Simulate an asynchronous operation (e.g., payment processing)
    await Future.delayed(Duration(seconds: 2));

    // Get the current date as a string
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.year}-${now.month}-${now.day}";

    // Calculate the total amount from selected items
    double totalAmount = widget.totalAmount;

    // Create a new TransactionModel object
    // Simulate saving the transaction data
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
                          trailing: Text('RM ${totalAmount.toStringAsFixed(2)}'),
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
                          title: Text(isOnlinePayment ? 'Online Banking' : 'Cash on Delivery'),
                          trailing: isOnlinePayment
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.account_balance_wallet, size: 20),
                              Text(' **** 2334'),
                            ],
                          )
                              : Text('To be paid upon delivery'),
                        ),
                        ListTile(
                          title: Text('Total'),
                          trailing: Text('RM ${totalAmount.toStringAsFixed(2)}'),
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
                                rating = index + 1;
                              });
                            },
                            child: Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeCustomerPage(),
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
            // Display total amount
            Text(
              'Total Amount: RM${widget.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Display discount and deduct if available
            if (widget.discountAmount > 0)
              Text(
                'Discount: -RM${widget.discountAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),

            // Payment options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Payment Option:'),
                SizedBox(width: 10),
                DropdownButton<bool>(
                  value: isOnlinePayment,
                  onChanged: (value) {
                    setState(() {
                      isOnlinePayment = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Online Banking'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Cash on Delivery'),
                    ),
                  ],
                ),
              ],

            ),
            SizedBox(height: 20),

            // Display the selected payment option
            Text(
              'Selected Payment Option: ${isOnlinePayment ? 'Online Banking' : 'Cash on Delivery'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // Check Out button
            ElevatedButton(
              onPressed: isOnlinePayment == null ? null : placeOrder,
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
}
