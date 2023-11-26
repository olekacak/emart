import 'package:emartsystem/Pages/DashboardCustomer.dart';
import 'package:emartsystem/Pages/HomeCustomer.dart';
import 'package:emartsystem/Pages/HomeSeller.dart';
import 'package:flutter/material.dart';
import 'UserLogin.dart';


void main() async{

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: UserLoginPage(),
    );
  }
}