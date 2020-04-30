import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              Navigator.pop(context);
            },
            child: Text('Log out'),
          ),
          RaisedButton(
            onPressed: () {
              BlocProvider.of<ThemeBloc>(context).add(AdvanceTheme());
            },
            child: BlocBuilder<ThemeBloc, ThemeMode>(
              builder: (context, themeMode) {
                return Text('Theme: ${themeMode.toHumanString()}');
              },
            ),
          ),
          RaisedButton(
            onPressed: () async {
              var prefs = await SharedPreferences.getInstance();
              await prefs.remove(DataPersistence.GRADES_KEY);
              await prefs.remove(DataPersistence.COURSES_KEY);
              await prefs.remove(DataPersistence.ACADEMIC_INFO_KEY);
            },
            child: BlocBuilder<ThemeBloc, ThemeMode>(
              builder: (context, themeMode) {
                return Text('Clear persistence data');
              },
            ),
          )
        ],
      ),
    );
  }
}
