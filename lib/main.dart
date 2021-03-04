import 'package:flutter/material.dart';
import 'screens/HomePage.dart';
import './screens/chart.dart';
import './screens/NotEnoughData.dart';
import './screens/about.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        ChartPage.routeName: (context) => ChartPage(),
        NotEnoughData.routeName: (context) => NotEnoughData(),
        About.routeName: (context) => About(),
      },
    );
  }
}
