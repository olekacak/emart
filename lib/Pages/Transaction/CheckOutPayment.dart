import 'package:emartsystem/Model/UserLoginModel.dart';
import 'package:emartsystem/Pages/Transaction.dart';
import 'package:flutter/material.dart';

class CheckoutPaymentPage extends StatefulWidget {
  final double totalAmount; // Pass the total amount as a parameter
  final double discountAmount; // Pass the discount amount as a parameter
  final UserLoginModel user; // Add user parameter

  CheckoutPaymentPage({
    required this.totalAmount,
    this.discountAmount = 0.0,
    required this.user, // Initialize user parameter
  });

  @override
  _CheckoutPaymentPageState createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  bool isOnlinePayment = true; // Default payment option is online banking

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
              onPressed: isOnlinePayment == null
                  ? null
                  : () {
                // Validate that a payment option is selected
                if (isOnlinePayment != null) {
                  // Navigate to TransactionPage
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TransactionPage(
                      user: widget.user,
                      totalAmount: widget.totalAmount,
                      isOnlinePayment: isOnlinePayment,
                    ),
                  ));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment), // Add your desired icon
                  SizedBox(width: 8), // Add some spacing between the icon and text
                  Text('Pay Now'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
