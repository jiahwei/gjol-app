import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:gjol_app/core/network/api_constants.dart';
import 'package:gjol_app/core/network/api_exceptions.dart';
// import 'package:gjol_app/network/api_interceptors.dart'; // 如果有自定义处理器，可取消注释并调用相关方法

// 内部共享的 Dio 实例
final Dio _dio = Dio();

bool _initialized = false;

/// 提供静态 init 方法，main.dart 中调用 ApiProvider.init()
class ApiProvider {
  ApiProvider._();

  static Future<void> init() async {
    if (_initialized) return;

    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.defaultTimeout,
      receiveTimeout: ApiConstants.defaultTimeout,
      headers: {'Content-Type': ApiConstants.contentType},
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
        ),
      );
    }

    // 添加默认拦截器（只添加一次）
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 如果有自定义 onRequest（在 api_interceptors.dart），在此处调用
          // await onRequest(options);
          handler.next(options);
        },
        onResponse: (response, handler) {
          // 统一处理 response（按需修改）
          handler.next(response);
        },
        onError: (err, handler) {
          // 统一处理错误（按需修改）
          handler.next(err);
        },
      ),
    );

    _initialized = true;
  }
}

/// 公共请求函数（使用同一 Dio 实例）
Future<T> request<T>(
  String path, {
  String method = 'POST',
  dynamic data,
  bool isLoading = true,
  bool isToast = true,
  bool isCancelReq = true,
  bool isDeduplication = true,
  T Function(Map<String, dynamic>)? fromJson,
  T Function(List<dynamic>)? fromJsonList,
}) async {
  try {
    final isGet = method.toUpperCase() == 'GET';
    final response = await _dio.request(
      path,
      data: isGet ? null : data,
      queryParameters: isGet ? data : null,
      options: Options(
        method: method,
        extra: {
          ApiConstants.extraIsLoading: isLoading,
          ApiConstants.extraIsToast: isToast,
          ApiConstants.extraIsCancelReq: isCancelReq,
          ApiConstants.extraIsDeduplication: isDeduplication,
        },
      ),
    );
    return parseResponse<T>(response.data['data'], fromJson, fromJsonList);

  } on DioException catch (e) {
    final message = e.message ?? ApiConstants.networkTimeoutMessage;
    throw HttpException(message, dioError: e);
  }
}

T parseResponse<T>(dynamic data, T Function(Map<String, dynamic>)? fromJson, T Function(List<dynamic>)? fromJsonList) {
  if (fromJson != null && data is Map) {
    return fromJson(Map<String, dynamic>.from(data));
  }
  if (fromJsonList != null && data is List) {
    return fromJsonList(List<dynamic>.from(data));
  }
  if (data is T) return data;
  throw HttpException('Response type mismatch');
}

Future<M> requestModel<M>(
  String path, {
  String method = 'POST',
  dynamic data,
  required M Function(Map<String, dynamic>) fromJson,
}) async {
  return await request<M>(
    path,
    method: method,
    data: data,
    fromJson: fromJson,
  );
}

Future<List<M>> requestList<M>(
  String path, {
  String method = 'POST',
  dynamic data,
  required M Function(Map<String, dynamic>) itemFromJson,
}) async {
  return await request<List<M>>(
    path,
    method: method,
    data: data,
    fromJsonList: (list) => list
        .map((e) => itemFromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
  );
}
