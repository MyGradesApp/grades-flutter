import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/authentication/authentication_bloc.dart';

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
          )
        ],
      ),
    );
  }
}
