import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  LoggerInterceptor();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i('${options.method} ${options.uri}');

      if (options.queryParameters.isNotEmpty) {
        _logger.d('Query: ${options.queryParameters}');
      }

      if (options.data != null) {
        _logger.d('Body: ${options.data}');
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i(
        'STATUS: ${response.statusCode} | ${response.requestOptions.method} ${response.requestOptions.uri}',
      );

      _logger.d(response.data);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        '${err.requestOptions.method} ${err.requestOptions.uri}',
        error: err.message,
      );

      if (err.response != null) {
        _logger.e(
          'STATUS: ${err.response?.statusCode}',
          error: err.response?.data,
        );
      }
    }

    handler.next(err);
  }
}
