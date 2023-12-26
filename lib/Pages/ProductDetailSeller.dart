import 'dart:convert';
import 'package:emartsystem/Model/UserLoginModel.dart';
import 'package:emartsystem/Pages/EditProductPage.dart';
import 'package:flutter/material.dart';
import '../Model/ProductModel.dart';

class ProductDetailSellerPage extends StatelessWidget {
  final UserLoginModel user;
  final ProductModel product;

  const ProductDetailSellerPage({Key? key, required this.product, required this.user})
      : super(key: key);

  // Function to handle product deletion
  void _deleteProduct(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              // Call the deleteProduct method to delete the product
              final deleted = await product.deleteProduct();

              if (deleted) {
                // Product deleted successfully, show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product deleted successfully'),
                  ),
                );
                Navigator.of(context).pop(true); // Close the dialog with success flag
              } else {
                // Handle deletion failure (show an error message)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete the product'),
                  ),
                );
                Navigator.of(context).pop(false); // Close the dialog with failure flag
              }
            },
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Navigate back to MyShopPage if deletion was successful
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(product: product, user: user),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteProduct(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
  }
}
