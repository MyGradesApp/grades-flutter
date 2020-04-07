// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    var offlineBloc = OfflineBloc();
    var sisRepository = SISRepository(offlineBloc);

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(sisRepository: sisRepository)
            ..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => offlineBloc,
        ),
      ],
      child: App(
        sisRepository: sisRepository,
      ),
    ));
  });
}
