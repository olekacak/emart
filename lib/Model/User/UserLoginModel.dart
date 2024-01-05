import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/User/UserLoginController.dart';

class UserLoginModel {
  int userId;
  int adminId;
  int? id;
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
      this.id,
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
      : adminId = json['adminId'] as int? ?? -1,
        userId = json['userId'] as int? ?? -1,
        id = json['id'] as int? ?? -1,
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

  void setId(int newUserId) {
    userId = newUserId;
  }
  Future<void> getId(int? id, String idType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(idType, id ?? -1);
  }


  // Save user method
  Future<bool> saveUser() async {
    UserLoginController userLoginController = UserLoginController(path: "/api/workshop2/user_login.php");
    userLoginController.setBody(toJson());
    await userLoginController.postUserLogin();

    if (userLoginController.status() == 200) {
      Map<String, dynamic> result = await userLoginController.result();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Store all user data as integers and strings in SharedPreferences
      await prefs.setInt('adminId', result['adminId'] as int? ?? 0);
      await prefs.setInt('userId', result['userId'] as int? ?? -1);
      // await prefs.setString('name', result['name'] as String? ?? '');
      // await prefs.setString('email', result['email'] as String? ?? '');
      // await prefs.setString('phoneNo', result['phoneNo'] as String? ?? '');
      // await prefs.setString('address', result['address'] as String? ?? '');
      // await prefs.setString('birthDate', result['birthDate'] as String? ?? '');
      // await prefs.setString('gender', result['gender'] as String? ?? '');
      // await prefs.setString('sellerAccount', result['sellerAccount'] as String? ?? '');
      // await prefs.setString('image', result['image'] as String? ?? '');

      // Update the instance properties with the data
      adminId = result['adminId'] as int? ?? 0;
      userId = result['userId'] as int? ?? -1;
      // name = result['name'] as String? ?? '';
      // email = result['email'] as String? ?? '';
      // phoneNo = result['phoneNo'] as String? ?? '';
      // address = result['address'] as String? ?? '';
      // birthDate = result['birthDate'] as String? ?? '';
      // gender = result['gender'] as String? ?? '';
      // sellerAccount = result['sellerAccount'] as String? ?? '';
      // image = result['image'] as String? ?? '';


      return true;
    }

    return false;
  }


  // // Update user method
  // Future<bool> updateUser() async {
  //   if (userId == null) {
  //     print('Update failed: userId is null.');
  //     return false;
  //   }
  //
  //   print('Updating user with userId: $userId');
  //
  //   UserLoginController userLoginController = UserLoginController(path: "/api/workshop2/user_login.php");
  //   userLoginController.setBody(toJson());
  //
  //   print('Sending update request to the server...');
  //   print('Request Payload: ${jsonEncode(toJson())}');
  //
  //   await userLoginController.put();
  //
  //   print('Update request completed.');
  //
  //   if (userLoginController.status() == 200) {
  //     print('Update successful');
  //     // Map<String, dynamic> result = userLoginController.result();
  //     //
  //     // if (result.containsKey('message') && result['message'] == 'User information updated successfully') {
  //     //   userId = result['userId'] as int? ?? -1;
  //     //   name = result['name'] as String? ?? '';
  //     //   email = result['email'] as String? ?? '';
  //     //   phoneNo = result['phoneNo'] as String? ?? '';
  //     //   address = result['address'] as String? ?? '';
  //     //   birthDate = result['birthDate'] as String? ?? '';
  //     //   gender = result['gender'] as String? ?? '';
  //     //   sellerAccount = result['sellerAccount'] as String? ?? '';
  //     //   image = result['image'] as String? ?? '';
  //     //
  //     //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //     //   await prefs.setInt('userId', userId);
  //     //   await prefs.setString('name', name);
  //     //   await prefs.setString('email', email);
  //     //   await prefs.setString('phoneNo', phoneNo);
  //     //   await prefs.setString('address', address);
  //     //   await prefs.setString('birthDate', birthDate);
  //     //   await prefs.setString('gender', gender);
  //     //   await prefs.setString('sellerAccount', sellerAccount!);
  //     //   await prefs.setString('image', image!);
  //     //
  //     //   print('User information updated successfully.');
  //
  //       return true;
  //    // }
  //   }
  //
  //   // Print the error message in case of failure
  //   print('Update failed. Error: ${userLoginController.result()["error"]}');
  //   return false;
  // }


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