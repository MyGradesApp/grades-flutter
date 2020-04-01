// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grades/main.dart';
import 'package:grades/screens/terms_query_screen.dart';
import 'package:grades/utilities/helpers/package_info.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation_monitor.dart';

Future<void> main() async {
  SharedPreferences prefs;
  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    final package_info = await getPackageInfo();
    // Used for sentry error reporting and settings page version number
    version = '${package_info.version}+${package_info.buildNumber}';
  });

  setUpAll(() async {
    await prefs?.clear();
  });

  testWidgets('Launch test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(prefs: prefs));
    await tester.pumpAndSettle();
    // We should end up on the terms and conditions screen on first launch
    expect(find.text('Welcome to SwiftGrade'), findsOneWidget);
    expect(find.text('I accept the terms and conditions'), findsOneWidget);
  });

  testWidgets('Splash screen accepts terms', (WidgetTester tester) async {
    var navMonitor = NavigationMonitor();
    await tester.pumpWidget(MaterialApp(
      home: TermsQueryScreen(),
      navigatorObservers: [navMonitor],
    ));
    await tester.pumpAndSettle();

    expect(
      prefs.getBool('accepted_terms'),
      null,
      reason: 'test should start with empty shared prefs',
    );

    await tester.tap(
      find.widgetWithText(RaisedButton, 'I accept the terms and conditions'),
    );

    expect(prefs.getBool('accepted_terms'), true);
    expect(navMonitor.popped, true,
        reason: 'Splash screen should pop after accepting');
  });
}
