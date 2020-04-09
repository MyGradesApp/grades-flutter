import 'dart:async';
import 'dart:io';

import 'package:sis_loader/sis_loader.dart';

class GenericHttpException implements Exception {
  final dynamic source;

  GenericHttpException(this.source);
}

bool isHttpError(Object error) {
  return error is SocketException ||
      error is HttpException ||
      error is HandshakeException ||
      error is OSError ||
      error is TimeoutException || // Not really, but this makes things easier
      error
          is UnknownReauthenticationException || // TODO: Handle these "properly"
      error is UnknownMissingCookieException ||
      error is UnknownStructureException ||
      error is UnknownInvalidAuthException;
}
