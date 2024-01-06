import 'dart:convert';
import 'dart:typed_data';
import 'package:emartsystem/Pages/Cart%20and%20Product/AddProductPage.dart';
import 'package:emartsystem/Pages/Cart%20and%20Product/ProductDetailSeller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Cart and Product/DiscountModel.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/Cart and Product/ReviewModel.dart';
import '../../Model/User/UserLoginModel.dart';
import 'Discount.dart';

class MyShopPage extends StatefulWidget {
  final UserLoginModel user;

  MyShopPage({required this.user, Key? key}) : super(key: key);

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
    _loadData(); // Combine the data loading into a single method
    _loadReviews();
    _tabController.addListener(_handleTabChange);
  }

  _loadData() async {
    await _loadProducts();
    await _loadDiscounts();
    await _loadReviews();
  }

  _handleTabChange() {
    setState(() {
      // Trigger a rebuild when the tab changes
    });
  }

  // Method to add a new product and update the product list
  _addProduct() async {
    // Navigate to the AddProductPage and wait for result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(),
      ),
    );

    // Check if a new product was added
    if (result == true) {
      // Reload the product list
      await _loadProducts();
      // Optionally, you can show a message indicating success
      _showMessage('Product added successfully');
    }
  }


  _loadProducts() async {
    List<ProductModel> loadedProducts = await ProductModel.loadAll();
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
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void handleDiscountAdded() {
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
                          'Seller: ${widget.user.username}',
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
          Container(
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Listing'),
                Tab(text: 'Discount'),
                Tab(text: 'Feedback'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 8.0, // Spacing between rows
                  ),
                  itemCount: products
                      .where((product) => product.userId == widget.user.userId)
                      .length,
                  itemBuilder: (context, index) {
                    ProductModel product = products
                        .where((product) => product.userId == widget.user.userId)
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

                    // Replace the return Card(...) with the following:
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailSellerPage(product: product),
                          ),
                        );
                        // Reload the data when the user navigates back to this page
                        _loadProducts();
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: (imageBytes != null) ? Image.memory(imageBytes, fit: BoxFit.cover) : Container(),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                product.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('\RM ${product.price}'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (_tabController.index == 1)
                  ListView.builder(
                    itemCount: discounts
                        .where((discount) => discount.userId == widget.user.userId)
                        .length,
                    itemBuilder: (context, index) {
                      DiscountModel discount = discounts
                          .where((discount) => discount.userId == widget.user.userId)
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
                    review.userId == widget.user.userId &&
                        products.any((product) =>
                        product.productId == review.productId &&
                            product.userId == widget.user.userId))
                        .length,
                    itemBuilder: (context, index) {
                      ReviewModel review = reviews
                          .where((review) =>
                      review.userId == widget.user.userId &&
                          products.any((product) =>
                          product.productId == review.productId &&
                              product.userId == widget.user.userId))
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
                        user: widget.user,
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

