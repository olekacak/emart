// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Controller/EditProfileController.dart';
//
// class EditProfileModel {
//   int userId;
//   int adminId;
//   int? id;
//   String? username;
//   String? password;
//   String name;
//   String email;
//   String phoneNo;
//   String address;
//   String birthDate;
//   String gender;
//   String? sellerAccount;
//   String? status;
//   String? image;
//
//   // Constructor
//   EditProfileModel(
//       this.adminId,
//       this.userId,
//       this.id,
//       this.username,
//       this.password,
//       this.name,
//       this.email,
//       this.phoneNo,
//       this.address,
//       this.birthDate,
//       this.gender,
//       this.sellerAccount,
//       this.status,
//       this.image,
//       );
//
//   // Json method
//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'username': username,
//       'password': password,
//       'name': name,
//       'email': email,
//       'phoneNo': phoneNo,
//       'address': address,
//       'birthDate': birthDate,
//       'gender': gender,
//       'sellerAccount': sellerAccount,
//       'image': image,
//     };
//   }
//
//   EditProfileModel.fromJson(Map<String, dynamic> json)
//       : adminId = json['adminId'] as int? ?? -1,
//         userId = json['userId'] as int? ?? -1,
//         id = json['id'] as int? ?? -1,
//         username = json['username'] as String? ?? '',
//         password = json['password'] as String? ?? '',
//         name = json['name'] as String? ?? '',
//         email = json['email'] as String? ?? '',
//         phoneNo = json['phoneNo'] as String? ?? '',
//         address = json['address'] as String? ?? '',
//         birthDate = json['birthDate'] as String? ?? '',
//         gender = json['gender'] as String? ?? '',
//         sellerAccount = json['sellerAccount'] as String? ?? '',
//         status = json['status'] as String? ?? '',
//         image = json['image'] as String? ?? '';
//
//   void setId(int newUserId) {
//     userId = newUserId;
//   }
//
//   Future<void> getId(int? id, String idType) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(idType, id ?? -1);
//   }
//
//   // // Update user method
//   // Future<bool> updateProfile() async {
//   //   if (userId == null) {
//   //     print('Update failed: userId is null.');
//   //     return false;
//   //   }
//   //
//   //   print('Updating user profile with userId: $userId');
//   //
//   //   EditProfileController editProfileController =
//   //   EditProfileController(path: "/api/workshop2/edit_profile.php");
//   //   editProfileController.setBody(toJson());
//   //
//   //   print('Sending update request to the server...');
//   //   print('Request Payload: ${jsonEncode(toJson())}');
//   //
//   //   await editProfileController.put();
//   //
//   //   print('Update request completed.');
//   //
//   //   if (editProfileController.status() == 200) {
//   //     print('Update successful');
//   //     return true;
//   //   }
//   //   print('Update failed. Error: ${editProfileController.result()["error"]}');
//   //   return false;
//   // }
// }
