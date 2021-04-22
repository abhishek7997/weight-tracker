import 'package:flutter/material.dart';
import '../constants.dart';

class DisplayWeightCard extends StatefulWidget {
  final String weight;
  DisplayWeightCard(this.weight);

  @override
  _DisplayWeightCardState createState() => _DisplayWeightCardState();
}

class _DisplayWeightCardState extends State<DisplayWeightCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(width: 0.8),
      //   borderRadius: BorderRadius.circular(12.0),
      // ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: kWeightCardColor),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${widget.weight}",
                style: TextStyle(
                  fontSize: widget.weight == kNoWeightText ? 36.0 : 90.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4.0,
                ),
              ),
              widget.weight == kNoWeightText
                  ? Text('')
                  : Text(
                      'kg',
                      style: TextStyle(fontSize: 45.0, letterSpacing: 4.0),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
