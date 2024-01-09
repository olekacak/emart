import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Cart and Product/ReviewModel.dart';
import '../../Model/Cart and Product/ReportModel.dart';
import 'ReviewDetails.dart';

class ReviewReportPage extends StatefulWidget {
  @override
  _ReviewReportPageState createState() => _ReviewReportPageState();
}

class _ReviewReportPageState extends State<ReviewReportPage> {
  Future<List<ReviewModel>>? reviewsFuture;
  Future<List<ReportModel>>? reportsFuture;

  @override
  void initState() {
    super.initState();
    reviewsFuture = ReviewModel.loadAll();
    reportsFuture = ReportModel.loadAll();
  }

  Future<void> _saveSelectedReviewId(int reviewId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedReviewId', reviewId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review Reports"),
      ),
      body: FutureBuilder<List<ReviewModel>>(
        future: reviewsFuture,
        builder: (context, reviewSnapshot) {
          if (reviewSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (reviewSnapshot.hasError || !reviewSnapshot.hasData) {
            return Center(child: Text('Error: ${reviewSnapshot.error}'));
          }

          return FutureBuilder<List<ReportModel>>(
            future: reportsFuture,
            builder: (context, reportSnapshot) {
              if (reportSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (reportSnapshot.hasError || !reportSnapshot.hasData) {
                return Center(child: Text('Error: ${reportSnapshot.error}'));
              }

              // Filter reviews that have a report
              var reviewsWithReports = reviewSnapshot.data!
                  .where((review) => reportSnapshot.data!
                  .any((report) => report.reviewId == review.reviewId))
                  .toList();

              return ListView.builder(
                itemCount: reviewsWithReports.length,
                itemBuilder: (context, index) {
                  ReviewModel review = reviewsWithReports[index];
                  ReportModel report = reportSnapshot.data!.firstWhere((r) => r.reviewId == review.reviewId);

                  return Card(
                    child: ListTile(
                      title: Text('Report Type: ${report.type}', style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Comment: ${review.comment}'),
                          Text('Date: ${review.reviewDate}'),
                        ],
                      ),
                      onTap: () async {
                        await _saveSelectedReviewId(review.reviewId!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewDetailsPage(), // Replace with your Product Report Page
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
