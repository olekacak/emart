import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About eMart'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Mobile Marketplace (eMart)!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16.0),
              Text(
                "eMart is the ultimate platform for buying and selling within "
                    "our campus community. We are more than just a marketplace; "
                    "we're a community-focused solution designed to make your "
                    "campus life easier, more sustainable, and fun.",
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16.0),
              Text(
                'Our mission is simple: to create a vibrant, secure, and '
                    'eco-friendly ecosystem where students and staff can easily '
                    'purchase or sell items. We believe in fostering a culture of '
                    'sustainability and convenience, helping you save money and '
                    'resources, all while strengthening our campus community.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16.0),
              Text(
                'Offering a variety of foods such as snacks, instant meals, '
                    'breakfast options, and desserts, eMart caters to the unique '
                    'culinary needs of campus life. We ensure you find exactly '
                    'what you need, right at your doorstep.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16.0),
              Text(
                'We are not just a platform; we are a community. eMart is a '
                    'space where students and faculty come together to share '
                    'ideas and experiences. We\'re committed to building '
                    'connections and fostering a sense of belonging on campus.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16.0),
              Text(
                'Our app is designed with you in mind: intuitive, easy to '
                    'navigate, and safe. We ensure a smooth and hassle-free '
                    'experience, whether you\'re browsing, buying, or selling.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16.0),
              Text(
                'Your safety is our top priority. We\'ve implemented stringent '
                    'measures like verified profiles and a robust review system to '
                    'ensure a trustworthy and secure marketplace. We\'re dedicated '
                    'to creating an environment where you can trade with confidence.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16.0),
              Text(
                'Ready to simplify your campus life? Join Mobile Marketplace '
                    '(eMart) today and immerse yourself in a world of convenience '
                    'and community spirit. Sign up, explore, and connect with '
                    'fellow campus members in just a few clicks.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16.0),
              Text(
                'Welcome aboard eMart – where campus life gets easier, '
                    'greener, and more connected!',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
