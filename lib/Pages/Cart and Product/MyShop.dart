import 'dart:convert';
import 'dart:typed_data';
import 'package:emartsystem/Pages/Cart%20and%20Product/AddProductPage.dart';
import 'package:emartsystem/Pages/Cart%20and%20Product/ProductDetailSeller.dart';
import 'package:flutter/material.dart';
import '../../Model/ProductModel.dart';
import '../../Model/UserLoginModel.dart';

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
  Uint8List? selectedImage;
  String base64String = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    products = [];
    _loadProducts(); // Initial data load when the page is created
  }

  _loadProducts() async {
    List<ProductModel> loadedProducts = await ProductModel.loadAll(category: '');
    setState(() {
      products = loadedProducts;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      backgroundImage: widget.user.image != null
                          ? MemoryImage(base64Decode(widget.user.image!))
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
                  Tab(text: 'Review'),
                ],
              ),
            ),
            // Removed Expanded around TabBarView
            Container(
              height: 500, // Set a fixed height or calculate dynamically
              child: TabBarView(
                controller: _tabController,
                children: [
                  GridView.builder(
                    // Ensure you have enough space for GridView
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Since it's inside SingleChildScrollView
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      ProductModel product = products[index];
                      Uint8List? imageBytes;
                      try {
                        String base64Image = product.image!;
                        base64Image = base64Image.padRight((base64Image.length + 3) & ~3, '=');
                        imageBytes = base64.decode(base64Image);
                      } catch (e) {
                        print('Error decoding Base64 string: $e');
                        // Optionally set imageBytes to a placeholder image
                      }

                      return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailSellerPage(product: product, user: widget.user),
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
                      )
                      );
                    },
                  ),
                  Center(child: Text('Content for Review Tab')),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage(user: widget.user)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
