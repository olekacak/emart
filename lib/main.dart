import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'Pages/User/UserLogin.dart';


void main() async{
  //Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
  "pk_test_51OPqlnKJ0LDtdxZsOBoO8I7uVmHBBBKnoGEsAr7OMZVm2A0yb6aEjhH7EAvriK4JvsmO6oQ5ipGftSCVIrKCiUbd0007MojtuV";
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