import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/Cart and Product/ReportController.dart';

class ReportModel {
  int? reportId;
  int? reviewId;
  String type;
  String reason;
  DateTime? dateTime;

  ReportModel({
    this.reportId,
    this.reviewId,
    required this.type,
    required this.reason,
    this.dateTime,
  });

  ReportModel.fromJson(Map<String, dynamic> json)
      : reportId = json['reportId'] as int? ?? 0,
        reviewId = json['reviewId'] as int? ?? 0,
        type = json['type'] as String? ?? '',
        reason = json['reason'] as String? ?? '',
        dateTime = json['dateTime'] != null
            ? DateTime.parse(json['dateTime'])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'reviewId': reviewId,
      'type': type,
      'reason': reason,
      //'dateTime': dateTime,
    };
  }


  static Future<List<ReportModel>> loadAll() async {
    List<ReportModel> result = [];
    ReportController reportController = ReportController(
        path: "/api/eMart2/report.php");
    await reportController.get();
    if (reportController.status() == 200 && reportController.result() != null) {
      for (var item in reportController.result()) {
        result.add(ReportModel.fromJson(item));
      }
    }
    return result;
  }

  Future<bool> saveReport() async {
    ReportController reportController = ReportController(
        path: "/api/eMart2/report.php");
    reportController.setBody(toJson());
    await reportController.post();

    if (reportController.status() == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteReport() async {
    if (reportId == null) {
      // Cannot delete a product without an ID
      return false;
    }

    ReportController reportController = ReportController(path:
    "/api/eMart2/report.php");
    // Set the necessary body or parameters for deletion. Often, this is just the ID.
    reportController.setBody({'reportId': reportId});

    await reportController.delete();

    if (reportController.status() == 200) {
      return true;
    } else {
      // Print the error message in case of failure
      print('Delete failed. Error: ${reportController.result()}');
      return false;
    }
  }

}