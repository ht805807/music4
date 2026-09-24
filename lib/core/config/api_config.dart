class ApiConfig {
  /// All API traffic uses HTTPS by default. Builds may override this value
  /// with `--dart-define=API_BASE_URL=...` for another HTTPS environment.
  static const String baseUrl = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'https://123.194.96.90/api');
  static const String encryptionKeyBase64 =
      String.fromEnvironment('API_AES_KEY_B64');
  static Uri uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${baseUrl.replaceFirst(RegExp(r'/+$'), '')}/$path')
          .replace(queryParameters: query);
}
