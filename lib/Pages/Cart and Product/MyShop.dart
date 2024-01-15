import 'dart:convert';
import 'dart:typed_data';
import 'package:emartsystem/Pages/Cart%20and%20Product/AddProductPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Cart and Product/DiscountModel.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/Cart and Product/ReviewModel.dart';
import '../../Model/User/UserProfileModel.dart';
import 'Discount.dart';
import 'ProductDetailSeller.dart';
import 'Report.dart';

class MyShopPage extends StatefulWidget {
  @override
  _MyShopPageState createState() => _MyShopPageState();
}

class _MyShopPageState extends State<MyShopPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<UserProfileModel> userFuture;
  late Future<List<ProductModel>> productsFuture;
  late List<DiscountModel> discounts;
  List<ReviewModel> reviews = [];

  Uint8List? selectedImage;
  String base64String = '';
  int userId = -1;
  late UserProfileModel user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    userFuture = _loadUser();
    productsFuture = _loadProducts();
    discounts = [];
    reviews = [];
    _loadProducts();
    _loadReviews();
    _loadDiscounts();
    _tabController.addListener(_handleTabChange);
  }

  _handleTabChange() {
    setState(() {});
  }

  Future<UserProfileModel> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    if (userId != -1) {
      user = UserProfileModel(
        -1,
        userId,
        -1,
        null,
        null,
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        null,
        '',
      );

      // Fetch user data from the server
      await user.loadByUserId();
    }

    return user;
  }

  Future<List<ProductModel>> _loadProducts() async {
    List<ProductModel> loadedProducts = await ProductModel.loadAll(category: '');

    return loadedProducts;
  }

  _loadReviews() async {
    List<ReviewModel> loadedReviews = await ReviewModel.loadAll();
    setState(() {
      reviews = loadedReviews;
    });
  }

  _loadDiscounts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId') ?? -1;

      List<DiscountModel> loadedDiscounts = await DiscountModel.loadAll();
      setState(() {
        discounts = loadedDiscounts;
      });
    } catch (e) {
      print('Error loading discounts: $e');
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReview(review);
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
      _loadReviews();
    } else {
      _showMessage("Failed to Delete Review");
    }
  }

  void _showMessage(String msg) {
    if (mounted) {
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
              child: FutureBuilder<UserProfileModel>(
                future: userFuture,
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.done) {
                    UserProfileModel user = snapshot.data!;
                    return Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: user.image != null
                              ? MemoryImage(base64Decode(user.image!))
                              : null,
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' ${user.name}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' ${user.email}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }else {
                    return CircularProgressIndicator();
                  }
                },
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
            child: FutureBuilder<List<ProductModel>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<ProductModel> products = snapshot.data!;
                  return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: products
                            .where((product) => product.userId == userId)
                            .length,
                        itemBuilder: (context, index) {
                          ProductModel product = products
                              .where((product) => product.userId == userId)
                              .toList()[index];
                          String base64Image = product.image!;
                          if (base64Image.length % 4 != 0) {
                            base64Image = base64Image.padRight(
                              base64Image.length + 4 - base64Image.length % 4,
                              '=',
                            );
                          }
                          Uint8List imageBytes = base64.decode(base64Image);
                          return Card(
                            child: InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailSellerPage(product: product),
                                  ),
                                );
                                _loadProducts();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Expanded(
                                    child: ClipRect(
                                      child: Image.memory(
                                        imageBytes,
                                        fit: BoxFit.contain,
                                        height: 150.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(product.productName),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('\RM ${product.price}'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Quantity: ${product.stockQuantity}'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
                                'Discount Name: ${discount.name ?? 'N/A'}',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Discount Value: ${discount.value}'),
                                  Text(
                                    'Minimum Purchase: ${discount.minPurchaseAmount}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: reviews
                            .where((review) =>
                        review.userId == userId &&
                            products.any((product) =>
                            product.productId == review.productId &&
                                product.userId == userId))
                            .length,

                        itemBuilder: (context, index) {

                          List<ReviewModel> relevantReviews = reviews
                              .where((review) =>
                          review.userId == userId &&
                              products.any((product) =>
                              product.productId == review.productId &&
                                  product.userId == userId))
                              .toList();

                          ReviewModel review = relevantReviews[index];

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
                              isInWishlist: false,
                            ),
                          );

                          // Debug print statements to check data
                          print('Number of relevant reviews: ${relevantReviews.length}');
                          print('Review at index $index: ${review.toJson()}');
                          print('Associated Product: ${associatedProduct.toJson()}');

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
                                        await prefs.setInt('selectedAdminId', 1);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ReportPage(userId: review.userId ?? 0, adminId: 1,)),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Review ID is not available.'))
                                        );
                                      }
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem<int>(
                                        value: 0,
                                        child: Text('Report'),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    ],
                  );
                }else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
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
      return 'Add Your Feedback';
    }
  }
}
