import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // 首先尝试从 .env 读取
  static String get baseUrl {
    final envUrl = dotenv.env['API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) return envUrl;

    return 'http://127.0.0.1:8000';
  }

  static const Duration defaultTimeout = Duration(milliseconds: 5000);

  static const String headerTokenKey = 'X-Token';
  static const String contentType = 'application/json;charset=UTF-8';

  static const String extraIsLoading = 'isLoading';
  static const String extraIsToast = 'isToast';
  static const String extraIsCancelReq = 'isCancelReq';
  static const String extraIsDeduplication = 'isDeduplication';

  static const String tokenExpiredCode = '0200002';
  static const String tokenRefreshFailed = 'Token刷新失败，请重新登录';
  static const String networkTimeoutMessage = '网络连接超时，请检查网络后重试';
}
