// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences prefs;
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, dynamic>{});
    prefs = await SharedPreferences.getInstance();
    var offlineBloc = OfflineBloc();
    var sisRepository = SISRepository(offlineBloc, prefs);

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthenticationBloc(sisRepository: sisRepository, prefs: prefs)
                ..add(AppStarted()),
        ),
        BlocProvider(
          create: (_) => ThemeBloc(
            initialStateSource: () => ThemeMode.system,
            stateSaver: (_) {},
          ),
        ),
        BlocProvider(
          create: (_) => offlineBloc,
        ),
      ],
      child: App(
        sisRepository: sisRepository,
        prefs: prefs,
      ),
    ));
  });
}
