import 'package:flutter/material.dart';
import 'package:grades/widgets/refreshable/refreshable_message.dart';

class RefreshableIconMessage extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Icon icon;
  final String text;
  final Widget child;

  RefreshableIconMessage(
      {@required this.onRefresh, this.child, @required this.icon, this.text})
      : assert(onRefresh != null),
        assert(icon != null),
        assert(child != null || text != null);

  @override
  Widget build(BuildContext context) {
    return RefreshableMessage(
      onRefresh: onRefresh,
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
            if (child != null)
              child,
            // Padding to push the content up
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
