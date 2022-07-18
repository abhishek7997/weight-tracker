import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

class UserWeights {
  static Map<String, double> _weights = <String, double>{};
  factory UserWeights() => UserWeights._internal();
  UserWeights._internal();

  Future<void> read() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> temp = new Map<String, dynamic>.from(jsonDecode(
        prefs.getString(kSharedPrefKey) ?? jsonEncode(<String, double>{})));

    temp.forEach((String key, dynamic value) {
      _weights[key] = value.toDouble();
    });
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(kSharedPrefKey, jsonEncode(_weights));
  }

  void addWeight(String date, double weight) {
    _weights[date] = weight;
    saveData();
  }

  void removeWeight(String date) {
    _weights.removeWhere((key, value) => key == date);
    saveData();
  }

  void reset() {
    _weights.clear();
    saveData();
  }

  double? getWeight(String date) {
    return _weights[date] ?? null;
  }

  double getAverageWeight() {
    double avg = 0;
    if (_weights.length == 0) return avg;
    _weights.forEach((key, value) {
      avg += value;
    });

    return avg / _weights.length;
  }

  List getListOfWeights() {
    List _listOfWeights = [];
    _weights.forEach(
        (k, v) => _listOfWeights.add({"date": k, "weight": v.toString()}));
    _listOfWeights.log();
    return _listOfWeights;
  }

  List getGraphData() {
    List weights = getListOfWeights();

    DateTime startDate =
        DateTime.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
    while (startDate.weekday != DateTime.monday) {
      startDate = startDate.subtract(Duration(days: 1));
    }

    weights.removeWhere(
        (element) => DateTime.parse(element['date']).isBefore(startDate));
    weights.removeWhere(
        (element) => DateTime.parse(element['date']).isAfter(DateTime.now()));

    return weights;
  }

  get weights => _weights;

  get length => _weights.length;
}
