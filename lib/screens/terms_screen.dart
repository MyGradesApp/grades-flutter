import 'package:flutter/material.dart';
import 'package:grades/utilities/tos_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Terms of Service",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 29.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    thickness: 5,
                  ),
                  const Text(
                    TOS_STRING,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            RaisedButton(
              child: const Text("Accept the terms and conditions"),
              onPressed: () => _acceptAndReturn(context),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  _acceptAndReturn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("accepted_terms", true);
    Navigator.pop(context);
  }
}
