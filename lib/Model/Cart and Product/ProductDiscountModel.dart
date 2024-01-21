
import '../../Controller/Cart and Product/ProductDiscountController.dart';
import '../../main.dart';

class ProductDiscountModel {
  int? productDiscountId;
  int? discountId;
  int? productId;
  int? userId;
  String name;
  String value;
  String minPurchaseAmount;
  static String? server;

  ProductDiscountModel({
    this.productDiscountId,
    this.discountId,
    this.productId,
    this.userId,
    required this.name,
    required this.value,
    required this.minPurchaseAmount,
  });

  ProductDiscountModel.fromJson(Map<String, dynamic> json)
      : productDiscountId = json['productDiscountId'] as int? ?? 0,
        productId = json['productId'] as int? ?? 0,
        userId = json['userId'] as int? ?? 0,
        discountId = json['discountId'] as int? ?? 0,
        name = json['name'] as String? ?? '',
        value = json['value'] as String? ?? '',
        minPurchaseAmount = json['minPurchaseAmount'] as String? ?? '';

  Map<String, dynamic> toJson() {
    return {
      'productDiscountId': productDiscountId,
      'discountId': discountId,
      'productId': productId,
      'userId': userId,
      'name': name,
      'value': value,
      'minPurchaseAmount': minPurchaseAmount,
    };
  }

  static Future<List<ProductDiscountModel>> loadAll({required String category}) async {
    List<ProductDiscountModel> result = [];
    ProductDiscountController productDiscountController = ProductDiscountController(
        path: "${MyApp().server}/api/workshop2/product_discount.php");
    await productDiscountController.get();
    if (productDiscountController.status() == 200 && productDiscountController.result() != null) {
      for (var item in productDiscountController.result()) {
        result.add(ProductDiscountModel.fromJson(item));
      }
    }
    return result;
  }

  Future<void> loadProductById() async {
    ProductDiscountController productDiscountController = ProductDiscountController(
        path: "${MyApp().server}/api/workshop2/product_discount.php");
    productDiscountController.setBody({'productDiscountId': productDiscountId});
    await productDiscountController.get();

    if (productDiscountController.status() == 200 && productDiscountController.result() != null) {
      final updatedData = productDiscountController.result()[0] as Map<String, dynamic>;
      // Update the properties of this instance with the updated data
      productDiscountId = updatedData['productDiscountId'] as int?;
      productId = updatedData['productId'] as int?;
      userId = updatedData['userId'] as int?;
      discountId = updatedData['discountId'] as int?;
      name = updatedData['name'] as String? ?? '';
      value = updatedData['value'] as String? ?? '';
      minPurchaseAmount = updatedData['minPurchaseAmount'] as String? ?? '';
    }
  }

  Future<bool> saveProduct() async {
    ProductDiscountController productDiscountController = ProductDiscountController(
        path: "${MyApp().server}/api/workshop2/product_discount.php");
    productDiscountController.setBody(toJson());
    await productDiscountController.post();

    if (productDiscountController.status() == 200) {
      return true;
    }
    return false;
  }

  // Update product discount method
  Future<bool> updateProductDisc() async {
    if (productId == null) {
      return false;
    }

    ProductDiscountController productDiscountController = ProductDiscountController(
        path: "${MyApp().server}/api/workshop2/product_discount.php");
    productDiscountController.setBody(toJson());
    await productDiscountController.put();

    if (productDiscountController.status() == 200) {
      Map<String, dynamic> result = productDiscountController.result();
      if (result.containsKey('message') && result['message'] == 'Discount information updated successfully') {
        productId = result['productId'] as int?;
        productDiscountId = result['productDiscountId'] as int?;
        productId = result['productId'] as int?;
        userId = result['userId'] as int?;
        discountId = result['discountId'] as int?;
        name = result['name'] as String? ?? '';
        value = result['value'] as String? ?? '';
        minPurchaseAmount = result['minPurchaseAmount'] as String? ?? '';

        return true;
      }
    }
    return false;
  }

/*  Future<bool> deleteProduct() async {
    if (productDiscountId == null) {
      // Cannot delete a product without an ID
      return false;
    }

    ProductDiscountController productDiscountController = ProductDiscountController(
        path: "${MyApp().server}/api/workshop2/product_discount.php");
    // Set the necessary body or parameters for deletion. Often, this is just the ID.
    productDiscountController.setBody({'productDiscountId': productDiscountId});

    await productDiscountController.delete();

    if (productDiscountController.status() == 200) {
      return true;
    } else {
      // Print the error message in case of failure
      print('Delete failed. Error: ${productDiscountController.result()}');
      return false;
    }
  }*/

}