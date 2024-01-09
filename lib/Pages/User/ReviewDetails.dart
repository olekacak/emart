import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Cart and Product/ReportModel.dart';
import '../../Model/Cart and Product/ReviewModel.dart';
import '../../Model/User/UserLoginModel.dart';

class ReviewDetailsPage extends StatefulWidget {
  @override
  _ReviewDetailsPageState createState() => _ReviewDetailsPageState();
}

class _ReviewDetailsPageState extends State<ReviewDetailsPage> {
  ReviewModel? selectedReview;
  ReportModel? correspondingReport;
  UserLoginModel? reviewUser;


  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int reviewId = prefs.getInt('selectedReviewId') ?? 0;

    // Fetch the review with the selected ID
    List<ReviewModel> reviews = await ReviewModel.loadAll();
    selectedReview = reviews.firstWhere((review) => review.reviewId == reviewId,
        //orElse: () => null
        );

    // Fetch the corresponding report
    List<ReportModel> reports = await ReportModel.loadAll();
    correspondingReport = reports.firstWhere((report) => report.reviewId == reviewId,
        //orElse: () => null
    );

    if (selectedReview != null) {
      List<UserLoginModel> users = await UserLoginModel.loadAll();
      reviewUser = users.firstWhere((user) => user.userId == selectedReview!.userId,
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (reviewUser != null && reviewUser!.image != null && reviewUser!.image!.isNotEmpty) {
      imageBytes = base64Decode(reviewUser!.image!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Review and Report Details"),
      ),
      body: selectedReview == null || correspondingReport == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Report Type: ${correspondingReport!.type}"),
          Text("Report Reason: ${correspondingReport!.reason}"),
          SizedBox(height: 20),
          Text("Review Comment: ${selectedReview!.comment}"),
          Text("Review Date: ${selectedReview!.reviewDate}"),
          SizedBox(height: 10),
          Text("User ID: ${selectedReview!.userId}"),

          Text("User Name: ${reviewUser!.name}"),
          imageBytes != null
              ? CircleAvatar(
            backgroundImage: MemoryImage(imageBytes),
            radius: 50, // Adjust the size as needed
          )
              : CircleAvatar(
            child: Icon(Icons.person),
            radius: 50, // Adjust the size as needed
          ),
        ],
      ),
    );
  }
}
