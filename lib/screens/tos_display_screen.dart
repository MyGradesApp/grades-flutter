import 'package:flutter/material.dart';
import 'package:grades/screens/login/login_form.dart';
import 'package:grades/utilities/tos_const.dart';

class TermsDisplayScreen extends StatefulWidget {
  @override
  _TermsDisplayScreenState createState() => _TermsDisplayScreenState();
}

class _TermsDisplayScreenState extends State<TermsDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Terms of Service'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
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
          ],
        ),
      ),
    );
  }
}
