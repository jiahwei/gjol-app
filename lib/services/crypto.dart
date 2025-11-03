import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyCrypto  {
  static final String _hexKey = dotenv.env['AES_KEY'] ?? '';
  static final List<int> _keyBytes = List<int>.generate(
    _hexKey.length ~/ 2,
        (i) => int.parse(_hexKey.substring(i * 2, i * 2 + 2), radix: 16),
  );
  static final Key _aesKey = Key(Uint8List.fromList(_keyBytes));
  static final IV _iv = IV.fromLength(12);
  static final _hmacSecret = dotenv.env['HMAC_SECRET'] ?? 'your-hmac-secret';

  static String encryptAndroidId(String androidId) {
    final encrypter = Encrypter(AES(_aesKey, mode: AESMode.gcm));
    final encrypted = encrypter.encrypt(androidId, iv: _iv);
    final decrypted = encrypter.decrypt(encrypted, iv: _iv);

    return encrypted.base64;
  }

  /// HMAC-SHA256 签名
  static String sign(String encryptedId) {
    final key = utf8.encode(_hmacSecret);
    final bytes = utf8.encode(encryptedId);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }

  /// 打包请求体
  static Map<String, String> buildPayload(String androidId) {
    final encrypted = encryptAndroidId(androidId);
    final signature = sign(encrypted);
    return {
      'id': encrypted,
      'sig': signature,
      'iv': base64.encode(_iv.bytes),
    };
  }
}
