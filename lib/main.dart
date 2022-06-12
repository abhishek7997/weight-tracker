import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import './screens/about_page.dart';
import './screens/bmi_page.dart';
import './screens/chart_page.dart';
import './screens/not_enough_data_page.dart';
import './screens/results_page.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDateFormatting();
  FlutterNativeSplash.remove();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Tracker',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF17142A),
          scaffoldBackgroundColor: Color(0xFF17142A),
          fontFamily: 'Montserrat'),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        ChartPage.routeName: (context) => ChartPage(),
        NotEnoughData.routeName: (context) => NotEnoughData(),
        About.routeName: (context) => About(),
        InputPage.routeName: (context) => InputPage(),
        ResultsPage.routeName: (context) => ResultsPage(
              resultText: '',
              bmiResult: '',
              interpretation: '',
            ),
      },
    );
  }
}
