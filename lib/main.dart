import 'package:flutter/material.dart';
import 'screens/HomePage.dart';
import './screens/chart.dart';
import './screens/NotEnoughData.dart';
import './screens/about.dart';
import './screens/bmiPage.dart';
import './screens/resultsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Tracker',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF17142A),
        scaffoldBackgroundColor: Color(0xFF17142A),
      ),
      // theme: ThemeData(
      //   primarySwatch: Colors.deepOrange,
      // ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        ChartPage.routeName: (context) => ChartPage(),
        NotEnoughData.routeName: (context) => NotEnoughData(),
        About.routeName: (context) => About(),
        InputPage.routeName: (context) => InputPage(),
        ResultsPage.routeName: (context) => ResultsPage(),
      },
    );
  }
}
