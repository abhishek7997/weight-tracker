import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class UserWeight {
  int? id;
  final String? weight;
  double totalWeight = 0.0;
  final String? date;
  String? jsonString;
  List<dynamic>? listOfWeights = [];

  UserWeight({this.weight, this.date});

  int length() {
    return listOfWeights!.length;
  }

  void destroyData() {
    listOfWeights!.clear();
    totalWeight = 0.0;
    jsonString = '';
    saveData();
  }

  void addWeight(String dt, String wt) {
    for (var v in listOfWeights!) {
      if (v.containsKey('date')) {
        if (v['date'] == null) {
          return;
        } else if (v['date'] == dt) {
          v['weight'] = wt;
          return;
        }
      }
    }
    listOfWeights!.add({'date': dt, 'weight': wt});
    totalWeight += double.parse(wt);
    serialize();
  }

  void removeWeight(String dt) {
    if (listOfWeights != null) {
      for (var v in listOfWeights!) {
        if (v.containsKey('date')) {
          if (v['date'] == dt) {
            totalWeight -= double.parse(v['weight']);
          }
        }
      }
    }
    listOfWeights!.removeWhere((element) => element['date'] == dt);
  }

  String getWeight(String dt) {
    if (listOfWeights != null) {
      for (var v in listOfWeights!) {
        if (v.containsKey('date') && v['date'] == dt) {
          return double.parse(v['weight']).toString();
        }
      }
    }
    return kNoWeightText; // If there is no weight for given date
  }

  double getAvgWeight() {
    if (listOfWeights!.length == 0) return 0;
    return (totalWeight / listOfWeights!.length);
  }

  String serialize() {
    return jsonEncode(listOfWeights);
  }

  void sortList() {
    listOfWeights!.sort((a, b) {
      var x = a['date'];
      var y = b['date'];
      return x.compareTo(y);
    });
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    listOfWeights =
        jsonDecode((prefs.getString(kSharedPrefKey) ?? "[]")) as List<dynamic>;
    sortList();
    for (var v in listOfWeights!) {
      totalWeight += double.parse(v['weight']);
    }
  }

  saveData() async {
    sortList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(kSharedPrefKey, serialize());
  }
}
