import '../Controller/UserLoginController.dart';

class UserLoginModel {
  int? adminId;
  int? userId;
  String? username;
  String? password;
  String name;
  String email;
  String phoneNo;
  String address;
  String birthDate;
  String gender;
  String? sellerAccount;
  String? status;
  String? image;
  // Constructor
  UserLoginModel(
      this.adminId,
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
      this.image,
      );

  // Json method
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  UserLoginModel.fromJson(Map<String, dynamic> json)
      : adminId = json['adminId'] as int? ?? 0,
        userId = json['userId'] as int? ?? 0,
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
        image = json['image'] as String? ?? '';

  // Save user method
  Future<bool> saveUser() async {
    UserLoginController userLoginController = UserLoginController(path: "/api/workshop2/user_login.php");
    userLoginController.setBody(toJson());
    await userLoginController.postUserLogin();
    if (userLoginController.status() == 200) {
        Map<String, dynamic> result = await userLoginController.result();

      if (result.containsKey('adminId')) {
        userId = result['adminId'];
        name = result['name'];
        email = result['email'];
        phoneNo = result['phoneNo'];
        address = result['address'];
        birthDate = result['birthDate'];
        gender = result['gender'];
        image = result['image'];

        return true;
      } else if (result.containsKey('userId')) {
        userId = result['userId'];
        name = result['name'];
        email = result['email'];
        phoneNo = result['phoneNo'];
        address = result['address'];
        birthDate = result['birthDate'];
        gender = result['gender'];
        sellerAccount = result['sellerAccount'];
        image = result['image'];

        return true;
      }
    }
    return false;
  }

  // Update user method
  Future<bool> updateUser() async {
    if (userId == null) {
      return false;
    }

    UserLoginController userLoginController = UserLoginController(path: "/api/workshop2/user_login.php");
    userLoginController.setBody(toJson());

    await userLoginController.put();
    if (userLoginController.status() == 200) {
      Map<String, dynamic> result = userLoginController.result();
      if (result.containsKey('message') && result['message'] == 'User information updated successfully') {
        userId = result['userId'] as int?;
        sellerAccount = result['sellerAccount'] as String? ?? '';
        name = result['name'] as String? ?? '';
        email = result['email'] as String? ?? '';
        phoneNo = result['phoneNo'] as String? ?? '';
        address = result['address'] as String? ?? '';
        birthDate = result['birthDate'] as String? ?? '';
        gender = result['gender'] as String? ?? '';
        image = result['image'];

        return true;
      }
    }

    // Print the error message in case of failure
    print('Update failed. Error: ${userLoginController.result()["error"]}');
    return false;
  }

}


