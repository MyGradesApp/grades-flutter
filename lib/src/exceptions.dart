class InvalidAuthException implements Exception {
  final String message;

  InvalidAuthException(this.message);

  @override
  String toString() {
    return 'InvalidAuthException: ${message}';
  }
}
