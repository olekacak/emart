// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// import '../../Model/User/UserLoginModel.dart';
//
// class UserPage extends StatelessWidget {
//   final List<UserLoginModel> users; // Assume this list is populated
//
//   UserPage({Key? key, required this.users}) : super(key: key);
//
//   Map<String, double> calculateSellerCustomerPercentages(List<UserLoginModel> users) {
//     int totalUsers = users.length;
//     int sellerCount = users.where((user) => user.sellerAccount == 'true').length;
//     int customerCount = totalUsers - sellerCount;
//
//     double sellerPercentage = (sellerCount / totalUsers) * 100;
//     double customerPercentage = (customerCount / totalUsers) * 100;
//
//     return {
//       'Sellers': sellerPercentage,
//       'Customers': customerPercentage,
//     };
//   }
//
//
//   Widget buildPieChart(Map<String, double> data) {
//     return PieChart(
//       PieChartData(
//         sections: data.entries.map((entry) {
//           return PieChartSectionData(
//             color: entry.key == 'Sellers' ? Colors.blue : Colors.red,
//             value: entry.value,
//             title: '${entry.value.toStringAsFixed(1)}%',
//             radius: 50,
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Map<String, double> percentages = calculateSellerCustomerPercentages(users);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Statistics'),
//       ),
//       body: Center(
//         child: buildPieChart(percentages),
//       ),
//     );
//   }
// }
