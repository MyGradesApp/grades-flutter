import 'package:flutter/material.dart';

class NewGradeIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9,
      width: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.indigoAccent,
      ),
    );
  }
}