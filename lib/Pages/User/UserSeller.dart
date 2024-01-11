import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../Model/User/UserLoginModel.dart';

class UserSellerPage extends StatefulWidget {
  @override
  _UserSellerPageState createState() => _UserSellerPageState();
}

class _UserSellerPageState extends State<UserSellerPage> {
  List<UserLoginModel> users = [];
  int sellerCount = 0;
  int customerCount = 0;
  int touchedIndex = -1; // Add this for interaction

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  void _loadAllUsers() async {
    users = await UserLoginModel.loadAll();
    _countUserTypes();
    setState(() {});
  }

  void _countUserTypes() {
    sellerCount = 0;
    customerCount = 0;
    for (var user in users) {
      if (user.sellerAccount == "true") {
        sellerCount++;
      } else {
        customerCount++;
      }
    }
  }

  List<PieChartSectionData> showingSections() {
    int totalUsers = users.length;
    double sellerPercentage = (totalUsers == 0) ? 0 : (sellerCount / totalUsers) * 100;
    double customerPercentage = (totalUsers == 0) ? 0 : (customerCount / totalUsers) * 100;

    return List.generate(2, (i) {
      final isSeller = i == 0;
      final value = isSeller ? sellerPercentage : customerPercentage;
      final color = isSeller ? Colors.pinkAccent : Colors.lightBlueAccent;

      return PieChartSectionData(
        color: color,
        value: value,
        title: '${value.toStringAsFixed(1)}%',
        radius: 50.0,
        titleStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
      );
    });
  }

  Widget _buildLegend() {
    return Container(
      alignment: Alignment.center, // Center the legend horizontally
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrink-wrap the contents
        children: [
          _buildLegendItem('Sellers', Colors.pinkAccent),
          SizedBox(width: 10),
          _buildLegendItem('Customers', Colors.lightBlueAccent),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
          ),
        ),
        SizedBox(width: 5),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Sellers'),
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2, // Adjust the height of the Pie Chart
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: showingSections(),
              ),
            ),
          ),
          _buildLegend(), // Positioned closer to the Pie Chart
        ],
      ),
    );
  }
}

