import 'package:flutter/material.dart';

// If there is no data entered by the user, then display this page
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
