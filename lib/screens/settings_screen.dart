import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/utilities/update.dart';

const TextStyle HEADER_TEXT_STYLE = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: Colors.white,
);

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, settings) {
          return ListView(
            children: [
              FutureBuilder<bool>(
                future: checkUpdateAvailable(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData && Platform.isIOS) {
                    return _buildCard(
                      const Color.fromARGB(255, 211, 117, 116),
                      child: Row(children: [
                        const Expanded(
                          child: Text(
                            'Update Available',
                            style: HEADER_TEXT_STYLE,
                          ),
                        ),
                        const Text(
                          'Click to update now',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                      onPressed: () {
                        launchAppstorePage();
                      },
                    );
                  }
                  return Container();
                },
              ),
              BlocBuilder<ThemeBloc, ThemeMode>(
                builder: (BuildContext context, theme) => _buildCard(
                  child: Row(children: [
                    const Expanded(
                      child: Text(
                        'App Theme',
                        style: HEADER_TEXT_STYLE,
                      ),
                    ),
                    Text(
                      theme.toHumanString(),
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Icon(
                      () {
                        switch (theme) {
                          case ThemeMode.system:
                            return Icons.phone_iphone;
                            break;
                          case ThemeMode.light:
                            return Icons.wb_sunny;
                            break;
                          case ThemeMode.dark:
                            return Icons.brightness_2;
                            break;
                          default:
                            throw Exception();
                        }
                      }(),
                    ),
                  ]),
                  onPressed: () {
                    BlocProvider.of<ThemeBloc>(context).add(AdvanceTheme());
                  },
                ),
              ),
              _buildCard(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Default Sort Style',
                        style: HEADER_TEXT_STYLE,
                      ),
                    ),
                    Text(
                      settings.groupingMode == GroupingMode.date
                          ? 'Recency'
                          : 'Category',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Icon(
                      settings.groupingMode == GroupingMode.date
                          ? Icons.today
                          : Icons.format_list_bulleted,
                    ),
                  ],
                ),
                onPressed: () => BlocProvider.of<SettingsBloc>(context)
                    .add(ToggleSettingsGroupingMode()),
              ),
              _buildCard(
                child: Text(
                  'Open SIS',
                  style: HEADER_TEXT_STYLE,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/sis_webview');
                },
              ),
              _buildCard(
                child: Text(
                  'Terms of Service',
                  style: HEADER_TEXT_STYLE,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/terms_display');
                },
              ),
              _buildCard(
                child: Text(
                  'Sign Out',
                  style: HEADER_TEXT_STYLE,
                ),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                  Navigator.pop(context);
                },
              ),
              Center(
                child: Text(
                  GRADES_VERSION,
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard({
    @required Widget child,
    @required void Function() onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: const Color(0xff226baa),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 26, bottom: 26),
            child: SizedBox(
              width: double.infinity,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
