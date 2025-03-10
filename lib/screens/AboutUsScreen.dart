import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  final String title;

  const AboutUsScreen({super.key, required this.title});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text(
              'Welcome to the Weight Bridge Record Control!',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Our goal is to streamline the weight management process for trucks and commercial vehicles. Our innovative software ensures accurate weight measurements, efficient data management, and real-time monitoring to improve operational efficiency.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'User-Friendly Interface:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            Text(
              '- Designed for operators, drivers, and company management.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              '- Simplifies recording of truck weights.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              '- Ensures compliance with regulations.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              '- Aids in generating reports for analysis.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Text(
              'Our Commitment:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            Text(
              'Our team consists of experienced developers and industry professionals dedicated to enhancing the logistics sector through technology. We believe that with the right tools, businesses can operate more efficiently and sustainably.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for choosing us as your trusted partner in weight record management. Together, let\'s drive the future of logistics!',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
