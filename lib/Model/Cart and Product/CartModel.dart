import 'package:flutter/material.dart';
import '../../Controller/Cart and Product/CartController.dart';

class CartModel {
  int? cartId;
  int? userId;
  int? cartProductId; // Add new fields
  int? quantity;
  double? price;
  int? productId;
  String productName;

  CartModel({
    this.cartId,
    this.userId,
    this.cartProductId, // Initialize new fields in the constructor
    this.quantity,
    this.price,
    this.productId,
    required this.productName,
  });

  CartModel.fromJson(Map<String, dynamic> json)
      : cartId = json['cartId'] as int?,
        userId = json['userId'] as int?,
        cartProductId = json['cartProductId'] as int?,
        quantity = json['quantity'] as int?,
        price = json['price'] is int ? (json['price'] as int).toDouble() : json['price'] as double?,
        productId = json['productId'] as int?,
        productName = json['productName'];


  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'userId': userId,
      'cartProductId': cartProductId, // Add new fields to the JSON representation
      'quantity': quantity,
      'price': price,
      'productId': productId,
    };
  }

  static Future<bool> addToCart(int productId, int quantity, double price, String productName) async {
    CartController cartController = CartController(path: "/api/eMart2/cart.php"); // Update the path appropriately
    cartController.setBody({
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'productName': productName,
      // Include any other necessary fields
    });

    try {
      await cartController.post();
      if (cartController.status() == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error adding to cart: $e");
      return false;
    }
  }

  static Future<List<CartModel>> loadAll() async {
    List<CartModel> result = [];
    CartController cartProductController = CartController(path: "/api/eMart2/cart.php?cartId=1&userId=1");
    await cartProductController.get();
    if (cartProductController.status() == 200 && cartProductController.result() != null) {
      for (var item in cartProductController.result()) {
        result.add(CartModel.fromJson(item));
      }
    }
    return result;
  }
}
