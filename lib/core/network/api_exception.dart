class ApiException implements Exception {
  const ApiException(this.userMessage);
  final String userMessage;
  @override
  String toString() => userMessage;
}
