import 'package:flutter/material.dart';
import 'package:grades/widgets/refreshable_icon_message.dart';

class RefreshableErrorMessage extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final String text;
  final Widget child;

  RefreshableErrorMessage({@required this.onRefresh, this.text, this.child})
      : assert(onRefresh != null),
        assert(text != null || child != null);

  @override
  Widget build(BuildContext context) {
    return RefreshableIconMessage(
      onRefresh: onRefresh,
      icon: Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 66,
      ),
      child: child,
      text: text,
    );
  }
}
