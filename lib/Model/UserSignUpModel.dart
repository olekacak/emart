import '../Controller/UserSignUpController.dart';

class UserSignUpModel {
  String? userId;
  String? username;
  String password;
  String name;
  String email;
  String phoneNo;
  String address;
  String birthDate;
  String gender;
  String status;
  String sellerAccount;
  String roleId;

  UserSignUpModel(
      this.username,
      this.password,
      this.name,
      this.email,
      this.phoneNo,
      this.address,
      this.birthDate,
      this.gender,
      this.status,
      this.sellerAccount,
      this.roleId);

  Map<String, dynamic> toJson() {
    return {
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

  Future<bool> saveUserSignUp() async {
    UserSignUpController userSignUpController = UserSignUpController(path: "/api/workshop2/user_signup.php");
    userSignUpController.setBody(toJson());
    await userSignUpController.postUserSignUp();
    print('Raw JSON data: ${userSignUpController.result()}');
    if (userSignUpController.status() == 200) {
      if (userSignUpController.result()['userId'] != null) {
        userId = userSignUpController.result()['userId)'];
      }
      return true;
    }
    return false;
  }


}