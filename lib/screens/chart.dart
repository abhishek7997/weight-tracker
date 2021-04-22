import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class ChartPage extends StatefulWidget {
  static const routeName = '/chartdata';
  @override
  _ChartPage createState() => _ChartPage();
}

class _ChartPage extends State<ChartPage> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  static const bool showAvg = false;
  List globalData = [];
  // List<FlSpot> dummySpots = [
  //   FlSpot(1, 2),
  //   FlSpot(2, 5),
  //   FlSpot(3.5, 3.1),
  //   FlSpot(4, 4),
  //   FlSpot(4.6, 3),
  //   FlSpot(5, 4),
  //   FlSpot(6, 5),
  //   FlSpot(7, 3),
  // ];

  // Get only the weights of the dates that lie within the current week
  // Discard the rest
  void buildData(List w) {
    globalData = w;
    DateTime startDate =
        DateTime.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
    while (startDate.weekday != DateTime.monday) {
      startDate = startDate.subtract(Duration(days: 1));
    }

    globalData.removeWhere(
        (element) => DateTime.parse(element['date']).isBefore(startDate));
    globalData.removeWhere(
        (element) => DateTime.parse(element['date']).isAfter(DateTime.now()));
    //sortList(globalData);
  }

  void sortList(List list) {
    list.sort((a, b) {
      var x = a['date'], y = b['date'];
      return x.compareTo(y);
    });
  }

  // Return the minimum and maximum weights of some date within the current week
  List<double> findMaxMin() {
    double ma = 40, mi = 150;
    for (var v in globalData) {
      ma = max(ma, double.parse(v['weight']));
      mi = min(mi, double.parse(v['weight']));
    }
    return [ma, mi];
  }

  // Get the (x,y) coordinates or spots to draw the graph
  List<FlSpot> getSpots() {
    double x, y;
    List<FlSpot> spots = [];
    spots.clear();
    DateTime startDate =
        DateTime.parse(DateFormat("yyyyMMdd").format(DateTime.now()));

    double searchKey(DateTime st) {
      for (var v in globalData) {
        if (v['date'] == st.toString()) {
          return double.parse(v['weight']);
        }
      }
      return -1;
    }

    while (startDate.weekday != DateTime.monday) {
      startDate = startDate.subtract(Duration(days: 1));
    }

    // Index of day starts from 1 (Monday) to 7(Sunday)
    // Starting i from 0 causes visual problems in the chart
    for (int i = 1; i <= 7; i++) {
      if (searchKey(startDate) != -1) {
        x = startDate.weekday.toDouble();
        y = searchKey(startDate);
        spots.add(FlSpot(x, y));
      } else {
        // If no weight for some date within the week, set the weight to the minimum value of the Y axis of the graph
        spots.add(FlSpot(i.toDouble(),
            globalData.isNotEmpty ? findMaxMin()[1] - 10.0 : 40.0));
      }
      startDate = startDate.add(Duration(days: 1));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final List data = ModalRoute.of(context).settings.arguments;
    buildData(data);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text("Graph for the current week"),
      ),
      body: Container(
        decoration: const BoxDecoration(color: kChartBackgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, right: 26.0, top: 20.0, bottom: 20.0),
                child: LineChart(
                  mainData(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff1b4332),
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff1b4332),
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'MON';
              case 2:
                return 'TUE';
              case 3:
                return 'WED';
              case 4:
                return 'THU';
              case 5:
                return 'FRI';
              case 6:
                return 'SAT';
              case 7:
                return 'SUN';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          interval: 10,
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          // getTitles: (value) {
          //   switch (value.toInt()) {
          //     case 1:
          //       return '10k';
          //     case 3:
          //       return '30k';
          //     case 5:
          //       return '50k';
          //   }
          //   return '';
          // },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff1b4332), width: 1)),
      minX: 1,
      maxX: 7,
      minY: globalData.isNotEmpty ? findMaxMin()[1] - 10.0 : 40,
      maxY: globalData.isNotEmpty ? findMaxMin()[0] + 10.0 : 120,
      // minY: 40.0,
      // maxY: 100.0,
      lineBarsData: [
        LineChartBarData(
          spots: getSpots(),
          isCurved: false,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
