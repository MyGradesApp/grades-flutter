// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grades/main.dart';
import 'package:grades/utilities/helpers/package_info.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Setup
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final package_info = await getPackageInfo();
  // Used for sentry error reporting and settings page version number
  version = '${package_info.version}+${package_info.buildNumber}';

  testWidgets('Launch test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
  });
}
