import 'package:flutter/material.dart';

import '../../Model/Cart and Product/ReviewModel.dart';

class SeeReviewPage extends StatefulWidget {
  final int productId;
  final int userId;

  SeeReviewPage({Key? key, required this.productId, required this.userId}) : super(key: key);

  @override
  _SeeReviewPageState createState() => _SeeReviewPageState();
}

class _SeeReviewPageState extends State<SeeReviewPage> {
  List<ReviewModel> reviews = [];

  @override
  void initState() {
    super.initState();
    loadReviews();
  }

  loadReviews() async {
    dynamic reviews = await ReviewModel.loadById(widget.productId, widget.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Reviews'),
      ),
      body: reviews.isEmpty
          ? Center(child: Text('No reviews yet'))
          : ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reviews[index].rating),
            subtitle: Text(reviews[index].comment),
            trailing: Text(reviews[index].reviewDate),
          );
        },
      ),
    );
  }
}
