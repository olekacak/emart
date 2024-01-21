import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Cart and Product/CartModel.dart';
import '../../Model/Cart and Product/CartProductModel.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/Cart and Product/ReviewModel.dart';
import '../../Model/User/UserLoginModel.dart';
import '../../Model/User/WishlistModel.dart';
import 'Cart.dart';
import 'ViewShop.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final double? averageRating;
  const ProductDetailPage({
    Key? key,
    required this.product, this.averageRating,
  }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedQuantity = 1;
  bool success = false;
  int userId = -1;
  int cartId = -1;
  int wishlistId = -1;

  bool isFavorite = false;
  int productId = -1;
  bool isLoading = true;
  bool isLoadingReviews = true;
  UserLoginModel? userDetails;
  List<ProductModel> allProducts = [];
  List<ReviewModel> reviews = [];


  @override
  void initState() {
    super.initState();
    loadUserId();
    initializeCart();
    checkIfProductIsFavorite();
    loadAllUsers();
    loadReviews();
    loadAllProducts();
  }

  Future<void> checkIfProductIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    if (userId != -1) {
      isFavorite = await WishlistModel.loadById(userId, widget.product.productId!);
      setState(() {});
    }
  }


  void toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;
    if (userId != -1) {
      if (!isFavorite) {
        // If it's not in the wishlist, add it
        WishlistModel wishlistItem = WishlistModel(
          userId: userId,
          productId: widget.product.productId,
          product: widget.product,
          isFavorite: true,
        );
        bool added = await wishlistItem.addToWishlist();
        if (added) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added to wishlist'),
            ),
          );
        }
      } else {
        // If it's already in the wishlist, remove it
        WishlistModel wishlistItem = WishlistModel(
          wishlistId: wishlistId,
          userId: userId,
          productId: widget.product.productId,
          product: widget.product,
          isFavorite: false,
        );

        bool removed = await wishlistItem.removeFromWishlist(userId, widget.product.productId!);

        if (removed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Removed from wishlist'),
            ),
          );
        }
      }

      // Update the favorite status
      setState(() {
        isFavorite = !isFavorite;
      });
    }
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
      // Load all carts for the user
      List<CartModel> carts = await CartModel.loadAll();

      // Find the 'in process' cart
      CartModel inProcessCart = carts.firstWhere((cart) => cart.cartStatus == 'in process', orElse: () => CartModel(cartStatus: ''));

      // If an 'in process' cart is found, retrieve its cartId
      if (inProcessCart.cartStatus == 'in process') {
        int? cartId = inProcessCart.cartId;
        print('Retrieved cartId: $cartId');

        // Store the cartId in shared preferences
        await prefs.setInt('cartId', cartId ?? -1);

        return cartId;
      } else {
        // If no 'in process' cart exists, create a new one
        bool cartCreated = await CartModel(userId: userId, cartStatus: 'in process').addCart();

        if (cartCreated) {
          print('New cart created successfully');

          // Fetch the carts again after creating a new cart
          carts = await CartModel.loadAll();

          // Retrieve the newly created cart with status 'in process'
          CartModel newCart = carts.firstWhere((cart) => cart.cartStatus == 'in process', orElse: () => CartModel(cartStatus: ''));
          int? cartId = newCart.cartId;
          print('Retrieved cartId: $cartId');

          // Store the cartId in shared preferences
          await prefs.setInt('cartId', cartId ?? -1);

          return cartId;
        } else {
          print('Failed to create a new cart');
          return null;
        }
      }
    }
  }

  loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;
  }

  void loadAllUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<UserLoginModel> allUsers = await UserLoginModel.loadAll();
      setUserDetails(allUsers);
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void setUserDetails(List<UserLoginModel> allUsers) {
    if (allUsers.isNotEmpty) {
      userDetails = allUsers.firstWhere(
            (user) => user.userId == widget.product.userId,
      );
    } else {
      userDetails = null; // Set userDetails to null when the list is empty
    }

    // Debug print to check userDetails
    print('User Details: $userDetails');
  }


  void loadReviews() async {
    try {
      List<ReviewModel> allReviews = await ReviewModel.loadAll();
      setState(() {
        reviews = allReviews.where((review) => review.productId == widget.product.productId).toList();
      });
    } catch (e) {
      print('Error loading reviews: $e');
      setState(() {});
    }
  }

  void loadAllProducts() async {
    try {
      allProducts = await ProductModel.loadAll(category: '');
      setState(() {});
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          widget.product.productName,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Image.memory(
                        base64.decode(widget.product.image),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.product.productName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                onPressed: () {
                                  toggleFavorite();
                                },
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '\RM${widget.product.price.toString()}',
                                style: TextStyle(fontSize: 16, fontWeight:
                                FontWeight.bold, color: Colors.green),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Description: ${widget.product.description}',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Quantity: ${widget.product.stockQuantity}',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLoading && userDetails != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(191, 147, 229, 0.5),
                        borderRadius: BorderRadius.circular(10),
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Seller Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Add a Row to properly align seller information
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (userDetails!.image != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                                  child: ClipOval(
                                    child: Image.memory(
                                      base64Decode(userDetails!.image!),
                                      height: 100.0,
                                      width: 100.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  ' ${userDetails!.name}',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (userDetails != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewShopPage(
                                                userId: userDetails!.userId!),
                                      ),
                                    );
                                  }
                                },
                                child: Text('View Shop'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(191, 147, 229, 0.5),
                      borderRadius: BorderRadius.circular(10),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Product Ratings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildReviewListView(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(191, 147, 229, 0.5),
                      borderRadius: BorderRadius.circular(10),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'You May Also Like',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildProductGridView(allProducts),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton.icon(
              onPressed: () => _showModalBottomSheet(context),
              icon: Icon(Icons.shopping_cart),
              label: Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to be more flexible
      builder: (BuildContext context) {
        int selectedQuantity = 1; // Initialize selectedQuantity here

        return FractionallySizedBox(
          heightFactor: 0.5, // Half of the screen height
          child: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: double.infinity, // Span the entire width of the screen
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.product.productName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SingleChildScrollView(
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isFavorite ? Icons.favorite : Icons.favorite_border,
                                          color: isFavorite ? Colors.red : null,
                                        ),
                                        onPressed: toggleFavorite,
                                      ),
                                    ],
                                  ),
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
                                          totalPrice: widget.product.price * selectedQuantity,
                                          price: widget.product.price,
                                          status: '',
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
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      shape: RoundedRectangleBorder( // Adds rounded corners
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildReviewListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        ReviewModel review = reviews[index];
        return ListTile(
          title: Text('Rating: ${review.rating}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comment: ${review.comment}'),
              Text('Review Date: ${review.reviewDate}'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductGridView(List<ProductModel> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        ProductModel product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(product: product),
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
                  base64.decode(product.image),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.productName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '\RM${product.price.toString()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Quantity: ${product.stockQuantity}',
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
    );
  }
}