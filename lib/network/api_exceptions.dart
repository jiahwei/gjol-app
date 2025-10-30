import 'package:dio/dio.dart';

/// HTTP请求异常基类
class HttpException implements Exception {
  final String message;
  final DioException? dioError;
  final dynamic responseData;

  HttpException(this.message, {this.dioError, this.responseData});
}

/// 携带响应数据的特殊异常（用于Token刷新后重试）
class ReturnWithResponse implements Exception {
  final Response response;
  ReturnWithResponse(this.response);
}
