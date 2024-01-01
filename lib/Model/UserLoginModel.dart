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
      'userId': userId,
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'address': address,
      'birthDate': birthDate,
      'gender': gender,
      'sellerAccount' : sellerAccount,
      'image': image,

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

  static Future<List<UserLoginModel>> loadUser() async {
    List<UserLoginModel> result = [];
    UserLoginController userLoginController = UserLoginController(path: "/api/workshop2/user_login.php");
    await userLoginController.get();
    if (userLoginController.status() == 200 && userLoginController.result() != null) {
      for (var item in userLoginController.result()) {
        result.add(UserLoginModel.fromJson(item));
      }
    }
    return result;
  }

  Future<void> loadByUserId() async {
    UserLoginController userLoginController = UserLoginController(path: "/api/workshop2/user_login.php");
    userLoginController.setBody({'userId': userId.toString()});
    await userLoginController.get();

    if (userLoginController.status() == 200 && userLoginController.result() != null) {
      final updatedData = userLoginController.result()[0] as Map<String, dynamic>;
      // Update the properties of this instance with the updated data
      userId = updatedData['userId'] as int?;
      name = updatedData['name'] as String? ?? '';
      email = updatedData['email'] as String? ?? '';
      phoneNo = updatedData['phoneNo'] as String? ?? '';
      address = updatedData['address'] as String? ?? '';
      birthDate = updatedData['birthDate'] as String? ?? '';
      gender = updatedData['gender'] as String? ?? '';
      sellerAccount = updatedData['sellerAccount'] as String? ?? '';
      image = updatedData['image'] as String? ?? '';
    }
  }

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
        name = result['name'] as String? ?? '';
        email = result['email'] as String? ?? '';
        phoneNo = result['phoneNo'] as String? ?? '';
        address = result['address'] as String? ?? '';
        birthDate = result['birthDate'] as String? ?? '';
        gender = result['gender'] as String? ?? '';
        sellerAccount = result['sellerAccount'] as String? ?? '';
        image = result['image'];

        return true;
      }
    }

    // Print the error message in case of failure
    print('Update failed. Error: ${userLoginController.result()["error"]}');
    return false;
  }

  Future<bool> deleteUser() async {
    if (userId == null) {
      // Cannot delete an expense without an ID
      return false;
    }

    UserLoginController userLoginController = UserLoginController(path: "/api/workshop2/user_login.php");
    userLoginController.setBody(toJson());

    await userLoginController.delete();

    if (userLoginController.status() == 200) {
      return true;
    } else {
      // Print the error message in case of failure
      print('Delete failed. Error: ${userLoginController.result()}');
      return false;
    }
  }

}