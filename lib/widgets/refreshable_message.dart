import 'package:flutter/material.dart';

class RefreshableMessage extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  RefreshableMessage({@required this.onRefresh, @required this.child})
      : assert(onRefresh != null),
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Order matters, ensures refresh indicator is over content
        child,
        RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
      ],
    );
  }
}
