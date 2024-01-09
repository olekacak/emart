import 'dart:convert';
import 'dart:typed_data';
import 'package:emartsystem/Pages/Cart%20and%20Product/AddProductPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Cart and Product/DiscountModel.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/Cart and Product/ReviewModel.dart';
import 'Discount.dart';
import 'Report.dart';

class MyShopPage extends StatefulWidget {
  @override
  _MyShopPageState createState() => _MyShopPageState();
}

class _MyShopPageState extends State<MyShopPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ProductModel> products;
  late List<DiscountModel> discounts;
  List<ReviewModel> reviews = [];

  Uint8List? selectedImage;
  String base64String = '';
  int userId = -1;
  String name = '';
  String email = '';
  String image = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    products = [];
    discounts = [];
    reviews = [];
    _loadProducts();
    _loadDiscounts();
    _loadReviews();
    _tabController.addListener(_handleTabChange);// Initial data load when the page is created
  }

  _handleTabChange() {
    setState(() {
      // Trigger a rebuild when the tab changes
    });
  }

  _loadProducts() async {
    List<ProductModel> loadedProducts = await ProductModel.loadAll(category: '');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    if (userId != -1) {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      image = prefs.getString('image') ?? '';
      print('SharedPreferences = ${name}');
    }
    setState(() {
      products = loadedProducts;
    });
  }

  _loadReviews() async {
    List<ReviewModel> loadedReviews = await ReviewModel.loadAll();
    setState(() {
      reviews = loadedReviews;
    });
  }

  _loadDiscounts() async {
    try {
      List<DiscountModel> loadedDiscounts = await DiscountModel.loadAll();
      print(loadedDiscounts);
      setState(() {
        discounts = loadedDiscounts;
      });
    } catch (e) {
      print('Error loading discounts: $e');
      // Handle the error as needed
    }
  }

  void _confirmAndDeleteReview(ReviewModel review) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this review?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteReview(review); // Proceed with deletion
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteReview(ReviewModel review) async {
    bool success = await review.deleteReview();
    if (success) {
      _showMessage("Review Deleted Successfully");
      _loadReviews(); // Reload reviews to update the UI
    } else {
      _showMessage("Failed to Delete Review");
    }
  }

  void _showMessage(String msg) {
    if (mounted) {
      // Make sure this context is still mounted/exist
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void handleDiscountAdded() {
    // Reload the discounts or perform any other necessary updates
    // when a new discount is added
    _loadDiscounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: image != null
                          ? MemoryImage(base64Decode(image!))
                          : null,
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seller: ${name}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Listing'),
                Tab(text: 'Discount'),
                Tab(text: 'Feedback'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  if (_tabController.index == 0)
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                        crossAxisSpacing: 8.0, // Spacing between columns
                        mainAxisSpacing: 8.0, // Spacing between rows
                      ),
                      itemCount: products
                          .where((product) => product.userId == userId)
                          .length,
                      itemBuilder: (context, index) {
                        ProductModel product = products
                            .where((product) => product.userId == userId)
                            .toList()[index];
                        // Ensure the Base64 string is a multiple of 4 in length
                        String base64Image = product.image!;
                        if (base64Image.length % 4 != 0) {
                          base64Image = base64Image.padRight(
                            base64Image.length + 4 - base64Image.length % 4,
                            '=',
                          );
                        }
                        // Decode the Base64 string to bytes
                        Uint8List imageBytes = base64.decode(base64Image);
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ClipRect(
                                child: Image.memory(
                                  imageBytes,
                                  fit: BoxFit.contain, // Product image
                                  height: 150.0, // Set a fixed height for the image
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(product.productName),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('\RM ${product.price}'), // Product price
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  if (_tabController.index == 1)
                    ListView.builder(
                      itemCount: discounts
                          .where((discount) => discount.userId == userId)
                          .length,
                      itemBuilder: (context, index) {
                        DiscountModel discount = discounts
                            .where((discount) => discount.userId == userId)
                            .toList()[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                'Discount Name: ${discount.name ?? 'N/A'}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Discount Value: ${discount.value}'),
                                Text(
                                    'Minimum Purchase: ${discount.minPurchaseAmount}'),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else if (_tabController.index == 2)
                    ListView.builder(
                      itemCount: reviews
                          .where((review) =>
                      review.userId == userId &&
                          products.any((product) =>
                          product.productId == review.productId &&
                              product.userId == userId))
                          .length,
                      itemBuilder: (context, index) {
                        ReviewModel review = reviews
                            .where((review) =>
                        review.userId == userId &&
                            products.any((product) =>
                            product.productId == review.productId &&
                                product.userId == userId))
                            .toList()[index];

                        // Find the corresponding ProductModel for the given review
                        ProductModel? associatedProduct = products.firstWhere(
                              (product) => product.productId == review.productId,
                          orElse: () => ProductModel(
                            productId: 0,
                            productName: 'N/A',
                            description: 'N/A',
                            price: 0.0,
                            category: 'N/A',
                            stockQuantity: 'N/A',
                            image: 'N/A',
                          ),
                        );

                        return ListTile(
                          title: Text('Rating: ${review.rating}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Comment: ${review.comment}'),
                              Text('Product ID: ${review.productId}'),
                              Text('Product Name: ${associatedProduct.productName}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _confirmAndDeleteReview(review),
                              ),

                              PopupMenuButton<int>(
                                onSelected: (int item) async {
                                  if (item == 0) {
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();

                                    if (review.reviewId != null) {
                                      await prefs.setInt('selectedReviewId', review.reviewId!);

                                      // Navigate to ReportPage
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ReportPage()),
                                      );
                                    } else {
                                      // Handle the case where reviewId is null
                                      // For example, show an error message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Review ID is not available.'))
                                      );
                                    }
                                  }
                                  // Add more cases here for other menu items if needed
                                },

                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Text('Report'),
                                    ),
                                    // You can add more items here if needed
                                  ];
                                },
                              ),
                            ],
                          ),
                        );

                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      floatingActionButton: _tabController.index == 0 ||
          _tabController.index == 1
          ? Container(
        height: MediaQuery.of(context).size.height -
            kToolbarHeight -
            kBottomNavigationBarHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_tabController.index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductPage(),
                    ),
                  );
                } else if (_tabController.index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiscountPage(
                        onDiscountAdded: handleDiscountAdded,
                      ),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8.0),
                  Text(_getButtonText(_tabController.index)),
                ],
              ),
            ),
          ),
        ),
      )
          : null,

    );
  }

  String _getButtonText(int tabIndex) {
    if (tabIndex == 0) {
      return 'Add Your Product';
    } else if (tabIndex == 1) {
      return 'Add Your Discount';
    } else {
      return 'Add Your Feedback'; // Modify this text as needed
    }
  }
}