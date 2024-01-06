import '../../Controller/Cart and Product/CartProductController.dart';

class CartProductModel {
  int? cartProductId;
  int? cartId;
  int? productId;
  String quantity;
  double price;

  CartProductModel({
    this.cartProductId,
    this.cartId,
    this.productId,
    required this.quantity,
    required this.price,
});

  CartProductModel.fromJson(Map<String, dynamic> json)
      : cartProductId = json['cartId'] as int? ?? 0,
        cartId = json['cartId'] as int? ?? 0,
        productId = json['productId'] as int? ?? 0,
        quantity = json['quantity'] as String? ?? '',
        price = (json['price'] as num?)?.toDouble() ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      'cartProductId': cartProductId,
      'cartId': cartId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }

  static Future<List<CartProductModel>> loadAll() async {
    List<CartProductModel> result = [];
    CartProductController cartProductController = CartProductController(path: "/api/eMart2/cart_product.php");
    await cartProductController.get();
    if (cartProductController.status() == 200 && cartProductController.result() != null) {
      for (var item in cartProductController.result()) {
        result.add(CartProductModel.fromJson(item));
      }
    }
    return result;
  }

  Future<bool> saveCartProduct() async {
    CartProductController cartProductController = CartProductController(path: "/api/eMart2/cart_product.php");
    cartProductController.setBody(toJson());
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

    CartProductController cartProductController = CartProductController(path: "/api/eMart2/cart_product.php");
    cartProductController.setBody(toJson());
    await cartProductController.put();
    if (cartProductController.status() == 200) {
      Map<String, dynamic> result = cartProductController.result();
      return true;
    }
    return false;
  }
}