import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/Transaction/TransactionController.dart';
import '../../main.dart';

class TransactionModel {
  int? transactionId;
  int userId;
  String? transactionDate;
  String? cartStatus;
  String status;
  String? deliveryStatus;
  int? cartId;
  int cartProductId;
  double totalPrice;
  double price;
  int quantity;
  String image;
  int productId;
  String productName;
  String? paymentOption;
  String? voucher;
  double? totalPayment;
  bool hasReview;


  TransactionModel({
    this.transactionId,
    required this.userId,
    required this.transactionDate,
    required this.cartStatus,
    required this.status,
    required this.deliveryStatus,
    required this.cartId,
    required this.cartProductId,
    required this.totalPrice,
    required this.price,
    required this.quantity,
    required this.image,
    required this.productId,
    required this.productName,
    required this.paymentOption,
    required this.voucher,
    required this.totalPayment,
    required this.hasReview,

  });

  TransactionModel.fromJson(Map<String, dynamic> json)
      : transactionId = json['cart']['transactionId'] as int? ?? -1,
        userId = json['cart']['userId'] as int? ?? -1,
        status = json['cartProduct']['status'] as String? ?? '',
        cartId = json['cart']['cartId'] as int? ?? -1,
        cartProductId = json['cartProduct']['cartProductId'] as int? ?? -1,
        totalPrice = (json['cartProduct']['totalPrice'] as num?)?.toDouble() ?? 0.0,
        quantity = json['cartProduct']['quantity'] as int? ?? 0,
        productId = json['product']['productId'] as int? ?? -1,
        productName = json['product']['productName'] as String? ?? '',
        price = (json['product']['price'] as num?)?.toDouble() ?? 0.0,
        image = json['product']['image'] as String? ?? '',
        hasReview = json['hasReview'] as bool? ?? false;


  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'cartProductId': cartProductId,
      'productId': productId,
      'transactionDate': transactionDate,
      'cartStatus': cartStatus,
      'status': status,
      'deliveryStatus': deliveryStatus,
      'userId': userId,
      'cartId': cartId,
      'paymentOption': paymentOption,
      'voucher': voucher,
      'totalPayment': totalPayment,
      'totalPrice': totalPrice,
      'price': price,
    };
  }

  Future<bool> saveTransaction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // userId = prefs.getInt('userId') ?? -1;

    TransactionController transactionController = TransactionController(path: "${MyApp().server}/api/workshop2/transaction.php?userId=$userId");
    // print("Transaction Payload: ${toJson()}");
    transactionController.setBody(toJson());
    await transactionController.post();

    if (transactionController.status() == 200) {
      // print("raw response: ${transactionController.result()}");
      return true;
    }
    return false;
  }


  Future<bool> updateTransaction() async {
    if (transactionId == null) {
      return false;
    }

    TransactionController transactionController = TransactionController(path: "${MyApp().server}/api/workshop2/transaction.php");
    // print("Transaction Payload: ${toJson()}");
    transactionController.setBody(toJson());
    await transactionController.put();

    if (transactionController.status() == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteTransaction() async {
    if (transactionId == null) {
      return false;
    }

    TransactionController transactionController = TransactionController(path: "${MyApp().server}/api/workshop2/transactions.php");
    transactionController.setBody({'transactionId': transactionId});

    await transactionController.delete();

    if (transactionController.status() == 200) {
      return true;
    } else {
      print('Delete failed. Error: ${transactionController.result()}');
      return false;
    }
  }

  Future<List<TransactionModel>> loadAll() async {
    List<TransactionModel> result = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    TransactionController transactionController = TransactionController(path: "${MyApp().server}/api/workshop2/transaction.php?userId=$userId");
    await transactionController.get();

    if (transactionController.status() == 200) {
      final dynamic response = transactionController.result();

      if (response != null && response.containsKey('carts')) {
        final List<dynamic> transactionsJson = response['carts'];

        for (final transactionJson in transactionsJson) {
          // Extract cart-level information from the transaction
          final transactionModel = TransactionModel.fromJson(transactionJson);
          result.add(transactionModel);
          // print("User ID: ${transactionModel.userId}");
          // print("Cart ID: ${transactionModel.cartId}");
          // print("transactionId: ${transactionModel.transactionId}");

          if (transactionJson.containsKey('products')) {
            final List<dynamic> productsJson = transactionJson['products'];

            for (final productJson in productsJson) {
              // Extract product-level information from the productJson
              final productModel = TransactionModel.fromJson(productJson);
              result.add(productModel);
              // print("CartProduct ID: ${productModel.cartProductId}");
              print("productJson: $productJson");
              print("totalPrice : ${productModel.totalPrice}");
              // print("Product ID: ${productModel.productId}");
              // print("ProductName: ${productModel.productName}");
              // print("Status: ${productModel.status}");
              // print("Quantity: ${productModel.quantity}");

            }
          }
        }
      }
    }
    return result;
  }


}