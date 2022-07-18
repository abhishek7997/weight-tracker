import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight_mon/models/weights.dart';
import '../constants.dart';

enum Gender { male, female }

class InputPage extends StatefulWidget {
  static const routeName = '/inputPage';

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Color maleCardColor = kInactiveCardColor;
  Color femaleCardColor = kInactiveCardColor;

  Gender? selectedGender;
  int height = 180;
  int weight = 60;
  int age = 18;
  double avgWeight = UserWeights().getAverageWeight();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  double? bmi;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calculate BMI'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    radioButton('Male', Colors.blue, Gender.male),
                    radioButton('Female', Colors.pink, Gender.female),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _heightController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("^[0-9]{0,3}[.]?[0-9]{0,2}"))
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Height',
                    hintText: "Enter your height (in meters)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Weight',
                    hintText: "Enter your weight (in kg)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      double height =
                          double.parse(_heightController.text) / 100;
                      double weight = double.parse(_weightController.text);
                      setState(() {
                        bmi = getBMI(height, weight);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.blue,
                    ),
                    child: Text(
                      'Calculate',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                if (bmi != null) ...[
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Your BMI is :",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      bmi!.toStringAsFixed(1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      getInterpretation(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: getInterpretationColor(),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "\u26a0 Not to be taken as medical advice!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  double getBMI(double height, double weight) {
    return weight / (height * height);
  }

  String getInterpretation() {
    if (bmi! >= 25) {
      return 'You have a higher than normal body weight. Try to exercise more.';
    } else if (bmi! > 18.5) {
      return 'You have a normal body weight. Good job!';
    } else {
      return 'You have a lower than normal body weight. You can eat a bit more.';
    }
  }

  Color getInterpretationColor() {
    if (bmi! >= 25) {
      return Colors.redAccent;
    } else if (bmi! > 18.5) {
      return Colors.green;
    } else {
      return Colors.orangeAccent;
    }
  }

  Widget radioButton(String value, Color color, Gender gender) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        height: 80.0,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              selectedGender = gender;
            });
          },
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: selectedGender != null && selectedGender == gender
                  ? Colors.white
                  : color,
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: selectedGender != null && selectedGender == gender
                ? color
                : Colors.grey[200],
          ),
        ),
      ),
    );
  }
}
