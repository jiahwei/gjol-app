// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:gjol_app/network/http_client.dart';

// // 不再创建新的 Dio 实例，使用共享的
// final Dio dio = HttpClient.instance.dio;

// bool isRefreshing = false;
// final List<Completer<Response>> waitingCompleters = [];

// Future<void> onRequest(RequestOptions options) async {
//   _handleLoading(options); // 处理加载状态
//   await _attachToken(options); // 附加Token
//   _checkDuplicateRequest(options); // 请求去重
//   _setupCancelToken(options); // 设置取消Token
// }

// Future<void> _attachToken(RequestOptions options) async {
//   final AuthModel authModel = await AuthServices.get();
//   if (authModel.token.isNotEmpty) {
//     options.headers[ApiConstants.headerTokenKey] = authModel.token;
//   }
// }

// Future<Response> _handleTokenExpired(RequestOptions options) async {
//   if (isRefreshing) {
//     // 已有刷新请求时加入等待队列
//     final completer = Completer<Response>();
//     waitingCompleters.add(completer);
//     await completer.future;
//     return await dio.fetch(options..cancelToken = null);
//   }

//   isRefreshing = true;
//   try {
//     // 执行Token刷新
//     AuthModel authModel = await AuthServices.get();
//     AuthModel newAuthModel = await AuthRepository.refresh(authModel.refreshToken);

//     // 保存新Token
//     await AuthServices.set(newAuthModel);
//     options.headers[ApiConstants.headerTokenKey] = newAuthModel.token;

//     // 重试原始请求
//     final newResponse = await dio.fetch(options..cancelToken = null);

//     // 完成所有等待中的请求
//     for (final c in waitingCompleters) {
//       if (!c.isCompleted) c.complete(newResponse);
//     }

//     return newResponse;
//   } finally {
//     isRefreshing = false;
//     waitingCompleters.clear();
//   }
// }
