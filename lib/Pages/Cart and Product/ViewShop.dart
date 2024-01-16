import 'package:flutter/material.dart';
import 'dart:convert';
import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/User/UserLoginModel.dart';
import 'ProductDetail.dart';

class ViewShopPage extends StatefulWidget {
  final int userId;

  ViewShopPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ViewShopPageState createState() => _ViewShopPageState();
}

class _ViewShopPageState extends State<ViewShopPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ProductModel> userProducts = [];
  UserLoginModel? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    loadUserProducts();
    loadUserInfo();
  }

  void loadUserInfo() async {
    try {
      List<UserLoginModel> allUsers = await UserLoginModel.loadAll();
      setState(() {
        userDetails = allUsers.firstWhere(
              (user) => user.userId == widget.userId,
        );
      });
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  void loadUserProducts() async {
    try {
      userProducts = await ProductModel.loadAll(category: '');
      userProducts = userProducts.where((product) => product.userId == widget.userId).toList();
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildAppBarTitle(UserLoginModel userDetails) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage: userDetails.image != null
              ? MemoryImage(base64Decode(userDetails.image!))
              : null,
          radius: 20.0, // Adjusted radius size for AppBar
          backgroundColor: Colors.grey,
          child: userDetails.image == null
              ? Icon(Icons.person, size: 20.0)
              : null,
        ),
        SizedBox(width: 10),
        Text(
          userDetails.name,
          style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: userDetails != null ? _buildAppBarTitle(userDetails!) : Text('View Shop'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,  // Set the text color of the tabs to white
          tabs: [
            Tab(text: 'Products'),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildProductGridView(userProducts),
    );
  }

  Widget _buildProductGridView(List<ProductModel> products) {
    return GridView.builder(
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
                Expanded(
                  child: Center(
                    child: product.image.isNotEmpty
                        ? Image.memory(
                      base64.decode(product.image),
                      fit: BoxFit.contain,
                    )
                        : Placeholder(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.productName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\RM${product.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Description: ${product.description}',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Text(
                    'Quantity: ${product.stockQuantity}',
                    style: TextStyle(fontSize: 14, color: Colors.black),
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