import 'dart:convert';
import 'package:emartsystem/Model/User/UserLoginModel.dart';
import 'package:emartsystem/Pages/Cart%20and%20Product/EditProductPage.dart';
import 'package:flutter/material.dart';
import '../../Model/Cart and Product/ProductModel.dart';

class ProductDetailSellerPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailSellerPage({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductDetailSellerPageState createState() => _ProductDetailSellerPageState();
}

class _ProductDetailSellerPageState extends State<ProductDetailSellerPage> {
  // Add any necessary state variables here

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
              final deleted = await widget.product.deleteProduct();

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
        title: Text('Product Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // Navigate to the EditProductPage and wait for it to complete
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(product: widget.product),
                ),
              );

              // Check if the result is true (indicating a successful update)
              if (result == true) {
                // Fetch the updated product data and update the UI
                await widget.product.loadProductById(); // Implement a method in your ProductModel to reload the data from the database
                setState(() {
                  // Update the UI with the latest product data
                });
              }
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
              base64.decode(widget.product.image),
              height: 150,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.productName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '\RM${widget.product.price.toString()}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Description: ${widget.product.description}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Quantity: ${widget.product.stockQuantity}',
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
