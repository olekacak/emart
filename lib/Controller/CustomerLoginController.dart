import 'dart:convert'; //json encode/decode
import 'package:http/http.dart' as http;
import '../Model/CustomerLoginModel.dart';

class CustomerLoginController{
  String path;
  String server;
  http.Response? _res;
  final Map<dynamic,dynamic> _body = {};
  final Map<String,String> _headers = {};
  dynamic _resultData;

  CustomerLoginController({required this.path, this.server =
  "http://192.168.0.121"});
  setBody(Map<String, dynamic> data){
    _body.clear();
    _body.addAll(data);
    _headers["Content-Type"] = "application/json; charset=UTF-8";
  }

  Future<void> postCustomerLogin() async {
    _res = await http.post(
      Uri.parse(server + path),
      headers: _headers,
      body: jsonEncode(_body),
    );
    _parseResult();
  }

  Future<void> put() async {
    _res = await http.put(
      Uri.parse(server + path),
      headers: _headers,
      body: jsonEncode(_body),
    );
    _parseResult();
  }

  Future<bool> login(String username, String password) async {
    setBody({'username': username, 'password': password});
    await postCustomerLogin();

    if (status() == 200) {
      // Fetch user details after successful login
      await fetchUserDetails(username);
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchUserDetails(String username) async {
    // Use your API or database query to fetch user details based on the username
    // Update the user object in your controller with the fetched details
    // For example, if you have a User class in your controller:
    // user = User(name: fetchedName, email: fetchedEmail);
  }



  void _parseResult(){
    // parse result into json structure if possible
    try{
      print("raw response:${_res?.body}");
      _resultData = jsonDecode(_res?.body??  "");
    }catch(ex){
      //otherwise the response body will be stored as is
      _resultData = _res?.body;
      print("exception in http result parsing ${ex}");
    }
  }
  dynamic result(){
    return _resultData;
  }
  int status() {
    return _res?.statusCode ?? 0;
  }


}