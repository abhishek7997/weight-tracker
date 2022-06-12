import 'package:flutter/material.dart';

import '../constants.dart';

class IconContent extends StatelessWidget {
  IconContent({required this.gender, required this.icon});

  final String gender;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          gender,
          style: kLabelTextStyle,
        ),
      ],
    );
  }
}
