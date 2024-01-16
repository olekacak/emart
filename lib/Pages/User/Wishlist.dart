import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/User/WishlistModel.dart';
import '../Cart and Product/ProductDetail.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<WishlistModel> wishlistItems = [];
  int productId = -1;

  @override
  void initState() {
    super.initState();
    loadWishlistItems();
  }

  bool isProductInWishlist(ProductModel product) {
    return wishlistItems.any((item) => item.product.productId == product.productId);
  }

  void loadWishlistItems() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? -1;
      print("userId: $userId");

      if (userId != -1) {
        List<WishlistModel> loadedItems = await WishlistModel.loadAll(userId);
        // print("loaaddddd ${loadedItems[0].wishlistId}");

        setState(() {
          wishlistItems = loadedItems;

          // Check if the product in the wishlist is already marked as a favorite
          for (var item in wishlistItems) {
            if (isProductInWishlist(item.product)) {
              item.isFavorite = true;
            }
          }
        });
      }
    } catch (e) {
      print('Error loading wishlist items: $e');
    }
  }

  Future<void> toggleFavorite(WishlistModel wishlistItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? -1;
    print("wiwiwiwiwi ${wishlistItem.product.userId}");
    if (userId != -1) {
      if (!isProductInWishlist(wishlistItem.product)) {
        // Add to wishlist
        bool addedToWishlist = await wishlistItem.addToWishlist();
        if (addedToWishlist) {
          setState(() {
            wishlistItem.isFavorite = true; // Update the item to be marked as a favorite
            wishlistItems.add(wishlistItem); // Add the item to the local list
          });
        }
      } else {
        // Remove from wishlist
        bool removedFromWishlist = await wishlistItem.removeFromWishlist(userId, wishlistItem.productId!);
        if (removedFromWishlist) {
          setState(() {
            wishlistItem.isFavorite = false; // Update the item to not be marked as a favorite
            wishlistItems.remove(wishlistItem); // Remove the item from the local list
          });
        }
      }
    } else {
      // Handle the case where userId is not available
      print("User ID not available");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Wishlist"),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7, // Adjust the aspect ratio for more space
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: wishlistItems.length,
        itemBuilder: (context, index) {
          WishlistModel wishlistItem = wishlistItems[index];

          return InkWell(
            onTap: () {
              // Navigate to the product detail page when tapped
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    product: wishlistItem.product, // Pass the selected product to the detail page
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.memory(
                    Uint8List.fromList(base64.decode(wishlistItem.product.image)),
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            wishlistItem.product.productName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            wishlistItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: wishlistItem.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            print("afef ${wishlistItem.product.productName}");
                            toggleFavorite(wishlistItem);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '\RM${wishlistItem.product.price.toString()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Description: ${wishlistItem.product.description}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Quantity: ${wishlistItem.product.stockQuantity}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
