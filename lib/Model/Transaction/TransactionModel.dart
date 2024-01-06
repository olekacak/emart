import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Controller/Transaction/TransactionController.dart';

class TransactionModel {
  int? transactionId;
  String transactionDate;
  String status;
  String deliveryStatus;
  int cartId;

  TransactionModel({
    this.transactionId,
    required this.transactionDate,
    required this.status,
    required this.deliveryStatus,
    required this.cartId,
  });

  TransactionModel.fromJson(Map<String, dynamic> json)
      : transactionId = json['transactionId'] as int? ?? 0,
        transactionDate = json['transactionDate'] as String? ?? '',
        status = json['status'] as String? ?? '',
        deliveryStatus = json['deliveryStatus'] as String? ?? '',
        cartId = json['cartId'] as int? ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'transactionDate': transactionDate,
      'status': status,
      'deliveryStatus': deliveryStatus,
      'cartId': cartId,
    };
  }

  Future<bool> saveTransaction() async {
    TransactionController transactionController = TransactionController(path: "/api/eMart2/transaction.php");
    transactionController.setBody(toJson());
    await transactionController.post();

    if (transactionController.status() == 200) {
      return true;
    }
    return false;
  }

  Future<bool> updateTransaction() async {
    if (transactionId == null) {
      return false;
    }

    TransactionController transactionController = TransactionController(path: "/api/eMart2/transaction.php");
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

    TransactionController transactionController = TransactionController(path: "/api/eMart2/transactions.php");
    transactionController.setBody({'transactionId': transactionId});

    await transactionController.delete();

    if (transactionController.status() == 200) {
      return true;
    } else {
      print('Delete failed. Error: ${transactionController.result()}');
      return false;
    }
  }

  static Future<List<TransactionModel>> loadAll() async {
    List<TransactionModel> result = [];
    TransactionController transactionController = TransactionController(path: "/api/eMart2/transaction.php");
    await transactionController.get();
    if (transactionController.status() == 200 && transactionController.result() != null) {
      for (var item in transactionController.result()) {
        result.add(TransactionModel.fromJson(item));
      }
    }
    return result;
  }
}