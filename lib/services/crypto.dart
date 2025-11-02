import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SecurityHelper {
  // AES 密钥（必须是 32 字节）
  static final _key = dotenv.env['AES_KEY'] ?? '';
  static final _aesKey = Key.fromUtf8(_key);
  static final _iv = IV.fromLength(16);

  // HMAC 密钥（服务端共享）
  static final _hmacSecret = dotenv.env['HMAC_SECRET'] ?? 'your-hmac-secret';

  /// AES 加密 Android ID
  static String encryptAndroidId(String androidId) {
    final encrypter = Encrypter(AES(_aesKey, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(androidId, iv: _iv);
    return encrypted.base64;
  }

  /// HMAC-SHA256 签名
  static String sign(String encryptedId) {
    final key = utf8.encode(_hmacSecret);
    final bytes = utf8.encode(encryptedId);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString(); // hex string
  }

  /// 打包请求体
  static Map<String, String> buildPayload(String androidId) {
    final encrypted = encryptAndroidId(androidId);
    final signature = sign(encrypted);
    return {
      'id': encrypted,
      'sig': signature,
    };
  }
}
