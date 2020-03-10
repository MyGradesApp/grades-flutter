import 'package:flutter/material.dart';
import 'package:grades/utilities/tos_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xff195080),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Welcome to SwiftGrade',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          TOS_STRING,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RaisedButton(
                child: const Text('I accept the terms and conditions',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    )),
                color: const Color(0xff2a84d2),
                padding: const EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                onPressed: () => _acceptAndReturn(context),
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  void _acceptAndReturn(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('accepted_terms', true);
    Navigator.pop(context);
  }
}
