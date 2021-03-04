import 'package:flutter/material.dart';

class BuildEventList extends StatefulWidget {
  final String weight;
  BuildEventList(this.weight);

  @override
  _BuildEventListState createState() => _BuildEventListState();
}

class _BuildEventListState extends State<BuildEventList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        width: double.infinity,
        child: Center(child: Text("${widget.weight}")),
      ),
    );
  }
}
