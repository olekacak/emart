import 'package:flutter/material.dart';

import '../../Controller/Stripe/StripeController.dart';
import '../../Model/Stripe/StripeModel.dart';

class StripePage extends StatefulWidget {
  const StripePage(List<Map<String, dynamic>> selectedItems, {Key? key}) : super(key: key);

  @override
  _StripePageState createState() => _StripePageState();
}

class _StripePageState extends State<StripePage> {
  final StripeModel stripeModel = StripeModel();
  final StripeController stripeController = StripeController();

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text('Buy Now'),
              onPressed: () async {
                await makePayment();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await stripeModel.createPaymentIntent('800', 'MYR');
      await stripeController.initializePaymentSheet(paymentIntent!);
      await stripeController.displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }
}
