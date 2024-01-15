import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/User/UserLoginModel.dart';

class AddProductPage extends StatefulWidget {
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
  int userId = -1;

  String selectedCategory = 'snacks';

  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;
    setState(() {});
  }

  ProductModel newProduct = ProductModel(
    productName: '',
    description: '',
    price: 0.0,
    category: '',
    stockQuantity: '',
    image: '',
    userId: 0,
    isInWishlist: false,
  );

  pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                    SizedBox(height: 16.0),
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16.0,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'snacks',
                          child: Text('Snacks'),
                        ),
                        DropdownMenuItem(
                          value: 'instant food',
                          child: Text('Instant Food'),
                        ),
                        DropdownMenuItem(
                          value: 'breakfast',
                          child: Text('Breakfast'),
                        ),
                        DropdownMenuItem(
                          value: 'dessert',
                          child: Text('Dessert'),
                        ),
                      ],
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
                    // Display the picked image
                    selectedImage != null
                        ? Image.memory(
                      selectedImage!,
                      height: 100,
                    )
                        : Container(),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  saveProduct();
                },
                child: Text('Save Product'),
              ),
            ),
          ),
        ],
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
    newProduct.category = selectedCategory; // Use the selectedCategory
    newProduct.stockQuantity = stockQuantityController.text;
    newProduct.image = base64String;
    newProduct.userId = userId;

    // Save the product
    bool saved = await newProduct.saveProduct();
    print('Product saved: $saved');
    if (saved) {
      // Product saved successfully, navigate back to the previous screen
      Navigator.pop(context, true);
    } else {
      // Handle error or show an error message
      _showMessage('Failed to save the product.');
    }
  }
}
