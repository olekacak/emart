import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/Cart and Product/CartProductController.dart';
import '../../Controller/Cart and Product/ProductController.dart';
import '../../main.dart';
import 'ProductModel.dart';

class CartProductModel {
  int? cartProductId;
  int? cartId;
  int? userId;
  int? productId;
  int quantity;
  double totalPrice;
  String productName;
  double price;


  CartProductModel({
    this.cartProductId,
    this.cartId,
    this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.productName,
    required this.price,
  });

  CartProductModel.fromJson(Map<String, dynamic> json)
      : cartProductId = json['cartProductId'] as int? ?? 0,
        cartId = json['cartId'] as int? ?? 0,
        userId = json['userId'] as int? ?? 0,
        productId = json['productId'] as int? ?? 0,
        quantity = json['quantity'] as int? ?? 0,
        totalPrice = (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
        productName = json['productName'],
        price = (json['price'] as num?)?.toDouble() ?? 0.0;


  Map<String, dynamic> toJson() {
    return {
      'cartProductId': cartProductId,
      'cartId': cartId,
      'productId': productId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'productName': productName,
      'price': price,
    };
  }

  void setProductId(int newProductId) {
    productId = newProductId;
  }
  Future<void> getProductId(int? ProductId, String ProductIdType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(ProductIdType, ProductId ?? -1);
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

    // Explicitly include both quantity and price in the request payload
    Map<String, dynamic> requestBody = {
      'cartProductId': cartProductId,
      'cartId': cartId,
      'productId': productId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'productName': productName,
      'price': price,
    };

    cartProductController.setBody(requestBody);
    await cartProductController.put();

    if (cartProductController.status() == 200) {
      Map<String, dynamic> result = cartProductController.result();
      return true;
    }
    return false;
  }

  Future<bool> deleteCartProduct() async {
    if (cartProductId == null) {
      // Cannot delete an expense without an ID
      return false;
    }
    print("cartProductId in model is ${cartProductId}");
    CartProductController cartProductController = CartProductController(path: "${MyApp().server}/api/workshop2/cart_product.php");
    cartProductController.setBody(toJson());

    await cartProductController.delete();

    if (cartProductController.status() == 200) {
      return true;
    } else {
      // Print the error message in case of failure
      print('Delete failed. Error: ${cartProductController.result()}');
      return false;
    }
  }

  // Future<bool> deleteCartProduct() async {
  //   if (cartProductId == null) {
  //     // Cannot delete an expense without an ID
  //     return false;
  //   }
  //   print("cartProductId in model is ${cartProductId}");
  //   CartProductController cartProductController = CartProductController(path: "${MyApp().server}/api/workshop2/cart_product.php");
  //   cartProductController.setBody(toJson());
  //
  //   await cartProductController.delete();
  //
  //   if (cartProductController.status() == 200) {
  //     return true;
  //   } else {
  //     // Print the error message in case of failure
  //     print('Delete failed. Error: ${cartProductController.result()}');
  //     return false;
  //   }
  // }
}