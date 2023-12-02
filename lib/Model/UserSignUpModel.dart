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

    UserSignUpModel({
      required this.username,
      required this.password,
      required this.name,
      required this.email,
      required this.phoneNo,
      required this.address,
      required this.birthDate,
      required this.gender,
      required this.status,
      required this.sellerAccount,
      required this.roleId});

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

    Future<int> saveUserSignUp() async {
      // Create an instance of UserSignUpController
      UserSignUpController userSignUpController = UserSignUpController(
        path: "/api/workshop2/user_signup.php",
      );

      // Set the body of the request with the JSON representation of the user model
      userSignUpController.setBody(toJson());

      // Send the user sign-up request to the server
      await userSignUpController.postUserSignUp();

      // Print the raw JSON data received from the server
      print('Raw JSON data: ${userSignUpController.result()}');
      Map<String, dynamic> userData = userSignUpController.result();

      // Check the HTTP status code of the server response
      if (userSignUpController.status() == 200) {
        // If successful, extract the userId from the server response
     /*   if (userSignUpController.result()['userId'] != null) {
          userId = userSignUpController.result()['userId'];
        }*/
        // Return 0 to indicate a successful signup
        print('sign up success');
        return 0;

      } else if (userSignUpController.status() == 400) {
        // If the status code is 400, handle potential errors returned by the server

        if (userData['error'] == 'Username already in use.') {
          // Check if the error is related to a username already in use
          // Update the username property with the existing username
          //this.username = userData['username'];
          //print(username);
          // Return 1 to indicate a username conflict
          print('username');
          return 1;

          } else if (userData['error'] == 'Email already in use.') {
          // Update the email property with the existing email
          //this.email = userData['email'];
          //print(email);
          // Return 2 to indicate an email conflict
          print('email');
          return 2;
        }
      }

      // If the status code is neither 200 nor 400, or for any other errors, return -1
      return -1;
    }
  }

