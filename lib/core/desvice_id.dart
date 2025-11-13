import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future<String?> getAndroidId() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  return androidInfo.id;
}

Future<String?> getIosId() async {
  final deviceInfo = DeviceInfoPlugin();
  final iosInfo = await deviceInfo.iosInfo;
  return iosInfo.identifierForVendor;
}

String getHashId(String deviceId) {
  final bytes = utf8.encode(deviceId);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<String> getStableDeviceId() async {
  final storage = const FlutterSecureStorage();
  const key = 'device_id';
  var id = await storage.read(key: key);
  if (id != null) return id;

  String? platformId;
  if (Platform.isIOS) {
    platformId = await getIosId();
  } else if (Platform.isAndroid) {
    platformId = await getAndroidId();
  }

  id = platformId ?? const Uuid().v4();
  final hashId = getHashId(id);
  await storage.write(key: key, value: hashId);
  return hashId;
}
