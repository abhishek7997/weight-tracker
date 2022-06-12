import 'package:flutter/material.dart';
import '../constants.dart';

class DisplayWeightCard extends StatefulWidget {
  final String weight;

  DisplayWeightCard(this.weight);

  @override
  _DisplayWeightCardState createState() => _DisplayWeightCardState();
}

class _DisplayWeightCardState extends State<DisplayWeightCard> {
  Widget _getWeightText() {
    if (widget.weight == kNoWeightText) {
      return Text(
        widget.weight,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      );
    }

    return Text(
      "${widget.weight} kg",
      style: TextStyle(
        fontSize: 52.0,
        letterSpacing: 4.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: kWeightCardColor,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Center(
        // width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: _getWeightText(),
        ),
      ),
    );
  }
}
