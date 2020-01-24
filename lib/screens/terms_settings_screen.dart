import 'package:flutter/material.dart';
import 'package:grades/utilities/tos_const.dart';

class TermsSettingsScreen extends StatefulWidget {
  @override
  _TermsSettingsScreenState createState() => _TermsSettingsScreenState();
}

class _TermsSettingsScreenState extends State<TermsSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Terms of Service'),
        leading: IconButton(
          tooltip: 'Back',
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
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
