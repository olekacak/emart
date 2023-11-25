import '../Controller/UserLoginController.dart';


class UserLoginModel {
  int? userId;
  String? username;
  String password;
  String name;
  String email;
  String phoneNo;
  String address;
  String sellerAccount;
  String status;
  String roleId;

  //Method for GET and POST
  UserLoginModel(
    this.username,
    this.password,
    this.name,
    this.email,
    this.phoneNo,
    this.address,
    this.sellerAccount,
    this.status,
    this.roleId,
  );

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'address': address,
      'status': status,
      'sellerAccount': sellerAccount,
      'roleId': roleId,
    };
  }

  // Method for PUT
  Future<bool> saveUser() async {
    UserLoginController userLoginController = UserLoginController(path: "/api/workshop2/user_login.php");
    userLoginController.setBody(toJson());
    await userLoginController.postUserLogin();
    print('Raw JSON data: ${userLoginController.result()}');
    if (userLoginController.status() == 200) {
      if (userLoginController.result()['userId'] != null) {
        sellerAccount = userLoginController.result()['sellerAccount'];
        print(sellerAccount);
      }
      return true;
    }
    return false;
  }

}
