import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Cart and Product/CartModel.dart';
import '../../Model/Transaction/TransactionModel.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int userId = -1;
  List<TransactionModel> currentOrders = [];
  List<TransactionModel> pastOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadTransactions();
  }

  loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    TransactionModel transactionModel = TransactionModel(
      transactionId: 0,
      transactionDate: '',
      status: "",
      deliveryStatus: "",
      cartId: -1,
      paymentOption: "Online Banking",
      voucher: "Free Shipping",
      totalPayment: 0,
      cartProductId: -1,
      price: 0,
      quantity: 0,
      image: '',
      userId: -1,
      productId: -1,
      productName: '',
    );

    if (userId != -1) {
      List<TransactionModel> loadedCurrentOrder = await transactionModel.loadAll();
      List<TransactionModel> currentOrderData = loadedCurrentOrder.where((order) => order.status == 'Pending').toList();

      List<TransactionModel> loadedPastOrder = await transactionModel.loadAll();
      List<TransactionModel> pastOrderData = loadedPastOrder.where((order) => order.status == 'Completed').toList();


      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          currentOrders = currentOrderData;
          pastOrders = pastOrderData;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> receiveOrder(TransactionModel order) async {
    try {
      // Update Cart status
      CartModel cart = CartModel(
        cartId: order.cartId,
        userId: order.userId,
        status: 'Completed', // Update status to "Completed"
      );
      bool cartUpdated = await cart.updateCart();

      // Update Transaction status and deliveryStatus
      if (cartUpdated) {
        order.status = 'Completed'; // Update status to "Completed"
        order.deliveryStatus = 'Shipped'; // Update deliveryStatus to "Shipped"
        bool transactionUpdated = await order.updateTransaction();

        // Return true only if both Cart and Transaction are successfully updated
        return transactionUpdated;
      } else {
        return false;
      }
    } catch (e) {
      print("Error receiving order: $e");
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Current Order'),
            Tab(text: 'Past Order'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrderList(currentOrders),
          buildOrderList(pastOrders),
        ],
      ),
    );
  }

  Widget buildOrderList(List<TransactionModel> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        Uint8List imageBytes = base64.decode(orders[index].image);

        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Row(
              children: [
                Container(
                  width: 80,
                  child: Image.memory(imageBytes),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orders[index].productName),
                      Text('Quantity: ${orders[index].quantity}'),
                      Text('Price: \RM ${orders[index].price.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
                orders[index].status == 'Pending' ? Flexible(
                  child: ElevatedButton(
                    onPressed: () async {
                      bool orderReceived = await receiveOrder(orders[index]);
                      // Additional logic
                    },
                    child: Text('Order Receive'),
                  ),
                ) : Text('Order Received', style: TextStyle(color: Colors.green)),
              ],
            ),
            subtitle: Container(), // Empty container
          ),
        );
      },
    );
  }
}
