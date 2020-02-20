import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/utilities/auth.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/utilities/wrapped_secure_storage.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _loadStoredAuth();
  }

  void _loadStoredAuth({bool force = false, bool freshSession = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var hasAcceptedTerms = prefs.getBool("accepted_terms") ?? false;

    if (!hasAcceptedTerms) {
      await Navigator.pushNamed(context, '/terms');
    }

    var secure = const WrappedSecureStorage();
    var email = await secure.read(key: 'sis_email');
    var password = await secure.read(key: 'sis_password');
    var session = await secure.read(key: 'sis_session');

    // First time login flow
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty ||
        force) {
      await Navigator.pushNamed(context, '/login');

      await _showCourses(prefs);
      return;
    }

    // Re-auth flow
    try {
      var loader = await attemptLogin(
        email,
        password,
        freshSession ? null : session,
      );
      Provider.of<CurrentSession>(context, listen: false).setSisLoader(loader);

      await _showCourses(prefs);
      return;
      // TODO: Actually return a login fail message here
    } on NoSuchMethodError catch (_) {
      // TODO: Pass login failure error message to login page
      if (!freshSession) {
        _loadStoredAuth(freshSession: true);
      } else {
        _loadStoredAuth(force: true);
      }
    } on InvalidAuthException catch (_) {
      // TODO: Pass login failure error message to login page
      _loadStoredAuth(force: true);
    } on HttpException catch (_) {
      _scaffoldKey.currentState
          .showSnackBar(errorSnackbar('Login failed - Poor connection'));
      setState(() {
        _showError = true;
      });
    } on SocketException catch (_) {
      _scaffoldKey.currentState
          .showSnackBar(errorSnackbar('Login failed - Poor connection'));
      setState(() {
        _showError = true;
      });
    } on HandshakeException catch (_) {
      _scaffoldKey.currentState
          .showSnackBar(errorSnackbar('Login failed - Poor connection'));
      setState(() {
        _showError = true;
      });
    } on OSError catch (_) {
      _scaffoldKey.currentState
          .showSnackBar(errorSnackbar('Login failed - Poor connection'));
      setState(() {
        _showError = true;
      });
    } catch (e, stackTrace) {
      setState(() {
        _showError = true;
      });
      await reportException(
        exception: e,
        stackTrace: stackTrace,
      );
      print(e);
      print(stackTrace);
    }
  }

  Future _showCourses(SharedPreferences prefs) async {
    var logoff = await Navigator.pushNamed(context, '/home');

    // We return true from courses if the logout button is pressed,
    // so we need to show the login screen and clear the session values
    if (logoff is bool && logoff) {
      await const WrappedSecureStorage().delete(key: 'sis_session');
      await const WrappedSecureStorage().delete(key: 'sis_password');
      _loadStoredAuth(force: true);
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xff2d3d54),
  //     key: _scaffoldKey,
  //     body: Container(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Expanded(
  //               child: Stack(
  //             children: <Widget>[
  //               onBottom(AnimatedWave(
  //                 height: 180,
  //                 speed: 1.0,
  //               )),
  //               onBottom(AnimatedWave(
  //                 height: 120,
  //                 speed: 0.9,
  //                 offset: pi,
  //               )),
  //               onBottom(AnimatedWave(
  //                 height: 220,
  //                 speed: 1.2,
  //                 offset: pi / 2,
  //               )),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   Text(
  //                     'SwiftGrade',
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontFamily: 'OpenSans',
  //                       fontSize: 40.0,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 25.0),
  //                   Text(
  //                     'Your grades at a glance',
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontFamily: 'OpenSans',
  //                       fontSize: 25.0,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 50),
  //                   Visibility(
  //                     visible: !_showError,
  //                     child: LoaderWidget(),
  //                     replacement: Padding(
  //                       padding: const EdgeInsets.only(top: 55.0),
  //                       child: Icon(
  //                         Icons.error_outline,
  //                         color: Colors.red,
  //                         size: 60,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           )),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // onBottom(Widget child) => Positioned.fill(
  //       child: Align(
  //         alignment: Alignment.bottomCenter,
  //         child: child,
  //       ),
  //     );

// OLD LOGIN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff195080),
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff195080),
                ),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'SwiftGrade',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      const Text(
                        'Your grades at a glance',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Visibility(
                        visible: !_showError,
                        child: LoaderWidget(),
                        replacement: Padding(
                          padding: const EdgeInsets.only(top: 55.0),
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
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
    );
  }

  SnackBar errorSnackbar(String message) {
    return SnackBar(
      backgroundColor: Colors.red,
      // HACK: Persistent display
      duration: const Duration(days: 1),
      action: SnackBarAction(
        label: "Refresh",
        textColor: Colors.white,
        onPressed: () {
          setState(() {
            _showError = false;
          });
          _loadStoredAuth();
        },
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

// Creates cool login animation
// class AnimatedWave extends StatelessWidget {
//   final double height;
//   final double speed;
//   final double offset;

//   AnimatedWave({this.height, this.speed, this.offset = 0.0});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       return Container(
//         height: height,
//         width: constraints.biggest.width,
//         child: ControlledAnimation(
//             playback: Playback.LOOP,
//             duration: Duration(milliseconds: (5000 / speed).round()),
//             tween: Tween(begin: 0.0, end: 2 * pi),
//             builder: (context, value) {
//               return CustomPaint(
//                 foregroundPainter: CurvePainter(value + offset),
//               );
//             }),
//       );
//     });
//   }
// }

// // creates cool login animation
// class CurvePainter extends CustomPainter {
//   final double value;

//   CurvePainter(this.value);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final white = Paint()..color = Colors.white.withAlpha(60);
//     final path = Path();

//     final y1 = sin(value);
//     final y2 = sin(value + pi / 2);
//     final y3 = sin(value + pi);

//     final startPointY = size.height * (0.5 + 0.4 * y1);
//     final controlPointY = size.height * (0.5 + 0.4 * y2);
//     final endPointY = size.height * (0.5 + 0.4 * y3);

//     path.moveTo(size.width * 0, startPointY);
//     path.quadraticBezierTo(
//         size.width * 0.5, controlPointY, size.width, endPointY);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//     canvas.drawPath(path, white);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }

// IF WE WANT RAINBOW ANIMATION (NOT SURE YET)

// class AnimatedBackground extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTrackTween([
//       Track("color1").add(Duration(seconds: 3),
//           ColorTween(begin: Color(0xffD38312), end: Colors.lightBlue.shade900)),
//       Track("color2").add(Duration(seconds: 3),
//           ColorTween(begin: Color(0xffA83279), end: Colors.blue.shade600))
//     ]);

//     return ControlledAnimation(
//       playback: Playback.MIRROR,
//       tween: tween,
//       duration: tween.duration,
//       builder: (context, animation) {
//         return Container(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [animation["color1"], animation["color2"]])),
//         );
//       },
//     );
//   }
// }
