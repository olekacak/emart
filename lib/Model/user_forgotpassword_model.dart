// import 'package:flutter/material.dart';
//
// import '../Controller/user_forgotpassword_controller.dart';
//
// class UserForgotPasswordModel {
//   String? userId;
//   String? username;
//   String password;
//   String name;
//   String email;
//   String phoneNo;
//   String address;
//   String status;
//   String sellerAccount;
//   String roleId;
//
//   // Method for GET and POST
//   UserForgotPasswordModel (
//       this.username,
//       this.password,
//       this.name,
//       this.email,
//       this.phoneNo,
//       this.address,
//       this.sellerAccount,
//       this.status,
//       this.roleId,
//   );
//
//   Map<String, dynamic> toJson() {
//     return {
//       'username': username,
//       'password': password,
//       'name': name,
//       'email': email,
//       'phoneNo': phoneNo,
//       'address': address,
//       'status': status,
//       'sellerAccount': sellerAccount,
//       'roleId': roleId,
//     };
//   }
//
//   Future<bool> saveEmail() async {
//     UserForgotPasswordController userForgotPasswordController = UserForgotPasswordController(path: "/api/workshop2/user_forgotpassword.php");
//     userForgotPasswordController.setBody(toJson());
//     await userForgotPasswordController.postForgotPassword();
//     print('Raw JSON data: ${userForgotPasswordController.result()}');
//     if (userForgotPasswordController.status() == 200) {
//       if (userForgotPasswordController.result()['userId'] != null) {
//         email = userForgotPasswordController.result()['email'];
//         print(email);
//       }
//       return true;
//     }
//     return false;
//   }
//   // Method for PUT
//   Future<bool> saveUser() async {
//     UserForgotPasswordController userForgotPasswordController = UserForgotPasswordController(path: "/api/workshop2/user_forgotpassword.php");
//     userForgotPasswordController.setBody(toJson());
//     await userForgotPasswordController.postForgotPassword();
//     print('Raw JSON data: ${userForgotPasswordController.result()}');
//     if (userForgotPasswordController.status() == 200) {
//       if (userForgotPasswordController.result()['userId'] != null) {
//         password = userForgotPasswordController.result()['password'];
//         print(password);
//       }
//       return true;
//     }
//     return false;
//   }
// }
