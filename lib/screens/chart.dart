import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  bool showAvg = false;
  List globalData = [];

  List<FlSpot> dummySpots = [
    FlSpot(1, 2),
    FlSpot(2, 5),
    FlSpot(3.5, 3.1),
    FlSpot(4, 4),
    FlSpot(4.6, 3),
    FlSpot(5, 4),
    FlSpot(6, 5),
    FlSpot(7, 3),
  ];

  void buildData(List w) {
    globalData = w;
    sortList(globalData);
    if (globalData.length > 7) {
      globalData = globalData.sublist(globalData.length - 7);
    }
    print("Global Data List : $globalData");
  }

  void sortList(List list) {
    list.sort((a, b) {
      var x = a['date'];
      var y = b['date'];
      return x.compareTo(y);
    });
  }

  List<FlSpot> getSpots() {
    double x, y;
    List<FlSpot> spots = [];
    spots.clear();
    DateTime startDate =
        DateTime.parse(DateFormat("yyyyMMdd").format(DateTime.now()));

    // Monday is 1
    while (startDate.weekday != 1) {
      startDate = startDate.subtract(Duration(days: 1));
    }

    bool searchKey(DateTime st) {
      for (var v in globalData) {
        if (v['date'] == st.toString()) {
          return true;
        }
      }
      return false;
    }

    for (int i = 0; i < 7; i++) {
      if (i > DateTime.now().weekday) break;
      if (searchKey(startDate)) {
        x = startDate.weekday.toDouble();
        y = double.parse(globalData[i]['weight']);
        spots.add(FlSpot(x, y));
        //sortedMap.addAll({x: y});
      } else {
        x = startDate.weekday.toDouble();
        spots.add(FlSpot(x, 20.0));
        //sortedMap.addAll({x: 20.0});
      }

      //print("Start Date is now : $startDate");
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
      body: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Color(0xff232d37)),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 18.0, left: 12.0, top: 24, bottom: 12),
                child: LineChart(
                  showAvg ? avgData() : mainData(),
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: 60,
          //   height: 34,
          //   child: FlatButton(
          //     onPressed: () {
          //       setState(() {
          //         showAvg = !showAvg;
          //       });
          //     },
          //     child: Text(
          //       'avg',
          //       style: TextStyle(
          //           fontSize: 12,
          //           color:
          //               showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
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
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 1,
      maxX: 7,
      minY: 20,
      maxY: 120,
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

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'MON';
              case 1:
                return 'TUE';
              case 2:
                return 'WED';
              case 3:
                return 'THU';
              case 4:
                return 'FRI';
              case 5:
                return 'SAT';
              case 6:
                return 'SUN';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(1, 3.44),
            FlSpot(2, 3.44),
            FlSpot(3, 3.44),
            FlSpot(4, 3.44),
            FlSpot(5, 3.44),
            FlSpot(6, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }
}
