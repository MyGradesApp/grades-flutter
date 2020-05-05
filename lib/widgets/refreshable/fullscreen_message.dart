import 'package:flutter/material.dart';

class FullscreenMessage extends StatelessWidget {
  final Widget child;

  FullscreenMessage({@required this.child}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ],
    );
  }
}
