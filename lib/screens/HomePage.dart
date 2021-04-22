import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weight_mon/screens/NotEnoughData.dart';
import 'package:weight_mon/widgets/displayWeightCard.dart';
import '../models/holidays.dart';
import 'package:intl/intl.dart';
import '../models/weights.dart';
import '../constants.dart';
import 'about.dart';
import 'chart.dart';
import './bmiPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // Global variables to be used
  DateTime selectedDate;
  UserWeight uw = new UserWeight();
  // Store date and corresponding list of weight (length 1)
  // _events is used for building the table calender on screen
  Map<DateTime, List> _events = {};

  // Controllers
  final myController = TextEditingController();
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    setState(() {
      selectedDate =
          DateTime.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
    });
    getData();
  }

  // read data from shared preferences whenever app is initialized
  void getData() async {
    await uw
        .read(); // Call read function of the User object, so that data is read and used from shared preferences
    if (mounted) {
      setState(() {
        for (var v in uw.listOfWeights) {
          DateTime dt = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(v['date']);
          _events[dt] = [v['weight']];
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    DateTime dt = DateTime.parse(DateFormat("yyyyMMdd").format(day));
    setState(() {
      selectedDate = dt;
    });
  }

  // call input dialog box upon long pressing on a date to enter the user's weight on that day
  void _onDayLongPressed(DateTime day, List events, List holidays) {
    DateTime dt = DateTime.parse(DateFormat("yyyyMMdd").format(day));
    setState(() {
      selectedDate = dt;
    });

    // For now, I was unable to properly show a input dialog box, so a modal bottom sheet is used
    _modalBottomSheetMenu(dt);
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    //print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    //print('CALLBACK: _onCalendarCreated');
  }

  // return the input modal bottom sheet widget
  void _modalBottomSheetMenu(DateTime dt) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add a weight"),
            Container(
              width: 200.0,
              child: TextField(
                controller: myController,
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
                maxLength: 5,
                onSubmitted: (value) {
                  if (value == "0.0" || value.isEmpty || value == "0") {
                    setState(() {
                      uw.removeWeight(dt.toString());
                    });
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      _events[dt] = [value].toList();
                      if (double.parse(value) >= 30.0) {
                        // add the given weight to the total data
                        uw.addWeight(dt.toString(), value);
                      }
                    });
                    Navigator.pop(context);
                  }
                  // save the weights entered permanently, so that the same is reloaded upon loading the app
                  uw.saveData();
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => myController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Weight',
                    hintText: 'Enter your weight'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weight Tracker"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              // If no weights are entered by the user for any day within the current week, show 'Not enough data'
              // else show the graph
              if (uw.length() >= 1) {
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
          //_buildButtons(),
          Expanded(
            // Display the weight of the selected day
            child: DisplayWeightCard(uw.getWeight(selectedDate.toString())),
          ),
          //Expanded(child: BuildEventList(uw.getTotalWeight().toString()),),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      endDay: DateTime.now(),
      calendarController: _calendarController,
      events: _events,
      holidays: Holidays().getHolidays(),
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: kSelectedColor,
        todayColor: kTodayColor,
        markersColor: kMarkersColor,
        markersAlignment: Alignment.center,
        markersPositionBottom: null,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: kTableButtonColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onDayLongPressed: _onDayLongPressed,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(
                    DateTime.parse(DateFormat("yyyyMMdd").format(date))),
              ),
            );
          }
          return children;
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
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: Text(
                    'Weight Tracker',
                    style: TextStyle(color: Colors.white, fontSize: 32.0),
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

// Widget _buildButtons() {
//   final dateTime = DateTime.now();
//   return Column(
//     children: <Widget>[
//       Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           RaisedButton(
//             child: Text('Month'),
//             onPressed: () {
//               setState(() {
//                 _calendarController.setCalendarFormat(CalendarFormat.month);
//               });
//             },
//           ),
//           RaisedButton(
//             child: Text('2 weeks'),
//             onPressed: () {
//               setState(() {
//                 _calendarController
//                     .setCalendarFormat(CalendarFormat.twoWeeks);
//               });
//             },
//           ),
//           RaisedButton(
//             child: Text('Week'),
//             onPressed: () {
//               setState(() {
//                 _calendarController.setCalendarFormat(CalendarFormat.week);
//               });
//             },
//           ),
//         ],
//       ),
//       const SizedBox(height: 8.0),
//       RaisedButton(
//         child: Text(
//             'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
//         onPressed: () {
//           _calendarController.setSelectedDay(
//             DateTime(dateTime.year, dateTime.month, dateTime.day),
//             runCallback: true,
//           );
//         },
//       ),
//     ],
//   );
// }
}
