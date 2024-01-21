import 'package:flutter/material.dart';

import '../../Model/Cart and Product/DiscountModel.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/Cart and Product/ReviewModel.dart';
import '../../Model/User/UserLoginModel.dart';
import '../HomeCustomer.dart';
import 'FilterApplied.dart';
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
  late List<DiscountModel> discounts;
  late Set<String> uniqueDiscountNames = Set<String>();
  late double _minPrice;
  late double _maxPrice;

  // Assume you have a list of products
  late List<ProductModel> products;
  late List<ReviewModel> reviews = []; // Initialize the reviews list

  String? _selectedDiscountName; // Variable to store the selected discount name
  bool _isButtonClicked = false; // Variable to track button click status
  Set<String> _selectedDiscountNames = Set<String>();

  @override
  void initState() {
    super.initState();
    _minPrice = _currentRangeValues.start;
    _maxPrice = _currentRangeValues.end;
    discounts = [];
    _loadDiscounts();
    products = [];
    _loadProducts();
    _loadReviews(); // Load reviews for each product
  }

  _loadReviews() async {
    try {
      // Initialize the reviews list
      reviews = [];

      for (var product in products) {
        // Assuming your ReviewModel has a property named productId
        List<ReviewModel> productReviews =
        reviews.where((review) => review.productId == product.productId)
            .toList();

        // Calculate the average rating for the product
        double averageRating = productReviews.isEmpty
            ? 0
            : productReviews.map((review) => double.parse(review.rating))
            .reduce((a, b) => a + b) / productReviews.length;

        // Add a new ReviewModel instance with the calculated average rating
        ReviewModel averageRatingReview = ReviewModel(
          productId: product.productId,
          userId: widget.user.userId,
          rating: averageRating.toString(),
          comment: '',
          // You can set a default comment or fetch it from the database as well
          reviewDate: DateTime.now()
              .toString(), // Set the current date as the review date
        );

        reviews.add(averageRatingReview);
      }
    } catch (e) {
      print('Error loading reviews: $e');
      // Handle the error as needed
    }
  }


  _loadDiscounts() async {
    try {
      List<DiscountModel> loadedDiscounts = await DiscountModel.loadAll();
      setState(() {
        // Clear the existing unique names
        uniqueDiscountNames.clear();

        // Filter out repeated names and update the discounts list
        discounts = loadedDiscounts.where((discount) {
          bool isUnique = uniqueDiscountNames.add(discount.name ?? '');
          return isUnique;
        }).toList();
      });
    } catch (e) {
      print('Error loading discounts: $e');
      // Handle the error as needed
    }
  }

  _loadProducts() async {
    // Fetch or load your list of products as needed
    try {
      List<ProductModel> loadedProducts = await ProductModel.loadAll(
          category: '');
      setState(() {
        products = loadedProducts;
      });
    } catch (e) {
      print('Error loading products: $e');
      // Handle the error as needed
    }
  }

  Widget _buildExpansionTile(String title, bool isExpanded, VoidCallback onTap, Widget content) {
    if (title == 'Discount & Promotion') {
      // Exclude the "Discount & Promotion" section
      return SizedBox.shrink();
    }

    return ExpansionTile(
      title: Text(title),
      trailing: isExpanded ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),
      onExpansionChanged: (value) {
        setState(() {
          if (title == 'Price range (RM)') {
            _isPriceRangeExpanded = value;
          } else if (title == 'Rating') {
            _isRatingExpanded = value;
          }
        });
      },
      children: [
        content,
      ],
    );
  }

  Widget _buildPriceRangeSlider() {
    return _buildExpansionTile(
      'Price range (RM)',
      _isPriceRangeExpanded,
          () {
        setState(() {
          _isPriceRangeExpanded = !_isPriceRangeExpanded;
        });
      },
      _buildPriceRangeSliderContent(),
    );
  }

  Widget _buildPriceRangeSliderContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RangeSlider(
        values: _currentRangeValues,
        min: 0,
        max: 100,
        divisions: 10,
        labels: RangeLabels(
          _currentRangeValues.start.round().toString(),
          _currentRangeValues.end.round().toString(),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            _currentRangeValues = values;
            _minPrice = values.start;
            _maxPrice = values.end;

            // Reset the button click status when the range is changed
            _isButtonClicked = false;
          });
        },
      ),
    );
  }


  Widget _buildApplyButton() {
    return ElevatedButton(
      onPressed: () {
        // Apply filters based on selected values (_minPrice, _maxPrice, etc.)
        // You can update the UI or perform any other actions here.

        // For example, you can filter the products based on the selected price range
        List<ProductModel> filteredProducts = products
            .where(
              (product) =>
          product.price >= _minPrice && product.price <= _maxPrice,
        )
            .toList();

        // Update the UI or perform further actions with the filtered products

        // Set the button click status to true
        setState(() {
          _isButtonClicked = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isButtonClicked ? Colors.purple : Colors.deepPurple,
      ),
      child: Text(
        _isButtonClicked ? 'Applied' : 'Apply',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }


  Widget _buildActionChip(String label, DiscountModel discount) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedDiscountName == discount.name,
      onSelected: (bool selected) async {
        setState(() {
          if (selected) {
            _selectedDiscountName = discount.name;
          } else {
            _selectedDiscountName = null;
          }
        });

        // Handle chip action
        // Save or remove the DiscountModel data based on the selected discount name
        if (selected) {
          bool saved = await discount.saveDiscount();
          if (saved) {
            print('Discount data saved successfully for ${discount.name}');
          } else {
            print('Failed to save discount data for ${discount.name}');
          }
        } else {
          // Handle the case where you want to remove the discount data
          // (e.g., call a method to delete the data or set a flag to remove it later)
        }
      },
      backgroundColor: _selectedDiscountName == discount.name
          ? Colors.purple
          : null,
      selectedColor: Colors.purple, // Color when selected
    );
  }

  Widget _buildApplyButtonWithChecks() {
    return ElevatedButton(
      onPressed: () {
        // Apply filters based on selected values (_minPrice, _maxPrice, etc.)
        // You can update the UI or perform any other actions here.

        // For example, you can filter the products based on the selected price range
        List<ProductModel> filteredProducts = products
            .where(
              (product) =>
          product.price >= _minPrice && product.price <= _maxPrice,
        )
            .toList();

        // Update the UI or perform further actions with the filtered products
        setState(() {
          // Reset the button click status when the Apply button is pressed
          if (!_isButtonClicked) {
            _isButtonClicked = true; // Set the button click status to true
            _selectedDiscountName =
            discounts.isNotEmpty ? discounts[0].name : null;
          } else {
            // Handle the case where the button has already been clicked
            print('Button has already been clicked');
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
      ),
      child: const Text(
        'Apply',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Filter',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildExpansionTile(
                  'Discount & Promotion',
                  _isDiscountExpanded,
                      () {
                    setState(() {
                      _isDiscountExpanded = !_isDiscountExpanded;
                    }
                    );
                  },
                  Wrap(
                    spacing: 8.0,
                    alignment: WrapAlignment.center,
                    children: [
                      for (var discount in discounts)
                        _buildActionChip(discount.name ?? '', discount),
                    ],
                  ),
                ),
                _buildPriceRangeSlider(),
                _buildApplyButton(),
                _buildExpansionTile(
                  'Rating',
                  _isRatingExpanded,
                      () {
                    setState(() {
                      _isRatingExpanded = !_isRatingExpanded;
                    });
                  },
                  Column(
                    children: List.generate(
                      1,
                          (index) => _buildRating(),
                    ),
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
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    // Apply filters based on selected values (_minPrice, _maxPrice, etc.)
                    // You can update the UI or perform any other actions here.

                    // For example, you can filter the products based on the selected price range
                    List<ProductModel> filteredProducts = products
                        .where(
                          (product) =>
                      product.price >= _minPrice &&
                          product.price <= _maxPrice,
                    )
                        .toList();

                    // Navigate to FilterAppliedPage with filtered data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FilterAppliedPage(
                              filteredProducts: filteredProducts,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _starRating = starValue;
            });
          },
          child: Icon(
            index < _starRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
        );
      }),
    );
  }
}