import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gjol_app/core/network/api_constants.dart';

class ApiInterceptors {
  final FlutterSecureStorage _secureStorage;
  final Dio _dio;

  // Token刷新状态
  bool _isRefreshing = false;
  final List<Completer<String?>> _refreshCompleters = [];

  ApiInterceptors(this._dio, this._secureStorage);

  /// 统一处理请求
  Future<void> onRequest(RequestOptions options) async {
    final accessToken = await _secureStorage.read(
      key: ApiConstants.accessTokenKey,
    );
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  /// 统一处理响应
  Future<void> onResponse(Response response) async {
    // 处理响应
    await _checkAndSaveTokensFromResponse(response);
  }

  /// 统一处理错误
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 处理错误
    final request = err.requestOptions;
    final response = err.response;
    // 统一处理Token过期
    if (response?.statusCode == 401) {
      // 刷新Token
      if (request.path.contains('/auth/refresh')) {
        await _handleRefreshFailure();
        return handler.reject(err);
      }
      final newToken = await _refreshTokenWithQueue();
      if (newToken != null) {
        // 使用新token重试原始请求
        try {
          final retryResponse = await _retryRequest(request, newToken);
          return handler.resolve(retryResponse);
        } catch (retryError) {
          return handler.reject(retryError as DioException);
        }
      } else {
        // 刷新token失败，需要重新登录
        await _handleRefreshFailure();
        return handler.reject(err);
      }
    }
  }

  /// 检查响应是否包含Token，并保存
  Future<void> _checkAndSaveTokensFromResponse(Response response) async {
    final Map<String, dynamic>? resData = response.data;

    if (resData == null || resData.isEmpty) return;
    if(resData["data"] is! Map) return;

    final Map<String, dynamic>? data = resData["data"];
    if (data == null || data.isEmpty) return;

    final String? accessToken = data[ApiConstants.accessTokenKey];
    final String? refreshToken = data[ApiConstants.refreshTokenKey];
    if (accessToken != null || refreshToken != null) {
      await _saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    }
  }

  /// 保存Tokens到本地存储
  Future<void> _saveTokens({String? accessToken, String? refreshToken}) async {
    if (accessToken != null && accessToken.isNotEmpty) {
      await _secureStorage.write(
        key: ApiConstants.accessTokenKey,
        value: accessToken,
      );
    }

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _secureStorage.write(
        key: ApiConstants.refreshTokenKey,
        value: refreshToken,
      );
    }
  }

  /// 刷新Token失败处理
  Future<void> _handleRefreshFailure() async {
    _isRefreshing = false;
    await _clearTokens();
    for (final completer in _refreshCompleters) {
      completer.complete(null);
    }
    _refreshCompleters.clear();
  }

  /// 清除Tokens
  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: ApiConstants.accessTokenKey);
    await _secureStorage.delete(key: ApiConstants.refreshTokenKey);
  }

  // Token刷新
  Future<String?> _refreshTokenWithQueue() async {
    // 如果已经在刷新，等待其他刷新完成
    if (_isRefreshing) {
      final completer = Completer<String?>();
      _refreshCompleters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;

    try {
      final newToken = await _refreshToken();

      // 通知所有等待的请求
      for (final completer in _refreshCompleters) {
        completer.complete(newToken);
      }

      return newToken;
    } catch (e) {
      // 通知所有等待的请求刷新失败
      for (final completer in _refreshCompleters) {
        completer.complete(null);
      }
      rethrow;
    } finally {
      _isRefreshing = false;
      _refreshCompleters.clear();
    }
  }

  /// 刷新Token
  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: ApiConstants.refreshTokenKey);

      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }


      // 使用新的Dio实例避免循环拦截
      final refreshDio = Dio();

      final response = await refreshDio.post(
        '${_dio.options.baseUrl}/auth/refresh',
        data: {
          'refresh_token': refreshToken,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final newAccessToken = responseData['access_token'];
        final newRefreshToken = responseData['refresh_token'];

        // 保存新的tokens
        await _saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        return newAccessToken;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// 重试请求
  Future<Response> _retryRequest(
    RequestOptions requestOptions,
    String newToken
  ) async {
    // 创建新的请求选项，使用新的token
    final newOptions = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newToken',
      },
      extra: requestOptions.extra,
      contentType: requestOptions.contentType,
      responseType: requestOptions.responseType,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      followRedirects: requestOptions.followRedirects,
      maxRedirects: requestOptions.maxRedirects,
      persistentConnection: requestOptions.persistentConnection,
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
    );


    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: newOptions,
    );
  }
}
