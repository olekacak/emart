import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'Pages/User/UserLogin.dart';


void main() async{
  //Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
  "pk_test_51OPqlnKJ0LDtdxZsOBoO8I7uVmHBBBKnoGEsAr7OMZVm2A0yb6aEjhH7EAvriK4JvsmO6oQ5ipGftSCVIrKCiUbd0007MojtuV";
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  String server = "http://172.20.10.3";

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize("5eabb2f8-09ab-4354-abf5-cef1a5c174cc");

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }

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