import 'dart:convert';

import 'package:flutter/material.dart';

import '../../Controller/Cart and Product/ReviewController.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/Cart and Product/ReviewModel.dart';
import 'ProductDetail.dart';


class FilterAppliedPage extends StatefulWidget {
  const FilterAppliedPage({required this.filteredProducts, Key? key})
      : super(key: key);

  final List<ProductModel> filteredProducts;

  @override
  _FilterAppliedPageState createState() => _FilterAppliedPageState();
}

class _FilterAppliedPageState extends State<FilterAppliedPage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  late ReviewController _reviewController; // Declare here as an instance variable

  @override
  void initState() {
    super.initState();

    _pages = [
      // Add your pages here
    ];

    _reviewController = ReviewController(path: '/reviews'); // Initialize the ReviewController
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text('eMart'), // Change 'Filter Applied' to 'eMart'
          ],
        ),
        automaticallyImplyLeading: false, // Remove the default back button
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7, // Adjust the aspect ratio as needed
          crossAxisSpacing: 20,
          mainAxisSpacing: 8,
        ),
        itemCount: widget.filteredProducts.length, // Use widget.filteredProducts
        itemBuilder: (context, index) {
          ProductModel product = widget.filteredProducts[index]; // Use widget.filteredProducts

          // Fetch the associated ReviewModel for the product
          List<ReviewModel> productReviews = loadReviewsForProduct(product.productId.toString());

          // Calculate the average rating for the product
          double averageRating = productReviews.isEmpty
              ? 0
              : productReviews
              .map((review) => double.parse(review.rating))
              .reduce((a, b) => a + b) /
              productReviews.length;

          return GestureDetector(
            onTap: () {
              // Fetch the associated ReviewModel for the product
              List<ReviewModel> productReviews = loadReviewsForProduct(product.productId.toString());

              // Calculate the average rating for the product
              double averageRating = productReviews.isEmpty
                  ? 0
                  : productReviews
                  .map((review) => double.parse(review.rating))
                  .reduce((a, b) => a + b) /
                  productReviews.length;

              // Navigate to ProductDetailsPage when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    product: product,
                    averageRating: averageRating.toDouble() ?? 0.0, // Convert to double or provide a default value
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
                    base64.decode(product.image),
                    height: 150,
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
                      'Description: ${product.description}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
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
      ),
    );
  }

  // Use your ReviewController to load reviews for a product
  List<ReviewModel> loadReviewsForProduct(String productId) {
    List<ReviewModel> reviews = [];

    // Send a GET request to fetch reviews for the specified productId
    _reviewController.path = '/reviews/$productId';
    _reviewController.get();

    // Check the status code to determine if the request was successful
    if (_reviewController.status() == 200) {
      // Parse the result data into a list of ReviewModel
      dynamic resultData = _reviewController.result();
      if (resultData is List) {
        reviews = resultData.map((reviewData) {
          // Assuming you have a method to create a ReviewModel from JSON data
          return ReviewModel.fromJson(reviewData);
        }).toList();
      }
    }

    return reviews;
  }
}