import 'dart:convert';
import 'package:http/http.dart' as http;

class StripeModel {
  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51OPqlnKJ0LDtdxZsQwczZRUJeGOyDhwXTR6PTGmBivWRzBmvIUkG7wQDanYYZ2LehucJDccY61FZapXFqn99Zu6h00njwtM5Us',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
