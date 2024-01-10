import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/Cart and Product/CartProductController.dart';
import '../../main.dart';

class CartProductModel {
  int? cartProductId;
  int? cartId;
  int? userId;
  int? productId;
  int quantity;
  double price;
  String productName;
  

  CartProductModel({
    this.cartProductId,
    this.cartId,
    this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
  });

  CartProductModel.fromJson(Map<String, dynamic> json)
      : cartProductId = json['cartProductId'] as int? ?? 0,
        cartId = json['cartId'] as int? ?? 0,
        userId = json['userId'] as int? ?? 0,
        productId = json['productId'] as int? ?? 0,
        quantity = json['quantity'] as int? ?? 0,
        price = (json['price'] as num?)?.toDouble() ?? 0.0,
        productName = json['productName'];


  Map<String, dynamic> toJson() {
    return {
      'cartProductId': cartProductId,
      'cartId': cartId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'productName': productName,
    };
  }


  static Future<List<CartProductModel>> loadAll(int userId, int cartId) async {
    List<CartProductModel> result = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;
    cartId = prefs.getInt('cartId') ?? -1;
    print("userId cart ${userId}");
    print("cartId cart ${cartId}");
    CartProductController cartProductController = CartProductController(
      path: "${MyApp().server}/api/workshop2/cart_product.php?userId=$userId&cartId=$cartId",
    );

    await cartProductController.get();

    if (cartProductController.status() == 200 && cartProductController.result() != null) {
      for (var item in cartProductController.result()) {
        result.add(CartProductModel.fromJson(item));
      }
    }

    return result;
  }


  Future<bool> saveCartProduct() async {
    CartProductController cartProductController = CartProductController(path: "${MyApp().server}/api/workshop2/cart_product.php");
    final requestBody = toJson(); // Get the JSON request body
    print('Request Body: $requestBody'); // Print the request body for debugging
    cartProductController.setBody(requestBody);
    await cartProductController.post();

    if (cartProductController.status() == 200) {
      return true;
    }
    return false;
  }


  // Update product method
  Future<bool> updateCartProduct() async {
    if (productId == null) {
      return false;
    }

    CartProductController cartProductController = CartProductController(path: "${MyApp().server}/api/workshop2/cart_product.php");
    cartProductController.setBody(toJson());
    await cartProductController.put();
    if (cartProductController.status() == 200) {
      Map<String, dynamic> result = cartProductController.result();
      return true;
    }
    return false;
  }
}