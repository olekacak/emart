import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/Cart and Product/ReviewModel.dart';
import '../../Model/User/UserLoginModel.dart';
import 'ViewShop.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;
  final double? averageRating;
  final UserLoginModel? userLogin;

  const ProductDetailsPage({
    Key? key,
    required this.product,
    this.averageRating,
    this.userLogin,
  }) : super(key: key);


  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _selectedQuantity = 1;
  bool isLoading = true;
  bool isLoadingReviews = true;
  UserLoginModel? userDetails;
  List<ProductModel> allProducts = [];
  List<ReviewModel> reviews = [];

  @override
  void initState() {
    super.initState();
    loadAllUsers();
    loadReviews();
    loadAllProducts();
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
    userDetails = allUsers.firstWhere(
          (user) => user.userId == widget.product.userId,
    );
  }

  void loadReviews() async {
    try {
      List<ReviewModel> allReviews = await ReviewModel.loadAll();
      setState(() {
        reviews = allReviews.where((review) => review.productId == widget.product.productId).toList();
        //isLoadingReviews = false;
      });
    } catch (e) {
      print('Error loading reviews: $e');
      setState(() {
        //isLoadingReviews = false;
      });
    }
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

  void loadAllProducts() async {
    try {
      allProducts = await ProductModel.loadAll(category: ''); // Fetch all products
      setState(() {}); // Refresh the UI with the loaded products
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
      body: Stack( // Use Stack to overlay the button over the SingleChildScrollView
        children: [
          SingleChildScrollView( // Wrap the whole Column with SingleChildScrollView
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
                        Text(
                          widget.product.productName,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '\RM${widget.product.price.toString()}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
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
                        if (widget.averageRating != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Average Rating: ${widget.averageRating.toString()}',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (userDetails!.image != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ClipOval(
                                    child: Image.memory(
                                      base64Decode(userDetails!.image!),
                                      height: 100.0, // Adjust the size as needed
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
                                    borderRadius: BorderRadius
                                        .zero, // Rectangular shape
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
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom, // Adjust for keyboard
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '\RM${widget.product.price.toString()}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Select Quantity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (selectedQuantity > 1) {
                                setState(() {
                                  selectedQuantity--; // Decrease quantity
                                });
                              }
                            },
                            color: Colors.black,
                          ),
                          Text('$selectedQuantity'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              final stockQuantity =
                              int.parse(widget.product.stockQuantity);
                              if (selectedQuantity < stockQuantity) {
                                setState(() {
                                  selectedQuantity++; // Increase quantity
                                });
                              }
                            },
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _addToCart(context, selectedQuantity),
                        child: Text('Add to Cart'),
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


  void _addToCart(BuildContext context, int selectedQuantity) {
    // Implement the logic to add the product to the cart with the selected quantity
    // For example: Cart.addToCart(widget.product, selectedQuantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to Cart: $selectedQuantity items'),
      ),
    );
  }

  void _updateQuantity(int quantity) {
    final stockQuantity = int.parse(widget.product.stockQuantity);
    if (quantity >= 1 && quantity <= stockQuantity) {
      setState(() {
        _selectedQuantity = quantity;
      });
    }
  }

  Widget _buildProductGridView(List<ProductModel> products) {
    return GridView.builder(
      shrinkWrap: true,
      // Add shrinkWrap
      physics: NeverScrollableScrollPhysics(),
      // Add physics
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
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
                builder: (context) => ProductDetailsPage(product: product),
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