import 'package:flutter/material.dart';

class NotEnoughData extends StatelessWidget {
  static const routeName = '/notEnoughData';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go Back'),
      ),
      body: Center(
        child: Text('Not Enough Data'),
      ),
    );
  }
}
