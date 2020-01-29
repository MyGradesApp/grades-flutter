import 'package:flutter/foundation.dart' as foundation;
import 'package:sentry/sentry.dart';

final SentryClient _sentry = SentryClient(
    dsn: 'https://241147e2e5d342c0be1379508e165cb1@sentry.io/1869892');

reportException({@foundation.required dynamic exception, dynamic stackTrace}) {
  if (!foundation.kDebugMode) {
    print(exception);
    if (stackTrace != null) {
      print(stackTrace);
    }

    try {
      _sentry.captureException(
        exception: exception,
        stackTrace: stackTrace,
      );
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
    }
  } else {
    print("Error not reported to sentry (debug mode)");
    print(exception);
    if (stackTrace != null) {
      print(stackTrace);
    }
  }
}
