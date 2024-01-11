import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help and Support'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to the eMart Help and Support page. We\'re here to assist you in making the most of our platform. If you have any questions or encounter any issues, you\'ll find helpful information below.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.5,
                  wordSpacing: 1.5,
                  textBaseline: TextBaseline.alphabetic,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Frequently Asked Questions (FAQs)',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'How do I create an account?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'To create an eMart account, simply tap the "Sign Up" button on the login screen. Follow the on-screen instructions to enter your details and create your profile.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'How do I post a product for sale?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '1. Log in to your eMart account.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                '2. Go to dashboard and click the "Switch Hosting," a popup message will display if it\'s you want to start selling and click "Ok" button.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                '3. Then you will go to MyShop page where you can upload your product there.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                '4. Tap the "Add Your Product" button.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                '5. Provide product details, including title, description, price, and images.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                '6. Confirm your listing, and it will be uploaded for others to see.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'How can I search for items?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Use the search bar on the home screen to enter keywords related to the product you\'re looking for. You can also filter results by discount and price range.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'How can I contact customer support?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'For assistance, you can reach out to our customer support team at emart@gmail.com or call us at +013-456-7890. We\'re here to help you.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Getting Started Guide',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Step 1: Registration',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Create an account by providing your name, email, and password. Verify your email address to complete the registration process.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Step 2: Profile Setup',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Add a profile picture and some personal information to make your account stand out.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Step 3: Buying and Selling',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Browse products, add items to your cart, and make secure payments when purchasing. If you want to sell, create listings and manage your shop.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Safety Tips',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Your safety is essential to us. Follow these safety tips:',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                '- Verify user profiles and ratings.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                '- Use secure payment methods.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                '- Be cautious of suspicious activity or offers.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Privacy and Security',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'We take your privacy and security seriously. Our platform is designed with these principles in mind.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Feedback and Support',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Your feedback helps us improve. If you have suggestions or need assistance, reach out to our support team through the app or by emailing emart@gmail.com.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Connect with Us',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Follow us on social media for updates and announcements.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "We're here to make your eMart experience as smooth as possible. If you have any questions or need assistance, don't hesitate to reach out. Thank you for being a part of the eMart community!",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.5,
                  wordSpacing: 1.5,
                  textBaseline: TextBaseline.alphabetic,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Ready to explore, shop, and connect? Let\'s get started!',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
