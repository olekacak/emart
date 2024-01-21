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
    selectedReview = reviews.firstWhere(
          (review) => review.reviewId == reviewId,
    );

    // Fetch the corresponding report
    List<ReportModel> reports = await ReportModel.loadAll();
    correspondingReport = reports.firstWhere(
          (report) => report.reviewId == reviewId,
    );

    if (selectedReview != null) {
      List<UserLoginModel> users = await UserLoginModel.loadAll();
      reviewUser = users.firstWhere(
            (user) => user.userId == selectedReview!.userId,
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (reviewUser != null &&
        reviewUser!.image != null &&
        reviewUser!.image!.isNotEmpty) {
      imageBytes = base64Decode(reviewUser!.image!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Review and Report Details"),
      ),
      body: selectedReview == null || correspondingReport == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDetailItem("Report Type", correspondingReport!.type),
            _buildDetailItem("Report Reason", correspondingReport!.reason),
            SizedBox(height: 10),
            _buildDetailItem("Review Comment", selectedReview!.comment),
            _buildDetailItem("Review Date", selectedReview!.reviewDate),
            SizedBox(height: 10),
            _buildDetailItem("User Name", reviewUser!.name),
            SizedBox(height: 10),
            //_buildUserAvatar(imageBytes),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }

  Widget _buildUserAvatar(Uint8List? imageBytes) {
    return CircleAvatar(
      backgroundImage: imageBytes != null
          ? Image
          .memory(imageBytes)
          .image
          : AssetImage('assets/default_avatar.png'), // Provide a default image
      radius: 50,
    );
  }
}
