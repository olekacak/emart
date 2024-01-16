import 'package:emartsystem/Controller/User/WishlistController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/Cart and Product/CartController.dart';
import '../../main.dart';
import '../Cart and Product/ProductModel.dart';

class WishlistModel {
  int? wishlistId;
  int? userId;
  int? productId;
  ProductModel product;
  bool isFavorite;

  WishlistModel({
    this.wishlistId,
    this.userId,
    required this.productId,
    required this.product,
    required this.isFavorite,
  });

  WishlistModel.fromJson(Map<String, dynamic> json)
      : wishlistId = json['wishlistId'] as int?,
        userId = json['userId'] as int?,
        productId = json['productId'] as int?,
        product = ProductModel.fromJson(json),
        isFavorite = json['isFavorite'] ?? false;


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

  static Future<bool> loadById(int userId, int productId) async {
    WishlistController wishlistController =
    WishlistController(path: "${MyApp().server}/api/workshop2/wishlist.php?userId=$userId&productId=$productId");

    await wishlistController.get();

    if (wishlistController.status() == 200) {
      // Extract raw response from the controller
      var rawResponse = wishlistController.result();
      print("raw response: $rawResponse");

      // Check if 'wishlistItem' is present and not null
      var responseData = rawResponse?['wishlistItem'];
      if (responseData != null && responseData is Map<String, dynamic>) {
        print("Loaded Wishlist item: ${responseData['productId']}");

        // Wishlist item found
        return true;
      } else {
        print("No wishlist item found in the response.");
      }
    } else {
      print("Failed to fetch wishlist item. Status code: ${wishlistController.status()}");
    }

    return false; // Wishlist item not found or error occurred
  }

  static Future<List<WishlistModel>> loadAll(int userId) async {
    List<WishlistModel> result = [];
    WishlistController wishlistController = WishlistController(path: "${MyApp().server}/api/workshop2/wishlist.php?userId=$userId");
    await wishlistController.get();

    if (wishlistController.status() == 200) {
      // Extract wishlistItems directly from the response
      var responseData = wishlistController.result()?['wishlistItems'];
      print("Loaded Wishlist items: ${result.map((item) => item.productId).toList()}");
      print("ressss ${responseData}");


      // Check if 'wishlistItems' is a non-null list
      if (responseData != null && responseData is List) {
        for (var item in responseData) {
          result.add(WishlistModel.fromJson(item));
        }
      }
    }
    print("result ${result[2].productId}");
    return result;
  }

  Future<bool> removeFromWishlist(int userId, int productId) async {
    CartController wishlistController = CartController(path: "${MyApp().server}/api/workshop2/wishlist.php");
    wishlistController.setBody({
      'userId': userId,
      'wishlistId': wishlistId, // Use the current value of wishlistId
      'productId': productId,
    });
    print("userId: $userId, wishlistId: $wishlistId, productId: $productId");

    try {
      await wishlistController.delete(); // Use the 'delete' method for removing
      if (wishlistController.status() == 200) {
        print("Status code: ${wishlistController.status()}");
        print("Raw response: ${wishlistController.result()}");

        Map<String, dynamic>? result = await wishlistController.result();
        if (result != null) {
          // Handle the response data if needed
        }
        return true;
      } else if (wishlistController.status() == 404) {
        // If the wishlist item is not found, consider it as successfully removed
        return true;
      }
      return false;
    } catch (e) {
      print("Error removing from wishlist: $e");
      return false;
    }
  }

}