import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/Transaction/TransactionController.dart';
import '../../main.dart';

class TransactionModel {
  int? transactionId;
  int userId;
  String transactionDate;
  String status;
  String deliveryStatus;
  int cartId;
  int cartProductId;
  double price;
  int quantity;
  String image;
  int productId;
  String productName;

  String paymentOption;
  String voucher;
  double totalPayment;

  TransactionModel({
    this.transactionId,
    required this.userId,
    required this.transactionDate,
    required this.status,
    required this.deliveryStatus,
    required this.cartId,
    required this.cartProductId,
    required this.price,
    required this.quantity,
    required this.image,
    required this.productId,
    required this.productName,
    required this.paymentOption,
    required this.voucher,
    required this.totalPayment,
  });

  TransactionModel.fromJson(Map<String, dynamic> json)
      : transactionId = json['transaction']['transactionId'] as int? ?? -1,
        userId = json['transaction']['userId'] as int? ?? -1,
        transactionDate = json['transaction']['transactionDate'] as String? ?? '',
        status = json['transaction']['status'] as String? ?? '',
        deliveryStatus = json['transaction']['deliveryStatus'] as String? ?? '',
        cartId = json['transaction']['cartId'] as int? ?? -1,
        paymentOption = json['transaction']['paymentOption'] as String? ?? '',
        voucher = json['transaction']['voucher'] as String? ?? '',
        totalPayment = (json['transaction']['totalPayment'] as num?)?.toDouble() ?? 0.0,
        cartProductId = json['cartProduct']['cartProductId'] as int? ?? -1,
        price = (json['cartProduct']['totalPrice'] as num?)?.toDouble() ?? 0.0,
        quantity = json['cartProduct']['quantity'] as int? ?? 0,
        productId = json['product']['productId'] as int? ?? -1,
        productName = json['product']['productName'] as String? ?? '',
        image = json['product']['image'] as String? ?? '';



  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'transactionDate': transactionDate,
      'status': status,
      'deliveryStatus': deliveryStatus,
      'userId': userId,
      'cartId': cartId,
      'paymentOption': paymentOption,
      'voucher': voucher,
      'totalPayment': totalPayment,
    };
  }

  Future<bool> saveTransaction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    TransactionController transactionController = TransactionController(path: "${MyApp().server}/api/workshop2/transaction.php?userId=$userId");
    print("Transaction Payload: ${toJson()}");
    transactionController.setBody(toJson());
    await transactionController.post();

    if (transactionController.status() == 200) {
      print("raw response: ${transactionController.result()}");
      return true;
    }
    return false;
  }


  Future<bool> updateTransaction() async {
    if (transactionId == null) {
      return false;
    }

    TransactionController transactionController = TransactionController(path: "${MyApp().server}/api/workshop2/transaction.php");
    print("Transaction Payload: ${toJson()}");
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
    print("userId trans ${userId}");
    TransactionController transactionController = TransactionController(path: "${MyApp().server}/api/workshop2/transaction.php?userId=$userId");
    await transactionController.get();

    if (transactionController.status() == 200 && transactionController.result() != null) {
      // Correctly access the "transactions" key from the JSON response
      List<dynamic> transactionsJson = transactionController.result()['transactions'];

      for (var item in transactionsJson) {
        var transactionModel = TransactionModel.fromJson(item);
        result.add(transactionModel);
        print("ProductName: ${transactionModel.productName}");
      }

    }
    return result;
  }

}