import 'package:flutter/material.dart';
import 'package:sis_loader/sis_loader.dart';
import 'package:grades/utilities/custom_theme.dart';
import 'package:grades/utilities/themes.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<Profile> _info;

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
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
      onPressed: () async {
        await Navigator.pop(context);
        await Navigator.pop(context, true);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Theme.of(context).accentColor,
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
      onPressed: () {
        Navigator.pushNamed(context, '/terms_settings');
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Theme.of(context).accentColor,
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

  IconData getModeIcon() {
    if (Theme.of(context).primaryColor == const Color(0xff2a84d2)) {
      return Icons.wb_sunny;
    } else {
      return Icons.brightness_2;
    }
  }

  Widget _buildDark() {
    // TODO: MAKE THEME STICK AFTER APP IS CLOSED
    return FlatButton(
      padding: const EdgeInsets.all(4),
      onPressed: () {
        if (Theme.of(context).primaryColor == const Color(0xff2a84d2)) {
          _changeTheme(context, MyThemeKeys.DARK);
        } else {
          _changeTheme(context, MyThemeKeys.LIGHT);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Theme.of(context).accentColor,
        child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: ListTile(
                title: const Text(
                  'App Theme',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    getModeIcon(),
                    color: Colors.white,
                  ),
                ))),
      ),
    );
  }
}
