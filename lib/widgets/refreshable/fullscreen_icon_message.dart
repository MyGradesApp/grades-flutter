import 'package:flutter/material.dart';
import 'package:grades/widgets/refreshable/fullscreen_message.dart';

class FullscreenIconMessage extends StatelessWidget {
  final Icon icon;
  final String text;
  final Widget child;

  FullscreenIconMessage({this.child, @required this.icon, this.text})
      : assert(icon != null),
        assert(child != null || text != null);

  @override
  Widget build(BuildContext context) {
    return FullscreenMessage(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 25),
            if (text != null)
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
            if (child != null) child,
            // Padding to push the content up
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
