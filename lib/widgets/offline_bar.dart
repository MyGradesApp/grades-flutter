import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grades/providers/current_session.dart';
import 'package:grades/utilities/refresh_offline_state.dart';
import 'package:provider/provider.dart';

class OfflineStatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        color: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'No Network Connection',
                ),
                const SizedBox(width: 40),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    color: Colors.orangeAccent,
                    onPressed: () async {
                      attemptSwitchToOnline(context);
                    },
                    child: Row(
                      children: <Widget>[
                        const Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white),
                        ),
                        if (Provider.of<CurrentSession>(context)
                            .isAttemptingLogin)
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: SpinKitRing(
                              color: Colors.white,
                              lineWidth: 3,
                              size: 20.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
