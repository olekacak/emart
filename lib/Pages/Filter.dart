import 'package:flutter/material.dart';

import '../Model/UserLoginModel.dart';
import 'HomeCustomer.dart';

class FilterPage extends StatefulWidget {
  final UserLoginModel user;

  const FilterPage({required this.user, Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeValues _currentRangeValues = const RangeValues(20, 60);
  int _starRating = 0;
  bool _isDiscountExpanded = false;
  bool _isPriceRangeExpanded = false;
  bool _isRatingExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.filter_list_sharp, color: Colors.blueGrey),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeCustomerPage(user: widget.user)));
              },
            ),
            const Text(
              'FILTERS',
              style: TextStyle(fontSize: 24,color: Colors.black),

            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          _buildExpansionTile(
            'Discount & Promotion',
            _isDiscountExpanded,
                () {
              setState(() {
                _isDiscountExpanded = !_isDiscountExpanded;
              });
            },
          ),
          if (_isDiscountExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  _buildActionChip('Free Shipping'),
                  _buildActionChip('With Discount'),
                  _buildActionChip('Lowest Price Guarantee'),
                  _buildActionChip('Coins Cashback'),
                ],
              ),
            ),
          _buildExpansionTile(
            'Price range (RM)',
            _isPriceRangeExpanded,
                () {
              setState(() {
                _isPriceRangeExpanded = !_isPriceRangeExpanded;
              });
            },
          ),
          if (_isPriceRangeExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RangeSlider(
                values: _currentRangeValues,
                min: 0,
                max: 200,
                divisions: 10,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
            ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple, // Background color
            ),
            child: const Text(
              'Apply',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          _buildExpansionTile(
            'Rating',
            _isRatingExpanded,
                () {
              setState(() {
                _isRatingExpanded = !_isRatingExpanded;
              });
            },
          ),
          if (_isRatingExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: List.generate(4, (index) => _buildRating(index + 1)),
              ),
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _starRating = 0;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple, // Background color
            ),
            child: const Text(
              'Clear All',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the filter screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Background color
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Apply filters
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Background color
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        // Handle chip action
      },
    );
  }

  Widget _buildRating(int stars) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Icon(
            index < stars ? Icons.star : Icons.star_border,
            color: Colors.amber,
          );
        }),
      ),
      title: Text('from $stars stars'),
      onTap: () {
        setState(() {
          _starRating = stars;
        });
      },
      selected: _starRating == stars,
    );
  }

  Widget _buildExpansionTile(String title, bool isExpanded, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: isExpanded ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),
      onTap: onTap,
    );
  }
}