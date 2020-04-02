import 'dart:async';
import 'dart:io';

class GenericHttpException implements Exception {
  final dynamic source;

  GenericHttpException(this.source);
}

bool isHttpError(Object error) {
  return error is SocketException ||
      error is HttpException ||
      error is HandshakeException ||
      error is OSError ||
      error is TimeoutException; // Not really, but this makes things easier
}
