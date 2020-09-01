import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/widgets/refreshable/fullscreen_icon_message.dart';

class FullscreenErrorMessage extends StatelessWidget {
  final String text;
  final Widget child;

  FullscreenErrorMessage({this.text, this.child})
      : assert(text != null || child != null);

  @override
  Widget build(BuildContext context) {
    return FullscreenIconMessage(
      icon: Icon(
        FontAwesomeIcons.exclamationTriangle,
        color: Colors.red,
        size: 66,
      ),
      child: child,
      text: text,
    );
  }
}
