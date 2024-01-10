import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/Cart and Product/CartController.dart';
import '../../main.dart';

class CartModel {
  int? cartId;
  int? userId;
  String status;


  CartModel({
    this.cartId,
    this.userId,
    required this.status,
  });

  CartModel.fromJson(Map<String, dynamic> json)
      : cartId = json['cartId'] as int?,
        userId = json['userId'] as int?,
        status = json['status'];


  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'userId': userId,
    };
  }

  void setId(int newCartId) {
    cartId = newCartId;
  }
  Future<void> getId(int? id, String idType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(idType, id ?? -1);
  }

  Future<bool> addCart() async {
    CartController cartController = CartController(path: "${MyApp().server}/api/workshop2/cart.php");
    cartController.setBody({
      'userId': userId,
      'cartId': cartId, // Use the current value of cartId
      'status': status,
    });

    try {
      await cartController.post();
      if (cartController.status() == 200) {
        Map<String, dynamic> result = await cartController.result();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? -1;
    CartController cartProductController = CartController(path: "${MyApp().server}/api/workshop2/cart.php?userId=$userId");
    await cartProductController.get();

    if (cartProductController.status() == 200) {
      // Extract 'data' field from the response
      var responseData = cartProductController.result()?['data'];

      // Check if 'data' is a non-null list
      if (responseData != null && responseData is List) {
        for (var item in responseData) {
          result.add(CartModel.fromJson(item));
        }
      }
    }
    return result;
  }
}
