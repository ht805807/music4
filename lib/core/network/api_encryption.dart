import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../config/api_config.dart';
import 'api_exception.dart';

/// AES-256-GCM envelope shared with `backend/helpers/encryption.php`.
class ApiEncryption {
  ApiEncryption()
      : _algorithm = AesGcm.with256bits(),
        _secretKey = SecretKey(_keyBytes());

  final AesGcm _algorithm;
  final SecretKey _secretKey;

  static List<int> _keyBytes() {
    final configuredKey = ApiConfig.encryptionKeyBase64;
    if (configuredKey.isEmpty) {
      throw const ApiException('此版本尚未設定加密 API 金鑰。');
    }
    try {
      final key = base64Decode(configuredKey);
      if (key.length != 32) throw const FormatException();
      return key;
    } on FormatException {
      throw const ApiException('加密 API 金鑰格式錯誤。');
    }
  }

  Future<Map<String, String>> encrypt(Map<String, dynamic> payload) async {
    final box = await _algorithm.encrypt(
      utf8.encode(jsonEncode(payload)),
      secretKey: _secretKey,
    );
    return {
      'v': '1',
      'iv': base64Encode(box.nonce),
      'ciphertext': base64Encode(box.cipherText),
      'tag': base64Encode(box.mac.bytes),
    };
  }

  Future<dynamic> decrypt(String body) async {
    try {
      final envelope = jsonDecode(body);
      if (envelope is! Map<String, dynamic> ||
          envelope['v'] != 1 ||
          envelope['iv'] is! String ||
          envelope['ciphertext'] is! String ||
          envelope['tag'] is! String) {
        throw const FormatException();
      }
      final clearText = await _algorithm.decrypt(
        SecretBox(
          base64Decode(envelope['ciphertext'] as String),
          nonce: base64Decode(envelope['iv'] as String),
          mac: Mac(base64Decode(envelope['tag'] as String)),
        ),
        secretKey: _secretKey,
      );
      return jsonDecode(utf8.decode(clearText));
    } on FormatException {
      throw const ApiException('伺服器加密資料格式異常，請稍後再試。');
    } on SecretBoxAuthenticationError {
      throw const ApiException('伺服器加密資料驗證失敗，請稍後再試。');
    }
  }
}
