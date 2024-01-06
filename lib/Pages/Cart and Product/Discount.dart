import 'package:flutter/material.dart';

import '../../Model/Cart and Product/DiscountModel.dart';
import '../../Model/User/UserLoginModel.dart';

typedef OnDiscountAddedCallback = void Function();

class DiscountPage extends StatefulWidget {
  final UserLoginModel user;
  final OnDiscountAddedCallback onDiscountAdded;

  const DiscountPage({required this.user, required this.onDiscountAdded});

  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  String selectedName = 'Free Shipping';
  String selectedValue = '-'; // Set the default value to '-'
  String selectedMin = 'RM5'; // Set the default value to 'RM5'

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  DiscountModel newDiscount = DiscountModel(
    name: '',
    value: '',
    minPurchaseAmount: '',
    userId: 0,
  );

  // Add options for the discount names
  List<String> discountNameOptions = ['Free Shipping', 'With Discount'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Discount'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Discount Name'),
              DropdownButton<String>(
                value: selectedName,
                items: discountNameOptions.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedName = newValue!;
                    // If the selected name is 'Free Shipping', set selectedValue to '-'
                    selectedValue = newValue == 'Free Shipping' ? '-' : '5% discount';
                  });
                },
                hint: Text('Select Discount Name'),
              ),
              SizedBox(height: 16.0),
              // Show/hide the discount value based on the selected discount name
              if (selectedName != 'Free Shipping')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Discount Value'),
                    DropdownButton<String>(
                      value: selectedValue,
                      items: ['5% discount', '10% discount', '15% discount', '20% discount']
                          .map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      hint: Text('Select Value'),
                    ),
                  ],
                ),
              Text('Minimum Purchase'),
              Row(
                children: [
                  DropdownButton<String>(
                    value: selectedMin,
                    items: ['RM5', 'RM10'].map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedMin = newValue!;
                      });
                    },
                    hint: Text('Select Minimum Purchase'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      // Align the button at the bottom center
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Call the saveDiscount method to save the discount
            saveDiscount();
          },
          child: Text('Save Discount'),
        ),
      ),
    );
  }

  // Save Discount method
  void saveDiscount() async {
    // Set values in the DiscountModel
    newDiscount.name = selectedName;
    newDiscount.value = selectedValue;
    newDiscount.minPurchaseAmount = selectedMin;
    newDiscount.userId = widget.user.userId;

    bool saved = await newDiscount.saveDiscount();
    print('Discount saved: $saved');
    if (saved) {
      // Discount saved successfully, notify the callback function
      widget.onDiscountAdded();
      // Navigate back to the previous screen
      Navigator.pop(context);
    } else {
      // Handle error or show an error message
      _showMessage('Failed to save the discount.');
    }
  }
}