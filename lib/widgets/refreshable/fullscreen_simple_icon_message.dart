import 'package:flutter/material.dart';
import 'package:grades/widgets/refreshable/fullscreen_icon_message.dart';

class FullscreenSimpleIconMessage extends StatelessWidget {
  final String text;
  final IconData icon;

  FullscreenSimpleIconMessage({this.text, this.icon})
      : assert(text != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return FullscreenIconMessage(
      icon: Icon(
        icon,
        color: Colors.white,
        size: 66,
      ),
      text: text,
    );
  }
}
