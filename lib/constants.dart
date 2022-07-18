import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

const kBottomContainerHeight = 80.0;
const kActiveCardColor = Color(0xFF3E3961);
const kInactiveCardColor = Color(0xFF211E34);
const kBottomContainerColor = Color(0xFF52b788);

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.white,
);

const kNumberTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
);

const kLargeButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const kTitleTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

const kResultTextStyle = TextStyle(
  color: Color(0xFF24D876),
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

const kBMITextStyle = TextStyle(
  color: Colors.white,
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
);

const kBodyTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 22.0,
);

const String kNoWeightText = "No weight given";
const String kSharedPrefKey = "weights";

const kSelectedColor = Color(0xFF1eb77c);
const kTodayColor = Color(0xFF1f5c49);
const kMarkersColor = Color(0xFF1f7f54);
const kTableButtonColor = Color(0xFF4481bf);
const kDrawerColor = Color(0xFF211E34);
const kChartBackgroundColor = Color(0xFF211E34);
const kWeightCardColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF2BFF88), Color(0xFF2BD2FF)],
);

List<Color> kgradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

const dummyData = [
  {"date": "2022-06-06 00:00:00.000", "weight": 85},
  {"date": "2022-06-07 00:00:00.000", "weight": 84.3},
  {"date": "2022-06-08 00:00:00.000", "weight": 84.7},
  {"date": "2022-06-09 00:00:00.000", "weight": 84.8},
  {"date": "2022-06-10 00:00:00.000", "weight": 85.2},
  {"date": "2022-06-11 00:00:00.000", "weight": 85.5},
  {"date": "2022-06-12 00:00:00.000", "weight": 86}
];

const canlendarStyle = CalendarStyle(
  selectedDecoration:
      const BoxDecoration(color: kSelectedColor, shape: BoxShape.circle),
  todayDecoration:
      const BoxDecoration(color: kTodayColor, shape: BoxShape.circle),
  markerDecoration:
      const BoxDecoration(color: kMarkersColor, shape: BoxShape.circle),
  markersAlignment: Alignment.center,
  outsideDaysVisible: false,
);

var headerStyle = HeaderStyle(
  formatButtonTextStyle:
      TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
  formatButtonDecoration: BoxDecoration(
    color: kTableButtonColor,
    borderRadius: BorderRadius.circular(16.0),
  ),
  formatButtonVisible: false,
);
