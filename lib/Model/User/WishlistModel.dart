import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/Cart and Product/CartController.dart';
import '../../main.dart';
import '../Cart and Product/ProductModel.dart';

class WishlistModel {
  int? wishlistId;
  int? userId;
  int? productId;
  ProductModel product;

  WishlistModel({
    this.wishlistId,
    this.userId,
    this.productId,
    required this.product,
  });

  WishlistModel.fromJson(Map<String, dynamic> json)
      : wishlistId = json['wishlistId'] as int?,
        userId = json['userId'] as int?,
        productId = json['productId'] as int?,
        product = ProductModel.fromJson(json);


  Map<String, dynamic> toJson() {
    return {
      'wishlistId': wishlistId,
      'userId': userId,
      'productId': productId,
    };
  }

  void setId(int newWishlistId) {
    wishlistId = newWishlistId;
  }

  Future<void> getId(int? id, String idType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(idType, id ?? -1);
  }

  Future<bool> addToWishlist() async {
    CartController wishlistController = CartController(path: "${MyApp().server}/api/workshop2/wishlist.php");
    wishlistController.setBody({
      'userId': userId,
      'wishlistId': wishlistId, // Use the current value of wishlistId
      'productId': productId,
    });

    try {
      await wishlistController.post();
      if (wishlistController.status() == 200) {
        Map<String, dynamic> result = await wishlistController.result();
        return true;
      }
      return false;
    } catch (e) {
      print("Error adding to wishlist: $e");
      return false;
    }
  }

  static Future<List<WishlistModel>> loadAll(int userId) async {
    List<WishlistModel> result = [];
    CartController wishlistController = CartController(path: "${MyApp().server}/api/workshop2/wishlist.php?userId=$userId");
    print("userId: $userId");
    await wishlistController.get();

    if (wishlistController.status() == 200) {
      // Extract wishlistItems directly from the response
      var responseData = wishlistController.result()?['wishlistItems'];

      // Check if 'wishlistItems' is a non-null list
      if (responseData != null && responseData is List) {
        for (var item in responseData) {
          result.add(WishlistModel.fromJson(item));
        }
      }
    }
    return result;
  }

  Future<bool> removeFromWishlist() async {
    CartController wishlistController = CartController(path: "${MyApp().server}/api/workshop2/wishlist.php");
    wishlistController.setBody({
      'userId': userId,
      'wishlistId': wishlistId, // Use the current value of wishlistId
      'productId': productId,
    });

    try {
      await wishlistController.delete(); // Use the 'delete' method for removing
      if (wishlistController.status() == 200) {
        Map<String, dynamic>? result = await wishlistController.result();
        if (result != null) {
          // Handle the response data if needed
        }
        return true;
      }
      return false;
    } catch (e) {
      print("Error removing from wishlist: $e");
      return false;
    }
  }
}
