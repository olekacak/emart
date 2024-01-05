import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeController {
  Future<void> initializePaymentSheet(Map<String, dynamic> paymentIntentData) async {
    var gpay = PaymentSheetGooglePay(
      merchantCountryCode: "MYR",
      currencyCode: "MYR",
      testEnv: true,
    );

    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Amier',
          googlePay: gpay,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
      });
    } catch (e) {
      print('$e');
    }
  }
}
