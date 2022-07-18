import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../models/weights.dart';

class ChartPage extends StatefulWidget {
  static const routeName = '/chartdata';

  @override
  _ChartPage createState() => _ChartPage();
}

class _ChartPage extends State<ChartPage> {
  late List weights = [];
  final kLineChartGradient = LinearGradient(colors: kgradientColors);
  final kBelowBarGradient = LinearGradient(
      colors: kgradientColors.map((color) => color.withOpacity(0.3)).toList());

  // Return the minimum and maximum weights of some date within the current week
  List<double> findMaxMin() {
    double ma = 40, mi = 150;
    for (Map w in weights) {
      ma = max(ma, double.parse(w['weight']));
      mi = min(mi, double.parse(w['weight']));
    }
    return [ma, mi];
  }

  @override
  void initState() {
    weights = UserWeights().getGraphData();
    weights.log();
  }

  String valueToDayString(value) {
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
  }

  // Get the (x,y) coordinates or spots to draw the graph
  List<FlSpot> getSpots() {
    double x, y;
    List<FlSpot> spots = [];

    DateTime startDate =
        DateTime.parse(DateFormat("yyyyMMdd").format(DateTime.now()));

    double searchKey(DateTime st) {
      for (var w in weights) {
        if (w['date'] == st.toString()) {
          return double.parse(w['weight']);
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
        spots.add(FlSpot(
            i.toDouble(), weights.isNotEmpty ? findMaxMin()[1] - 10.0 : 40.0));
      }
      startDate = startDate.add(Duration(days: 1));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Text("Graph of current week"),
          backgroundColor: Color(0xFF17142A),
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
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTitlesWidget: (value, __) {
              return Text(
                valueToDayString(value),
                style: TextStyle(
                    color: Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: 10,
            showTitles: true,
            reservedSize: 28,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff1b4332), width: 1)),
      minX: 1,
      maxX: 7,
      minY: weights.isNotEmpty ? findMaxMin()[1] - 10.0 : 40,
      maxY: weights.isNotEmpty ? findMaxMin()[0] + 10.0 : 120,
      lineBarsData: [
        LineChartBarData(
          spots: getSpots(),
          isCurved: false,
          gradient: kLineChartGradient,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: kBelowBarGradient,
          ),
        ),
      ],
    );
  }
}
