import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

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
  await storage.write(key: key, value: id);
  return id;
}
