import 'package:flutter/material.dart';
import 'package:grades/utilities/tos_const.dart';
import 'package:sis_loader/sis_loader.dart';

class TermsSettingsScreen extends StatefulWidget {
  @override
  _TermsSettingsScreenState createState() => _TermsSettingsScreenState();
}

class _TermsSettingsScreenState extends State<TermsSettingsScreen> {
  Future<Profile> _info;

  @override
  Widget build(BuildContext context) {
    child:
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        leading: IconButton(
          tooltip: 'Back',
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pushNamed(context, '/courses'),
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
