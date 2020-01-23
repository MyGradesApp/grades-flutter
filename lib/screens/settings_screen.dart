import 'package:flutter/material.dart';
import 'package:grades/screens/course_list_screen.dart';
import 'package:grades/screens/login_screen.dart';
import 'package:grades/screens/terms_settings_screen.dart';
import 'package:sis_loader/sis_loader.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<Profile> _info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
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
        body: FutureBuilder<Profile>(builder: (context, snapshot) {
          return SizedBox.expand(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildDark(),
                  _buildTerms(),
                  _buildLogout(),
                ],
              ),
            ),
          );
        }));
  }

  Widget _buildLogout() {
    return FlatButton(
      padding: const EdgeInsets.all(4),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: const Color(0xff216bac),
        child: const Padding(
            padding: EdgeInsets.all(9.0),
            child: ListTile(
              title: Text(
                'Sign Out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildTerms() {
    return FlatButton(
      padding: const EdgeInsets.all(4),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TermsSettingsScreen()),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: const Color(0xff216bac),
        child: const Padding(
            padding: EdgeInsets.all(9.0),
            child: ListTile(
              title: Text(
                'Terms of Service',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildDark() {
    return FlatButton(
      padding: const EdgeInsets.all(4),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CourseListScreen()),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: const Color(0xff216bac),
        child: const Padding(
            padding: EdgeInsets.all(9.0),
            child: ListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }
}
