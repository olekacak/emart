import 'package:emartsystem/Controller/User/OneSignalController.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Cart and Product/ReportModel.dart';

class ReportPage extends StatefulWidget {

  final int adminId;
  final int userId;
  const ReportPage({required this.adminId, required this.userId});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? selectedReportType;
  TextEditingController reasonController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int? selectedReviewId;

  @override
  void initState() {
    super.initState();
    _retrieveSelectedReviewId();

    print("This admin: ${widget.adminId}");
    print("This seller: ${widget.userId}");
  }

  Future<void> _retrieveSelectedReviewId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedReviewId = prefs.getInt('selectedReviewId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: selectedReportType,
              decoration: InputDecoration(
                labelText: 'Type of Report',
                border: OutlineInputBorder(),
              ),
              items: ['Spam', 'Violation', 'Others']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedReportType = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            // Additional fields and actions can be added here
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (selectedReportType != null && reasonController.text.isNotEmpty) {
                  ReportModel newReport = ReportModel(
                    reviewId: selectedReviewId,
                    type: selectedReportType!,
                    reason: reasonController.text,
                  );

                  bool result = await newReport.saveReport();
                  if (result) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Success"),
                          content: Text("Report submitted successfully."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.of(context).pop(); // Navigate back to the previous page (MyShopPage)
                              },
                            ),
                          ],
                        );
                      },
                    );

                    OneSignalController notify = OneSignalController();
                    List<String> targetUsers = [];
                    targetUsers.add(widget.userId.toString());
                    targetUsers.add(widget.adminId.toString());

                    notify.SendNotification("New Report Received", "Piqa Ad lawa", targetUsers);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit report')));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
                }
              },
              child: Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
