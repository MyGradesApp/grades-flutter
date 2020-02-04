import 'package:flutter/foundation.dart' as foundation;
import 'package:sentry/sentry.dart';

final SentryClient _sentry = SentryClient(
    dsn: 'https://241147e2e5d342c0be1379508e165cb1@sentry.io/1869892');
String version = "";

Future<SentryResponse> reportException(
    {@foundation.required dynamic exception,
    @foundation.required dynamic stackTrace}) {
  if (!foundation.kDebugMode) {
    print(exception);
    if (stackTrace != null) {
      print(stackTrace);
    }

    try {
      final Event event = Event(
        exception: exception,
        stackTrace: stackTrace,
        release: version,
      );
      return _sentry.capture(event: event);
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

  return null;
}
