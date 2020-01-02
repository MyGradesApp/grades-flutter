import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // const spinkit = SpinKitSquareCircle(
    // const spinkit = SpinKitWave(
    const spinkit = SpinKitDualRing(
      color: Colors.white,
      size: 50.0,
    );
    return spinkit;
  }
}
