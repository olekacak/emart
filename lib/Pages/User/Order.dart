import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Cart and Product/CartModel.dart';
import '../../Model/Cart and Product/CartProductModel.dart';
import '../../Model/Cart and Product/ReviewModel.dart';
import '../../Model/Transaction/TransactionModel.dart';
import '../Cart and Product/Cart.dart';
import 'ReviewOrder.dart';
import 'SeeReview.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int userId = -1;
  int cartId = -1;
  int selectedQuantity = 1;
  bool success = false;
  List<TransactionModel> currentOrders = [];
  List<TransactionModel> pastOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadTransactions();
    initializeCart();
  }

  Future<void> initializeCart() async {
    int? retrievedCartId = await checkCart();
    if (retrievedCartId != null) {
      setState(() {
        cartId = retrievedCartId;
      });
    } else {
      print('Failed to retrieve cartId');
    }
  }


  Future<int?> checkCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    if (userId != -1) {
      // Load all carts for the user
      List<CartModel> carts = await CartModel.loadAll();

      // Find the 'in process' cart
      CartModel inProcessCart = carts.firstWhere((cart) => cart.cartStatus == 'in process', orElse: () => CartModel(cartStatus: ''));

      // If an 'in process' cart is found, retrieve its cartId
      if (inProcessCart.cartStatus == 'in process') {
        int? cartId = inProcessCart.cartId;
        print('Retrieved cartId: $cartId');

        // Store the cartId in shared preferences
        await prefs.setInt('cartId', cartId ?? -1);

        return cartId;
      } else {
        // If no 'in process' cart exists, create a new one
        bool cartCreated = await CartModel(userId: userId, cartStatus: 'in process').addCart();

        if (cartCreated) {
          print('New cart created successfully');

          // Fetch the carts again after creating a new cart
          carts = await CartModel.loadAll();

          // Retrieve the newly created cart with status 'in process'
          CartModel newCart = carts.firstWhere((cart) => cart.cartStatus == 'in process', orElse: () => CartModel(cartStatus: ''));
          int? cartId = newCart.cartId;
          print('Retrieved cartId: $cartId');

          // Store the cartId in shared preferences
          await prefs.setInt('cartId', cartId ?? -1);

          return cartId;
        } else {
          print('Failed to create a new cart');
          return null;
        }
      }
    }
  }

  loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;

    TransactionModel transactionModel = TransactionModel(
      transactionId: 0,
      transactionDate: '',
      cartStatus: "",
      status: "",
      deliveryStatus: "",
      cartId: -1,
      paymentOption: "Online Banking",
      voucher: "Free Shipping",
      totalPayment: 0,
      cartProductId: -1,
      totalPrice: 0,
      price: 0,
      quantity: 0,
      image: '',
      userId: -1,
      productId: -1,
      productName: '',
      hasReview: false,
    );

    if (userId != -1) {
      List<TransactionModel> loadedCurrentOrder = await transactionModel
          .loadAll();
      List<TransactionModel> currentOrderData = loadedCurrentOrder
          .where((order) => order.status == 'Pending')
          .toList();

      List<TransactionModel> loadedPastOrder = await transactionModel.loadAll();
      List<TransactionModel> pastOrderData = loadedPastOrder
          .where((order) => order.status == 'Completed')
          .toList();

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
        cartStatus: 'Completed', // Update status to "Completed"
      );
      bool cartUpdated = await cart.updateCart();

      // Update Transaction status and deliveryStatus
      if (cartUpdated) {
        order.transactionId;
        order.cartId;
        order.userId;
        order.cartStatus = 'Completed';
        order.status = 'Completed';
        order.deliveryStatus = 'Shipped';
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

        print("orders[index].price ${orders[index].price}");
        return Card(
          margin: EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeeReviewPage(
                    productId: orders[index].productId,
                    userId: userId,
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
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
                        Text('Price: \RM ${orders[index].totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  _buildOrderButtons(orders[index]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderButtons(TransactionModel order) {
    // Add your conditional logic for button rendering here
    if (order.status == 'Pending') {
      return ElevatedButton(
        onPressed: () async {
          bool received = await receiveOrder(order);
          if (received) {
            loadTransactions();
          }
        },
        child: Text('Order Received'),
      );
    } else if (order.status == 'Completed') {
      return FutureBuilder<bool>(
        future: ReviewModel.loadById(order.userId, order.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          bool hasReview = snapshot.data ?? false;
          return hasReview
              ? ElevatedButton(
            onPressed: () => handleAddToCart(order, order.price),
            child: Text('Add to Cart'),
          )
              : ElevatedButton(
            onPressed: () => navigateToReviewPage(order),
            child: Text('Add Review'),
          );
        },
      );
    } else {
      return Container();
    }
  }


  void navigateToReviewPage(TransactionModel order) async {
    bool hasReview = await ReviewModel.loadById(order.userId, order.productId);

    if (hasReview) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Review Already Submitted'),
            content: Text('You have already submitted a review for this product.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewOrderPage(
            productName: order.productName,
            productId: order.productId,
            userId: order.userId,
          ),
        ),
      ).then((_) {
        // Update the order state to reflect that a review has been added
        setState(() {
          order.hasReview = true;
        });
      });
    }
  }

  void handleAddToCart(TransactionModel order, double price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to Cart'),
          content: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Do you want to add this item to your cart?'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                if (userId != -1) {
                  // User ID is available, proceed to add the product to the cart
                  CartProductModel cartProduct = CartProductModel(
                    cartId: cartId,
                    productName: order.productName, // Set productName from order
                    productId: order.productId,
                    quantity: selectedQuantity,
                    totalPrice: order.price * selectedQuantity,
                    price: order.price,
                    status: '',
                  );

                  print("totalPrice add is ${order.totalPrice}");
                  print("price add is ${order.price}");
                  // Call the saveCartProduct method on the cartProduct instance
                  success = await cartProduct.saveCartProduct();
                  if (success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to add product to cart.',
                        ),
                      ),
                    );
                  }
                } else {
                  // Handle the case where userId is not available
                  // You might want to show an error message or redirect the user to login.
                  print("User ID not available");
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart),
                  SizedBox(width: 8),
                  Text('Add to Cart'),
                ],
              ),
            ),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel')
            ),
          ],
        );
      },
    );
  }

}