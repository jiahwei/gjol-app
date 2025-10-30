import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class WifiUtils {
  static Future<String?> getSSID() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.location.request();
      if (!status.isGranted) return null;

      final info = NetworkInfo();
      return await info.getWifiName(); // SSID
    }
    return null;
  }
}
