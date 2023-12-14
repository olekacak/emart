import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/ProductModel.dart';
import '../Model/UserLoginModel.dart';

class AddProductPage extends StatefulWidget {
  final UserLoginModel user;

  const AddProductPage({required this.user});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController stockQuantityController = TextEditingController();
  Uint8List? selectedImage;
  String base64String = '';

  ProductModel newProduct = ProductModel(
    productName: '',
    description: '',
    price: 0.0,
    category: '',
    stockQuantity: '',
    image: '',
    userId: 0,
  );


  pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        base64String = base64Encode(imageBytes);

        setState(() {
          // Update the ProductModel instance's image property
          newProduct.image = base64String;
        });

        _showMessage("Image picked successfully");
      }
    } catch (e) {
      print('Error picking image: $e');
      // Handle error (show a message to the user, etc.)
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: stockQuantityController,
                decoration: InputDecoration(labelText: 'Stock Quantity'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: pickImage, // Use the pickImage method as the onPressed callback
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Call the saveProduct method to save the product
                  saveProduct();
                },
                child: Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AddProduct method
  void saveProduct() async {
    print('saveProduct method called');
    if (base64String.isEmpty) {
      _showMessage('Please pick an image.');
      return;
    }

    // Update the existing ProductModel instance with the entered values
    newProduct.productName = productNameController.text;
    newProduct.description = descriptionController.text;
    newProduct.price = double.parse(priceController.text);
    newProduct.category = categoryController.text;
    newProduct.stockQuantity = stockQuantityController.text;
    newProduct.image = base64String;
    newProduct.userId = widget.user.userId;

    // Save the product
    bool saved = await newProduct.saveProduct();
    print('Product saved: $saved');
    if (saved) {
      // Product saved successfully, navigate back to the previous screen
      Navigator.pop(context);
    } else {
      // Handle error or show an error message
      _showMessage('Failed to save the product.');
    }
  }

}
