import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_encryption.dart';
import 'api_exception.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _timeout = Duration(seconds: 12);

  /// Encrypted endpoints use POST even for reads so query data is protected.
  Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _request(path, Map<String, dynamic>.from(query ?? const {}));

  Future<dynamic> post(String path, Map<String, dynamic> body) =>
      _request(path, body);

  Future<dynamic> _request(String path, Map<String, dynamic> payload) async {
    try {
      final encryption = ApiEncryption();
      final encryptedBody = jsonEncode(await encryption.encrypt(payload));
      final response = await _client
          .post(
            ApiConfig.uri(path),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'X-API-Encrypted': '1',
            },
            body: encryptedBody,
          )
          .timeout(_timeout);
      final json = await encryption.decrypt(response.body);
      if (json is! Map<String, dynamic>) {
        throw const ApiException('伺服器回傳格式異常，請稍後再試。');
      }
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          json['success'] != true) {
        if (response.statusCode == 429) {
          throw const ApiException('操作過於頻繁，請稍後再試。');
        }
        throw ApiException(json['message'] is String &&
                (json['message'] as String).trim().isNotEmpty
            ? json['message'] as String
            : '目前無法取得資料，請稍後再試。');
      }
      return json['data'];
    } on SocketException {
      throw const ApiException('目前無法連線，請確認網路後重試。');
    } on TimeoutException {
      throw const ApiException('連線逾時，請稍後再試。');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('目前無法取得資料，請稍後再試。');
    }
  }
}
