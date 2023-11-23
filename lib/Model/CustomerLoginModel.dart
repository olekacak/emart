import '../Controller/CustomerLoginController.dart';

class CustomerLoginModel {
  int? customerId;
  String username;
  String password;
  String name;
  String email;
  String phoneNo;
  String address;
  String status;

  CustomerLoginModel(
      this.username,
      this.password,
      this.name,
      this.email,
      this.phoneNo,
      this.address,
      this.status);

  CustomerLoginModel.withCustomerId(
      this.customerId,
      this.username,
      this.password,
      this.name,
      this.email,
      this.phoneNo,
      this.address,
      this.status,
      );

  CustomerLoginModel.fromJson(Map<String, dynamic> json)
      : customerId = json['customerId'] as int? ?? 0,
        username = json['username'] as String? ?? '',
        password = json['password'] as String? ?? '',
        name = json['name'] as String? ?? '',
        email = json['email'] as String? ?? '',
        phoneNo = json['phoneNo'] as String? ?? '',
        address = json['address'] as String? ?? '',
        status = json['status'] as String? ?? '';

  Map<String, dynamic> toJson() => {
    'customerId': customerId,
    'username': username,
    'password': password,
    'name': name,
    'email': email,
    'phoneNo': phoneNo,
    'address': address,
    'status': status,
  };

  Future<bool> save() async {
    CustomerLoginController req = CustomerLoginController(
        path: "/api/workshop2/customer_login.php");

    req.setBody({'username': username, 'password': password});
    await req.postCustomerLogin();
    if (req.status() == 200) {
      if (req.result()['customerId'] != null) {
        customerId = req.result()['customerId'];
      }
      return true;
    }
    return false;
  }

  Future<bool> editExpense() async {
    if (customerId == null) {
      // Cannot edit an expense without an ID
      return false;
    }

    CustomerLoginController req = CustomerLoginController(
        path: "/api/workshop2/customer_login.php");

    req.setBody(toJson());
    await req.postCustomerLogin();
    if (req.status() == 200) {
      return true;
    }
    return false;
  }

  static Future<List<CustomerLoginModel>> loadAll() async {
    List<CustomerLoginModel> result = [];
    CustomerLoginController customer = CustomerLoginController(
        path: "/api/workshop2/customer_login.php");

    await customer.postCustomerLogin();
    if (customer.status() == 200 && customer.result() != null) {
      for (var item in customer.result()) {
        result.add(CustomerLoginModel.fromJson(item));
      }
    }
    return result;
  }

  Future<bool> login(String username, String password) async {
    CustomerLoginController controller =
    CustomerLoginController(path: "/api/workshop2/customer_login.php");

    await controller.login(username, password);

    if (controller.status() == 200) {
      if (controller.result()['customerId'] != null) {
        customerId = controller.result()['customerId'];
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUp(
      String username,
      String password,
      String name,
      String email,
      String phoneNo,
      String address,
      String status,
      ) async {
    CustomerLoginController controller = CustomerLoginController(
      path: "/api/workshop2/customer_signup.php",
    );

    controller.setBody({
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'address': address,
      'status': status,
    });

    await controller.postCustomerLogin();

    if (controller.status() == 200) {
      if (controller.result()['customerId'] != null) {
        customerId = controller.result()['customerId'];
      }
      return true;
    } else {
      return false;
    }
  }
}
