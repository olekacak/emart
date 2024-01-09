import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Cart and Product/CartModel.dart';
import '../../Model/Cart and Product/CartProductModel.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import 'Cart.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  ProductDetailPage({
    required this.product,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedQuantity = 1;
  bool success = false;
  int userId = -1;
  int cartId = -1;

  @override
  void initState() {
    super.initState();
    loadUserId();
    initializeCart();
  }
  Future<void> initializeCart() async {
    int? retrievedCartId = await checkCart();
    if (retrievedCartId != null) {
      setState(() {
        cartId = retrievedCartId;
      });
    } else {
      print('Failed to retrieve cartId');
    }
  }

  Future<int?> checkCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;
    if (userId != -1) {
      // Check if the cart exists for the user
      List<CartModel> carts = await CartModel.loadAll();
      if (carts.isEmpty) {
        // Cart doesn't exist for the user, create a new one
        bool cartCreated = await CartModel(userId: userId, status: 'pending').addCart();
        if (cartCreated) {
          print('New cart created successfully');
          carts = await CartModel.loadAll();
        } else {
          print('Failed to create a new cart');
        }
      } else {
        // Check if the existing cart's status is "completed"
        if (carts.first.status == 'completed') {
          // If the status is "completed", create a new cart
          bool cartCreated = await CartModel(userId: userId, status: 'pending').addCart();
          if (cartCreated) {
            print('New cart created successfully');
            carts = await CartModel.loadAll(); // Reload carts after creation
          } else {
            print('Failed to create a new cart');
          }
        } else {
          print('Cart already exists for the user');
        }
      }

      // Retrieve the cartId of the created or existing cart
      int? cartId = carts.isNotEmpty ? carts.first.cartId! : -1;
      print('Retrieved cartId: $cartId');
      await prefs.setInt('cartId', cartId ?? -1);
      return cartId;
    }
  }

  loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     userId = prefs.getInt('userId') ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.productName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(
                    base64Decode(widget.product.image!),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'RM ${widget.product.price}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Description: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple,
                    ),
                  ),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (selectedQuantity > 1) {
                            setState(() {
                              selectedQuantity--;
                            });
                          }
                        },
                        child: Icon(Icons.remove),
                      ),
                      Text(
                        selectedQuantity.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedQuantity++;
                          });
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (userId != -1) {

                        // User ID is available, proceed to add the product to the cart
                        CartProductModel cartProduct = CartProductModel(
                          cartId: cartId,
                          productName: '',
                          productId: widget.product.productId,
                          quantity: selectedQuantity,
                          price: widget.product.price,
                        );

                        // Call the saveCartProduct method on the cartProduct instance
                        success = await cartProduct.saveCartProduct();

                        if (success) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartPage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to add product to cart.',
                              ),
                            ),
                          );
                        }
                      } else {
                        // Handle the case where userId is not available
                        // You might want to show an error message or redirect the user to login.
                        print("User ID not available");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart),
                        SizedBox(width: 8),
                        Text('Add to Cart'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
