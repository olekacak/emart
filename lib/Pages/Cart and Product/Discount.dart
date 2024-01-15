import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Cart and Product/DiscountModel.dart';

typedef OnDiscountAddedCallback = void Function();

class DiscountPage extends StatefulWidget {
  final OnDiscountAddedCallback onDiscountAdded;

  const DiscountPage({required this.onDiscountAdded});

  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {

  int userId = -1;

  String selectedName = 'With Discount'; // Set the default value to 'With Discount'
  String selectedValue = '5% discount'; // Set the default value to '5% discount'
  String selectedMin = 'RM5'; // Set the default value to 'RM5'

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;
    setState(() {});
  }

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

  // Update the discountNameOptions list to only include 'With Discount'
  List<String> discountNameOptions = ['With Discount'];

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
                    // Update the default selected value when changing the name
                    selectedValue = '5% discount';
                  });
                },
                hint: Text('Select Discount Name'),
              ),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Discount Value'),
                  DropdownButton<String>(
                    value: selectedValue,
                    items: ['5% discount', '10% discount']
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            saveDiscount();
          },
          child: Text('Save Discount'),
        ),
      ),
    );
  }

  void saveDiscount() async {
    newDiscount = DiscountModel(
      name: selectedName,
      value: selectedValue,
      minPurchaseAmount: selectedMin,
      userId: userId,
    );

    bool saved = await newDiscount.saveDiscount();
    print('Discount saved: $saved');
    if (saved) {
      widget.onDiscountAdded();
      Navigator.pop(context);
    } else {
      _showMessage('Failed to save the discount.');
    }
  }

}
