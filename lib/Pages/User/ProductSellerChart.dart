import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import '../../Model/User/UserLoginModel.dart';
import 'dart:math';

class ProductSellerChartPage extends StatefulWidget {
  const ProductSellerChartPage({Key? key}) : super(key: key);

  @override
  _ProductSellerChartPageState createState() => _ProductSellerChartPageState();
}

class _ProductSellerChartPageState extends State<ProductSellerChartPage> {
  int touchedIndex = -1;
  Map<String, int> categoryCounts = {};
  List<UserLoginModel> users = [];
  int sellerCount = 0;
  int customerCount = 0;

  @override
  void initState() {
    super.initState();
    _loadAndGroupProducts();
    _loadAllUsers();
  }

  void _loadAndGroupProducts() async {
    var products = await ProductModel.loadAll(category: 'any');
    for (var product in products) {
      categoryCounts[product.category] = (categoryCounts[product.category] ?? 0) + 1;
    }
    setState(() {});
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

  Color _getCategoryColor(String category) {
    final hash = category.hashCode;
    final Random random = Random(hash);
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  Widget _buildProductChart() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Product Chart',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2), // Adjusted spacing here
          _buildPieChart(),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildUserTypePieChart() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'User Type Chart',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                    setState(() {
                      if (event is FlLongPressEnd ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                      } else {
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      }
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: showingUserTypeSections(),
              ),
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem("Sellers", Colors.pinkAccent, BoxShape.circle),
                SizedBox(width: 20),
                _buildLegendItem("Customers", Colors.lightBlueAccent, BoxShape.circle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color, BoxShape shape) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: shape,
          ),
        ),
        SizedBox(width: 5),
        Text(text),
      ],
    );
  }

  List<PieChartSectionData> showingUserTypeSections() {
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
          color: Colors.black,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product & Seller Chart'),
      ),
      body: ListView(
        children: [
          _buildProductChart(),
          _buildUserTypePieChart(),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                    setState(() {
                      if (event is FlLongPressEnd ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                      } else {
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      }
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: showingSections(),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: categoryCounts.keys.map((category) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black),
                  ),
                ),
                SizedBox(width: 5),
                Text(category),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return categoryCounts.keys.map((category) {
      final isTouched = categoryCounts[category] == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final shadow = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: _getCategoryColor(category),
        value: categoryCounts[category]?.toDouble() ?? 0,
        title: '${categoryCounts[category]}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadow,
        ),
      );
    }).toList();
  }
}
