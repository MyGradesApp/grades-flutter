import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // const spinkit = SpinKitSquareCircle(
    // const spinkit = SpinKitWave(
    const spinkit = SpinKitRing(
      color: Colors.white,
      size: 50.0,
    );
    // Timer(Duration(seconds: 7), () {
    //   Text(
    //     'Poor connection',
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontFamily: 'OpenSans',
    //       fontSize: 25.0,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   );
    // });
    return spinkit;
  }
}
