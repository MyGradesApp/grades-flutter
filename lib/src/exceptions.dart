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

class UnknownStructureException implements Exception {
  final String message;
  final int error;

  UnknownStructureException(this.message, this.error);

  @override
  String toString() {
    return 'UnknownStructureException: ${message} with error code ${error}';
  }
}
