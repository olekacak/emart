import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../Model/Cart and Product/ProductModel.dart';
import 'dart:math';

class ProductChartPage extends StatefulWidget {
  const ProductChartPage({super.key});

  @override
  _ProductChartPageState createState() => _ProductChartPageState();
}

class _ProductChartPageState extends State<ProductChartPage> {
  int touchedIndex = -1;
  Map<String, int> categoryCounts = {};

  @override
  void initState() {
    super.initState();
    _loadAndGroupProducts();
  }

  void _loadAndGroupProducts() async {
    var products = await ProductModel.loadAll(category: 'any'); // Adjust as needed
    for (var product in products) {
      categoryCounts[product.category] = (categoryCounts[product.category] ?? 0) + 1;
    }
    setState(() {}); // Refresh UI with the new data
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

  Widget _buildLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Categories'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the top of the screen
        children: [
          Center( // Horizontally center the pie chart
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: _buildPieChart(),
            ),
          ),
          Center( // Horizontally center the legend
            child: _buildLegend(),
          ),
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
            children: <Widget>[
              // ... Dynamic Indicators based on categories
            ],
          ),
        ],
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