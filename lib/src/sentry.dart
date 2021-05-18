import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show required, kDebugMode;
import 'package:sentry/sentry.dart';

String GRADES_VERSION = '';

Future<SentryId> reportBlocException({
  @required dynamic exception,
  @required StackTrace stackTrace,
  @required BlocBase bloc,
  Map<String, String> tags,
}) {
  return reportException(
      exception: exception,
      stackTrace: stackTrace,
      tags: {'bloc': bloc.runtimeType.toString()}..addAll(tags ?? {}));
}

// TODO: Refactor this so it doesn't use global version var
Future<SentryId> reportException({
  @required dynamic exception,
  @required StackTrace stackTrace,
  Map<String, String> tags,
}) {
  if (!kDebugMode) {
    print(exception);
    if (stackTrace != null) {
      print(stackTrace);
    }

    try {
      Sentry.configureScope((p0) {
        for (var tag in tags.entries) {
          p0.setTag(tag.key, tag.value);
        }
      });
      return Sentry.captureException(exception, stackTrace: stackTrace);
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
