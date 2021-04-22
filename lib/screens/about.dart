import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class About extends StatefulWidget {
  static const routeName = '/about';
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12.0,
                    spreadRadius: 2.0,
                    //offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
                image: DecorationImage(
                  image: AssetImage('images/WeightMonBlue.png'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  Text(
                    'Weight Tracker',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Made by M.Abhishek',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    '2020',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
