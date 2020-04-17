import 'package:flutter/foundation.dart' show required, kDebugMode;
import 'package:sentry/sentry.dart';

final SentryClient _sentry = SentryClient(
    dsn: 'https://241147e2e5d342c0be1379508e165cb1@sentry.io/1869892');
String GRADES_VERSION = '';

// TODO: Refactor this so it doesn't use global version var
Future<SentryResponse> reportException(
    {@required dynamic exception, @required dynamic stackTrace}) {
  if (!kDebugMode) {
    print(exception);
    if (stackTrace != null) {
      print(stackTrace);
    }

    try {
      final event = Event(
        exception: exception,
        stackTrace: stackTrace,
        release: GRADES_VERSION,
      );
      return _sentry.capture(event: event);
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
    }
  } else {
    print('Error not reported to sentry (debug mode)');
    print(exception);
    if (stackTrace != null) {
      print(stackTrace);
    }
  }

  return null;
}
