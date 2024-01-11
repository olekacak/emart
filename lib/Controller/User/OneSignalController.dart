import 'dart:convert';
import 'package:http/http.dart' as http;

class OneSignalController{

  static final String _appId = '5eabb2f8-09ab-4354-abf5-cef1a5c174cc';
  static final String _apiKey = 'YjIwODVjNDMtNzkxNC00Zjc3LWFjNDgtMTViZDhjMTU0MmY5';

  Future<void> SendNotification(String title, String message , List<String>users) async{
    var header = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic $_apiKey'
    };

    var request = {
      'app_id': _appId,
      // send to specific user
      //'include_external_user_ids': users,
      'include_external_user_ids': users,

      // send to all users subscribed
      //'included_segments': ['All'],
      'headings': {'en': title},
      'contents': {'en': message}
    };

    var response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: header,
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully.");
    } else {
      print("Failed to send notification. Status code: ${response.statusCode}");
    }
  }
}