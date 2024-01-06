import 'package:flutter/material.dart';

import '../../Controller/Cart and Product/DiscountController.dart';

class DiscountModel {
  int? discountId;
  int? userId;
  String name;
  String value;
  String minPurchaseAmount;

  DiscountModel({
    this.discountId,
    this.userId,
    required this.name,
    required this.value,
    required this.minPurchaseAmount,
  });

  DiscountModel.fromJson(Map<String, dynamic> json)
      : discountId = json['discountId'] as int? ?? 0,
        userId = json['userId'] as int? ?? 0,
        name = json['name'] as String? ?? '',
        value = json['value'] as String? ?? '',
        minPurchaseAmount = json['minPurchaseAmount'] as String? ?? '';

  Map<String, dynamic> toJson() {
    return {
      'discountId': discountId,
      'userId': userId,
      'name': name,
      'value': value,
      'minPurchaseAmount': minPurchaseAmount,
    };
  }

  static Future<List<DiscountModel>> loadAll() async {
    List<DiscountModel> result = [];
    DiscountController discountController = DiscountController(path: "/api/eMart2/discount.php");
    await discountController.get();
    if (discountController.status() == 200 && discountController.result() != null) {
      for (var item in discountController.result()) {
        result.add(DiscountModel.fromJson(item));
      }
    }
    return result;
  }

  Future<bool> saveDiscount() async {
    DiscountController discountController = DiscountController(path: "/api/eMart2/discount.php");
    discountController.setBody(toJson());
    await discountController.post();

    if (discountController.status() == 200) {
      return true;
    }
    return false;
  }

  Future<bool> updateDiscount() async {
    if (discountId == null) {
      return false;
    }

    DiscountController discountController = DiscountController(path: "/api/eMart2/discount.php");
    discountController.setBody(toJson());
    await discountController.put();
    if (discountController.status() == 200) {
      Map<String, dynamic> result = discountController.result();
      return true;
    }
    return false;
  }
}