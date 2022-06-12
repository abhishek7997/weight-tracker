import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weight_mon/screens/not_enough_data_page.dart';
import 'package:weight_mon/widgets/display_weight_card.dart';

import './bmi_page.dart';
import '../constants.dart';
import '../models/weights.dart';
import 'about_page.dart';
import 'chart_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  UserWeight uw = new UserWeight();

  // Store date and corresponding list of weight (length 1)
  // _weights is used for building the table calender on screen
  Map<DateTime, List> _weights = {};

  // Controllers
  final _myController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    getData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    setState(() {
      _selectedDay =
          DateTime.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // read data from shared preferences whenever app is initialized
  void getData() async {
    await uw
        .read(); // Call read function of the User object, so that data is read and used from shared preferences
    if (mounted) {
      setState(() {
        for (var v in uw.listOfWeights!) {
          DateTime dt = DateFormat("yyyy-MM-dd hh:mm:ss").parse(v['date']);
          _weights[dt] = [v['weight']];
        }
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    DateTime dt = DateTime.parse(DateFormat("yyyyMMdd").format(selectedDay));
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = dt;
        _focusedDay = dt;
      });
    }
  }

  // call input dialog box upon long pressing on a date to enter the user's weight on that day
  void _onDayLongPressed(DateTime selectedDay, DateTime focusedDay) {
    DateTime dt = DateTime.parse(DateFormat("yyyyMMdd").format(selectedDay));
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = dt;
        _focusedDay = dt;
      });
    }
    // For now a modal bottom sheet is used as input
    _modalBottomSheetMenu(dt);
  }

  void _onSubmit(value, DateTime dt) async {
    if (value == "0.0" || value.isEmpty || value == "0") {
      setState(() {
        uw.removeWeight(dt.toString());
      });
    } else {
      setState(() {
        _weights[dt] = [value].toList();
        if (double.parse(value) >= 30.0) {
          // add the given weight to the total data
          uw.addWeight(dt.toString(), value);
        }
      });
    }
    // save the weights entered permanently, so that the same is reloaded upon loading the app
    uw.saveData();
    Navigator.pop(context);
  }

  // return the input modal bottom sheet widget
  void _modalBottomSheetMenu(DateTime dt) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
              left: 15.0,
              right: 15.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Enter your current weight",
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: _myController,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(
                            r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$'),
                      ),
                    ],
                    //textAlign: TextAlign.center,
                    autofocus: true,
                    maxLength: 4,
                    onSubmitted: (value) => _onSubmit(value, dt),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () => _myController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Weight',
                      hintText: 'Enter your weight',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () => _onSubmit(_myController.value.text, dt),
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weight Tracker",
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.show_chart),
            color: Colors.white,
            onPressed: () {
              // If no weights are entered by the user for any day within the current week, show 'Not enough data'
              // else show the graph
              if (uw.length() >= 4) {
                Navigator.pushNamed(context, ChartPage.routeName,
                    arguments: uw.listOfWeights);
              } else {
                Navigator.pushNamed(context, NotEnoughData.routeName);
              }
            },
          ),
        ],
      ),
      drawer: buildDrawer(context),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          const SizedBox(height: 16.0),
          Expanded(
            // Display the weight of the selected day
            child: DisplayWeightCard(
              uw.getWeight(
                _selectedDay.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      firstDay: DateTime.now().subtract(
        Duration(days: 90),
      ),
      lastDay: DateTime.now(),
      focusedDay: _focusedDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarFormat: _calendarFormat,
      calendarStyle: CalendarStyle(
        selectedDecoration:
            const BoxDecoration(color: kSelectedColor, shape: BoxShape.circle),
        todayDecoration:
            const BoxDecoration(color: kTodayColor, shape: BoxShape.circle),
        markerDecoration:
            const BoxDecoration(color: kMarkersColor, shape: BoxShape.circle),
        markersAlignment: Alignment.center,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: kTableButtonColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        formatButtonVisible: false,
      ),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: _onDaySelected,
      onDayLongPressed: _onDayLongPressed,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          return Positioned(
            right: 1,
            bottom: 1,
            child: _buildEventsMarker(
                DateTime.parse(DateFormat("yyyyMMdd").format(date))),
          );
        },
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date) {
    // events parameter is not used
    // If any weight is entered for any dates, display a small tick mark near to that date
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 25.0,
      height: 25.0,
      child: Center(
        child: Icon(
          uw.getWeight(date.toString()) != kNoWeightText ? Icons.check : null,
          color: Colors.green,
        ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: Text(
                    'Weight Tracker',
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: kDrawerColor,
            ),
          ),
          ListTile(
            title: Text('View Graph'),
            onTap: () {
              if (uw.length() >= 1) {
                Navigator.pushNamed(context, ChartPage.routeName,
                    arguments: uw.listOfWeights);
              } else {
                Navigator.pushNamed(context, NotEnoughData.routeName);
              }
            },
          ),
          ListTile(
            title: Text('Clear ALL Data'),
            onTap: () {
              setState(() {
                uw.destroyData();
              });
            },
          ),
          ListTile(
            title: Text('Calculate BMI'),
            onTap: () {
              Navigator.pushNamed(context, InputPage.routeName,
                  arguments: uw.getAvgWeight());
            },
          ),
          ListTile(
            title: Text('About'),
            onTap: () {
              Navigator.pushNamed(context, About.routeName,
                  arguments: uw.listOfWeights);
            },
          ),
        ],
      ),
    );
  }
}
