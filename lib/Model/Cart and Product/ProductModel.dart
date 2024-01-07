import 'package:emartsystem/Controller/Cart%20and%20Product/ProductController.dart';

import '../../Controller/User/UserLoginController.dart';

class ProductModel {
  int? productId;
  int? userId;
  String productName;
  String description;
  double price;
  String category;
  String stockQuantity;
  String image;

  ProductModel({
    this.productId,
    this.userId,
    required this.productName,
    required this.description,
    required this.price,
    required this.category,
    required this.stockQuantity,
    required this.image,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : productId = json['productId'] as int? ?? 0,
        userId = json['userId'] as int? ?? 0,
        productName = json['productName'] as String? ?? '',
        description = json['description'] as String? ?? '',
        price = (json['price'] as num?)?.toDouble() ?? 0.0,
        category = json['category'] as String? ?? '',
        stockQuantity = json['stockQuantity'] as String? ?? '',
        image = json['image'] != null ? json['image'] as String : '';

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'userId': userId,
      'productName': productName,
      'description': description,
      'price': price,
      'category': category,
      'stockQuantity': stockQuantity,
      'image': image,
    };
  }

  static Future<List<ProductModel>> loadAll({required String category}) async {
    List<ProductModel> result = [];
    ProductController productController = ProductController(path: "/api/workshop2/product.php");
    await productController.get();
    if (productController.status() == 200 && productController.result() != null) {
      for (var item in productController.result()) {
        result.add(ProductModel.fromJson(item));
      }
    }
    return result;
  }

  Future<void> loadProductById() async {
    ProductController productController = ProductController(path: "/api/workshop2/product.php");
    productController.setBody({'productId': productId});
    await productController.get();

    if (productController.status() == 200 && productController.result() != null) {
      final updatedData = productController.result()[0] as Map<String, dynamic>;
      // Update the properties of this instance with the updated data
      productId = updatedData['productId'] as int?;
      productName = updatedData['productName'] as String? ?? '';
      description = updatedData['description'] as String? ?? '';
      price = (updatedData['price'] as num?)?.toDouble() ?? 0.0;
      category = updatedData['category'] as String? ?? '';
      stockQuantity = updatedData['stockQuantity'] as String? ?? '';
      image = updatedData['image'] as String? ?? '';
    }
  }

  Future<bool> saveProduct() async {
    ProductController productController = ProductController(path: "/api/workshop2/product.php");
    productController.setBody(toJson());
    await productController.post();

    if (productController.status() == 200) {
      return true;
    }
    return false;
  }


  // Update product method
  Future<bool> updateProduct() async {
    if (productId == null) {
      return false;
    }

    ProductController productController = ProductController(path: "/api/workshop2/product.php");
    productController.setBody(toJson());
    await productController.put();

    if (productController.status() == 200) {
      Map<String, dynamic> result = productController.result();
      if (result.containsKey('message') && result['message'] == 'Product information updated successfully') {
        productId = result['productId'] as int?;
        productName = result['productName'] as String? ?? '';
        description = result['description'] as String? ?? '';
        price = (result['price'] as num?)?.toDouble() ?? 0.0;
        category = result['category'] as String? ?? '';
        stockQuantity = result['stockQuantity'] as String? ?? '';
        image = result['image'] as String? ?? '';

        return true;
      }
    }
    return false;
  }

  Future<bool> deleteProduct() async {
    if (productId == null) {
      // Cannot delete a product without an ID
      return false;
    }

    ProductController productController = ProductController(path: "/api/workshop2/product.php");
    // Set the necessary body or parameters for deletion. Often, this is just the ID.
    productController.setBody({'productId': productId});

    await productController.delete();

    if (productController.status() == 200) {
      return true;
    } else {
      // Print the error message in case of failure
      print('Delete failed. Error: ${productController.result()}');
      return false;
    }
    }

}
