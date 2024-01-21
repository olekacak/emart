import 'package:flutter/material.dart';
import '../../Model/Cart and Product/ReviewModel.dart';

class ReviewOrderPage extends StatefulWidget {
  final String productName;
  final int productId;
  final int userId;

  ReviewOrderPage({
    required this.productName,
    required this.productId,
    required this.userId,
  });

  @override
  _ReviewOrderPage createState() => _ReviewOrderPage();
}

class _ReviewOrderPage extends State<ReviewOrderPage> {
  double _rating = 0.0;
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product: ${widget.productName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Your Rating:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            RatingBar(
              onRatingChanged: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Your Review:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await submitReview();
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitReview() async {
    // Assuming you have a ReviewModel instance
    ReviewModel review = ReviewModel(
      productId: widget.productId,
      userId: widget.userId,
      rating: _rating.toString(),
      comment: _commentController.text,
      reviewDate: DateTime.now().toString(),
    );

    // Save the review
    var response = await review.saveReview();

    if (response != null && response is bool) {
      // Check if the response is a boolean (success indicator)
      if (response) {
        // Review submitted successfully
        // You can add additional logic here, e.g., navigate back to the order details page
        Navigator.pop(context);
      } else {
        // Handle review submission failure
        // You may want to display an error message to the user
        // or retry the submission
      }
    } else {
      // Handle unexpected response format
      print('Unexpected response format: $response');
      // You may want to display an error message to the user
      // or retry the submission
    }
  }

}

class RatingBar extends StatefulWidget {
  final ValueChanged<double> onRatingChanged;

  RatingBar({required this.onRatingChanged});

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
            (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _rating = index + 1.0;
              });
              widget.onRatingChanged(_rating);
            },
            child: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              size: 30,
              color: Colors.amber,
            ),
          );
        },
      ),
    );
  }
}
