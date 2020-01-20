import 'package:flutter/material.dart';
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
                  _buildCard('Dark Mode', ''),
                  _buildCard('Terms of Service', ''),
                  _buildCard('Sign Out', 'login'),
                ],
              ),
            ),
          );
        }));
  }

  Widget _buildCard(String title, String nav) {
    return FlatButton(
      padding: const EdgeInsets.all(4),
      onPressed: () =>
          Navigator.pushNamed(context, '/' + nav + '').then((result) {
        Navigator.of(context).pop();
      }),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: const Color(0xff216bac),
        // margin: const EdgeInsets.all(10),
        child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: ListTile(
              title: Text(
                title,
                style: const TextStyle(
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
