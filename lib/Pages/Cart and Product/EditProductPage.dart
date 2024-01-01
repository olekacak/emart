import 'dart:convert';
import 'dart:typed_data';

import 'package:emartsystem/Model/UserLoginModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Model/ProductModel.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;
  final UserLoginModel user;

  const EditProductPage({ required this.product, required this.user});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController stockQuantityController = TextEditingController();
  Uint8List? selectedImage;
  String base64String = '';

  @override
  void initState() {
    super.initState();
    // Initialize text controllers and image from the product data
    productNameController.text = widget.product.productName;
    descriptionController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
    categoryController.text = widget.product.category;
    stockQuantityController.text = widget.product.stockQuantity;
    base64String = widget.product.image;
  }

  pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        base64String = base64Encode(imageBytes);

        setState(() {
          // Update the base64String when a new image is picked
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      // Handle error (show a message to the user, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.memory(
                base64.decode(widget.product.image),
                height: 150,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
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
                onPressed: pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Call the updateProduct method to update the product
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

  // UpdateProduct method
  void saveProduct() async {
    if (base64String.isEmpty) {
      _showMessage('Please pick an image.');
      return;
    }

    // Create a new ProductModel instance with the updated values
    ProductModel product = ProductModel(
      productId: widget.product.productId,
      productName: productNameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      category: categoryController.text,
      stockQuantity: stockQuantityController.text,
      image: base64String,
      userId: widget.user.userId,
    );

    bool updated = await product.updateProduct();

    if (updated) {
      // Product updated successfully, show a success message
      _showMessage('Product updated successfully');
      // Navigate back to the previous screen with the updated product data
      Navigator.pop(context, true);
    } else {
      // Handle error or show an error message
      _showMessage('Failed to update the product.');
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
}
