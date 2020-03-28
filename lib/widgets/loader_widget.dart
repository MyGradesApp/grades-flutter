import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SpinKitRing(
      color: Colors.white,
      size: 50.0,
    );
  }
}
