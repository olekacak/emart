import 'dart:convert';

import 'package:flutter/material.dart';
import '../../Model/ProductModel.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
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
            SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Show the bottom sheet when the button is pressed
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      // Return the widget for the bottom sheet content
                      return _buildBottomSheetContent(context);
                    },
                  );
                },
                icon: Icon(Icons.shopping_cart),
                label: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Quantity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle the quantity selection
                  // For now, let's just print the selected quantity
                  print('Quantity Selected: 1');
                  // You can add your logic to update the cart with the selected quantity
                },
                child: Text('1'),
              ),
              ElevatedButton(
                onPressed: () {
                  print('Quantity Selected: 2');
                },
                child: Text('2'),
              ),
              ElevatedButton(
                onPressed: () {
                  print('Quantity Selected: 3');
                },
                child: Text('3'),
              ),
              // Add more quantity options as needed
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Price: \RM${product.price.toString()}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
