import 'dart:convert';
import 'dart:typed_data';
import 'package:emartsystem/Pages/AddProductPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/ProductModel.dart';
import '../Model/UserLoginModel.dart';

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
    _loadProducts();
  }

  _loadProducts() async {
    List<ProductModel> loadedProducts = await ProductModel.loadAll();
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
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    ProductModel product = products[index];
                    // Ensure the Base64 string is a multiple of 4 in length
                    String base64Image = product.image!;
                    if (base64Image.length % 4 != 0) {
                      base64Image = base64Image.padRight(base64Image.length + 4 - base64Image.length % 4, '=');
                    }
                    // Decode the Base64 string to bytes
                    Uint8List imageBytes = base64.decode(base64Image);
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Image.memory(imageBytes, fit: BoxFit.cover), // Product image
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(product.productName), // Product name
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
                // Content for Review Tab
                Center(child: Text('Content for Review Tab')),
              ],
            ),
          ),
        ],
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
