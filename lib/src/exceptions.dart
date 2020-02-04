class InvalidAuthException implements Exception {
  final String message;

  InvalidAuthException(this.message);

  @override
  String toString() {
    return 'InvalidAuthException: ${message}';
  }
}

class UnknownInvalidAuthException implements Exception {
  final String message;

  UnknownInvalidAuthException(this.message);

  @override
  String toString() {
    return 'UnknownInvalidAuthException: ${message}';
  }
}
