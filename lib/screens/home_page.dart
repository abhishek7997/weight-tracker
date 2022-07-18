import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/display_weight_card.dart';

import './bmi_page.dart';
import '../constants.dart';
import '../models/weights.dart';
import 'about_page.dart';
import 'chart_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // _selectedDay = DateTime.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
  UserWeights uw = UserWeights();

  // Store date and corresponding list of weight (length 1)
  final _myController = TextEditingController();

  // read data from shared preferences whenever app is initialized
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

  void _onSubmit(String value, DateTime dt) async {
    if (value == "0.0" || value.isEmpty || value == "0") {
      uw.removeWeight(dt.toString());
    } else {
      if (double.parse(value) >= 30.0) {
        // add the given weight to the total data
        uw.addWeight(dt.toString(), double.parse(value));
      }
    }
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
                      onPressed: () {
                        Navigator.pop(context);
                        _onSubmit(_myController.value.text, dt);
                      },
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Weight Tracker",
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.show_chart),
              color: Colors.white,
              onPressed: () =>
                  Navigator.pushNamed(context, ChartPage.routeName),
            ),
          ],
          backgroundColor: Color(0xFF17142A),
        ),
        drawer: AppDrawer(),
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
      calendarFormat: CalendarFormat.month,
      calendarStyle: canlendarStyle,
      headerStyle: headerStyle,
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
          uw.getWeight(date.toString()) != null ? Icons.check : null,
          color: Colors.green,
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final uw = UserWeights();
  AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            leading: const Icon(FontAwesomeIcons.chartArea),
            minLeadingWidth: 10,
            title: Text(
              'View Graph',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, ChartPage.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            minLeadingWidth: 10,
            title: Text(
              'Clear ALL Data',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () => uw.reset(),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.solidHeart),
            minLeadingWidth: 10,
            title: Text(
              'Calculate BMI',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, InputPage.routeName),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.circleInfo),
            minLeadingWidth: 10,
            title: Text(
              'About',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, About.routeName),
          ),
        ],
      ),
    );
  }
}
