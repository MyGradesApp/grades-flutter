import 'package:flutter/material.dart';
import 'package:grades/models/theme_controller.dart';
import 'package:grades/utilities/sentry.dart' as sentry;
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var themeController = Provider.of<ThemeController>(context, listen: false);
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
      body: SizedBox.expand(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildCard(
                      child: Row(children: [
                        const Expanded(
                          child: Text(
                            'App Theme',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          themeController.currentTheme == 'light'
                              ? 'Light'
                              : 'Dark',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Icon(
                          getModeIcon(),
                          color: Colors.white,
                        ),
                      ]),
                      onPressed: () {
                        if (themeController.currentTheme == 'light') {
                          themeController.setTheme('dark');
                        } else {
                          themeController.setTheme('light');
                        }
                      },
                    ),
                    _buildCard(
                      child: Row(
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              'Default Sort Style',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            themeController.defaultGroupMode ==
                                    GroupingMode.Category
                                ? 'Category'
                                : 'Recency',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Icon(
                            themeController.defaultGroupMode ==
                                    GroupingMode.Category
                                ? Icons.format_list_bulleted
                                : Icons.today,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        themeController.setDefaultGroupingMode(
                            themeController.defaultGroupMode ==
                                    GroupingMode.Category
                                ? GroupingMode.Date
                                : GroupingMode.Category);
                      },
                    ),
                    // _buildCard(
                    //   child: const Text(
                    //     "Leave a Review",
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 18,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    //   onPressed: () async {
                    //     await AppReview.writeReview;
                    //   },
                    // ),
                    _buildCard(
                      child: const Text(
                        'Terms of Service',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/terms_settings');
                      },
                    ),
                    _buildCard(
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        await Navigator.pop(context);
                        await Navigator.pop(context, true);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Text(
              sentry.version,
              style: TextStyle(color: Colors.grey[500]),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildCard({Widget child, void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Theme.of(context).accentColor,
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

  IconData getModeIcon() {
    if (Theme.of(context).primaryColor == const Color(0xff2a84d2)) {
      return Icons.wb_sunny;
    } else {
      return Icons.brightness_2;
    }
  }
}
