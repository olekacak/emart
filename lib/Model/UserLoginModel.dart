import '../Controller/UserLoginController.dart';


class UserLoginModel {
  int? userId;
  String? username;
  String password;
  String name;
  String email;
  String phoneNo;
  String address;
  String birthDate;
  String gender;
  String sellerAccount;
  String status;
  String roleId;

  //Method for GET and POST
  UserLoginModel(
      this.userId,
    this.username,
    this.password,
    this.name,
    this.email,
    this.phoneNo,
    this.address,
    this.birthDate,
    this.gender,
    this.sellerAccount,
    this.status,
    this.roleId,
  );

  Map<String, dynamic> toJson() {
    return {
      'userId' : userId,
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'address': address,
      'birthDate': birthDate,
      'gender': gender,
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

    print('Request JSON: ${toJson()}');
    print('Raw JSON data: ${userLoginController.result()}');

    if (userLoginController.status() == 200) {
      Map<String, dynamic> result = userLoginController.result();

      // Ensure the 'userId' key exists in the result
      if (result.containsKey('userId')) {
        userId = result['userId'];
        name = userLoginController.result()['name'];
        email = userLoginController.result()['email'];
        phoneNo = userLoginController.result()['phoneNo'];
        address = userLoginController.result()['address'];
        birthDate = userLoginController.result()['birthDate'];
        gender = userLoginController.result()['gender'];
        sellerAccount = userLoginController.result()['sellerAccount'];
      }
      return true;
    }
    return false;
  }

  UserLoginModel.withId(
      this.userId,
      this.username,
      this.password,
      this.name,
      this.email,
      this.phoneNo,
      this.address,
      this.birthDate,
      this.gender,
      this.sellerAccount,
      this.status,
      this.roleId,);

  UserLoginModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] as int? ?? 0,
        username = json['username'] as String? ?? '',
        password = json['password'] as String? ?? '',
        name = json['name'] as String? ?? '',
        email = json['email'] as String? ?? '',
        phoneNo = json['phoneNo'] as String? ?? '',
        address = json['address'] as String? ?? '',
        birthDate = json['birthDate'] as String? ?? '',
        gender = json['gender'] as String? ?? '',
        sellerAccount = json['sellerAccount'] as String? ?? '',
        status = json['status'] as String? ?? '',
        roleId = json['roleId'] as String? ?? '';





  Future<bool> updateUser() async {
    if (userId == null) {
      // Cannot edit a user without a userId
      return false;
    }

    UserLoginController userLoginController = UserLoginController(path: "/api/workshop2/user_login.php");
    userLoginController.setBody(toJson());

    try {
      await userLoginController.put();

      // Print the raw JSON data received from the server
      print('Raw JSON data: ${userLoginController.result()}');
      print('Response Status Code: ${userLoginController.status()}');

      if (userLoginController.status() == 200) {
        Map<String, dynamic> result = userLoginController.result();
        if (result.containsKey('message') && result['message'] == 'User information updated successfully') {
          userId = result['userId'];
          sellerAccount = result['sellerAccount'];
          name = result['name'];
          email = result['email'];
          phoneNo = result['phoneNo'];
          address = result['address'];
          birthDate = result['birthDate'];
          gender = result['gender'];
          return true;
        }
      }

      // Print an error message if the update fails
      print('Update failed. Error: ${userLoginController.result()["error"]}');
    } catch (e) {
      print('Error occurred during update: $e');
    }

    return false;
  }


}
