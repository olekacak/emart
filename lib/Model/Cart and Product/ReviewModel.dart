import 'package:flutter/material.dart';

import '../../Controller/Cart and Product/ReviewController.dart';

class ReviewModel {
  int? reviewId;
  int? productId;
  int? userId;
  String rating;
  String comment;
  String reviewDate;

  ReviewModel({
    this.reviewId,
    this.productId,
    this.userId,
    required this.rating,
    required this.comment,
    required this.reviewDate,
  });

  ReviewModel.fromJson(Map<String, dynamic> json)
      : reviewId = json['reviewId'] as int? ?? 0,
        productId = json['productId'] as int? ?? 0,
        userId = json['userId'] as int? ?? 0,
        rating = json['rating'] as String? ?? '',
        comment = json['comment'] as String? ?? '',
        reviewDate = json['reviewDate'] as String? ?? '';

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'productId': productId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'reviewDate': reviewDate,
    };
  }

  static Future<List<ReviewModel>> loadAll() async {
    List<ReviewModel> result = [];
    ReviewController reviewController = ReviewController(
        path: "/api/eMart2/review.php");
    await reviewController.get();
    if (reviewController.status() == 200 && reviewController.result() != null) {
      for (var item in reviewController.result()) {
        result.add(ReviewModel.fromJson(item));
      }
    }
    return result;
  }

  Future<bool> saveReview() async {
    ReviewController reviewController = ReviewController(
        path: "/api/eMart2/review.php");
    reviewController.setBody(toJson());
    await reviewController.post();

    if (reviewController.status() == 200) {
      return true;
    }
    return false;
  }

  Future<bool> updateReview() async {
    if (reviewId == null) {
      return false;
    }

    ReviewController reviewController = ReviewController(
        path: "/api/eMart2/review.php");
    reviewController.setBody(toJson());
    await reviewController.put();
    if (reviewController.status() == 200) {
      Map<String, dynamic> result = reviewController.result();
      return true;
    }
    return false;
  }

}