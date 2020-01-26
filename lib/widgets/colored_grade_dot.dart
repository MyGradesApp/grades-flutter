import 'package:flutter/material.dart';

class ColoredGradeDot extends StatelessWidget {
  final Color _color;

  ColoredGradeDot(this._color);

  factory ColoredGradeDot.grade(String letterGrade) {
    switch (letterGrade) {
      case 'A':
        return ColoredGradeDot(Colors.green);
      case 'B':
        return ColoredGradeDot(Colors.lightGreen[400]);
      case 'C':
        return ColoredGradeDot(Colors.amber);
      case 'D':
        return ColoredGradeDot(Colors.deepOrangeAccent);
      case 'F':
        return ColoredGradeDot(Colors.red);
    }

    return ColoredGradeDot(Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color,
      ),
    );
  }
}
