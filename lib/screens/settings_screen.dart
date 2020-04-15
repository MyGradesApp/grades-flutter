import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings screen'),
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
        ],
      ),
    );
  }
}
