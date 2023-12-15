// import 'package:flutter/material.dart';
//
// import '../Model/ProductModel.dart';
// import 'Cart.dart';
//
// class ProductDetailsPage extends StatelessWidget {
//   final Product product;
//
//   ProductDetailsPage({required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         //title: Text(product.name),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.shopping_cart_outlined),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => CartPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.asset('assets/images/product_image.jpg'),
//               SizedBox(height: 16),
//               Text(
//                 '${product.name}',
//                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Price: ${product.price}',
//                 style: TextStyle(fontSize: 16, color: Colors.green),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Rating: ${product.rating}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 16),
//               // Voucher Section
//               Text(
//                 'Available Voucher',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               ElevatedButton(
//                 onPressed: () {
//                   // Add your voucher claim logic here
//                   _showVoucherClaimedDialog(context);
//                 },
//                 child: Text('Claim Voucher'),
//               ),
//               SizedBox(height: 16),
//               // TabBar and TabBarView
//               DefaultTabController(
//                 length: 2,
//                 child: Column(
//                   children: [
//                     TabBar(
//                       tabs: [
//                         Tab(text: 'Details'),
//                         Tab(text: 'Reviews'),
//                       ],
//                     ),
//                     SizedBox(height: 16),
//                     Container(
//                       height: 200,
//                       child: TabBarView(
//                         children: [
//                           Container(
//                             child: Text('Product details go here.'),
//                           ),
//                           Container(
//                             child: Text('Reviews go here.'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           _showCartBottomSheet(context);
//         },
//         label: Text('Add to Cart'),
//         icon: Icon(Icons.shopping_cart),
//         backgroundColor: Colors.purple, // Customize the button color as needed
//         splashColor: Colors.grey, // Customize the splash color as needed
//         elevation: 5.0, // Customize the elevation as needed
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0), // Adjust the border radius as needed
//         ),
//         heroTag: 'add_to_cart_button', // Unique tag to avoid conflicts with other FloatingActionButton widgets
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   // Function to show the cart bottom sheet
//   void _showCartBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) => _CartBottomSheet(),
//     );
//   }
//
//   // Function to show a dialog when the voucher is claimed
//   void _showVoucherClaimedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Voucher Claimed'),
//           content: Text('You have successfully claimed the voucher!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class _CartBottomSheet extends StatefulWidget {
//   @override
//   _CartBottomSheetState createState() => _CartBottomSheetState();
// }
//
// class _CartBottomSheetState extends State<_CartBottomSheet> {
//   int _quantity = 1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // Set to min to adjust height
//         mainAxisAlignment: MainAxisAlignment.end, // Align at the bottom
//         children: [
//           Container(
//             alignment: Alignment.center, // Center the container
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Cart',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center, // Center the row
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.remove),
//                       onPressed: () {
//                         setState(() {
//                           // Ensure the quantity does not go below 1
//                           _quantity = _quantity > 1 ? _quantity - 1 : 1;
//                         });
//                       },
//                     ),
//                     Text(
//                       'Quantity: $_quantity',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.add),
//                       onPressed: () {
//                         setState(() {
//                           // You can set a maximum limit for the quantity if needed
//                           _quantity++;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Add to Cart logic here
//                     _addToCart(context, _quantity);
//                     Navigator.pop(context); // Close the bottom sheet after adding to cart
//                   },
//                   child: Text('Add to Cart'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _addToCart(BuildContext context, int quantity) {
//     // Implement your add to cart logic here
//     // You can use the 'product' and 'quantity' variables
//   }
// }
