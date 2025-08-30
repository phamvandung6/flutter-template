import 'package:dio/dio.dart';
import 'package:flutter_template/core/utils/logger.dart';

/// Interceptor for logging network requests and responses
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);
  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug(_formatRequest(options));
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.debug(_formatResponse(response));
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.error(_formatError(err));
    handler.next(err);
  }

  String _formatRequest(RequestOptions options) {
    final buffer = StringBuffer()
      ..writeln('🌐 HTTP REQUEST')
      ..writeln('Method: ${options.method}')
      ..writeln('URL: ${options.uri}');

    if (options.headers.isNotEmpty) {
      buffer.writeln('Headers:');
      options.headers.forEach((key, value) {
        // Don't log sensitive headers
        if (_isSensitiveHeader(key)) {
          buffer.writeln('  $key: ***');
        } else {
          buffer.writeln('  $key: $value');
        }
      });
    }

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('Query Parameters:');
      options.queryParameters.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
    }

    if (options.data != null) {
      buffer.writeln('Body: ${_formatBody(options.data)}');
    }

    return buffer.toString();
  }

  String _formatResponse(Response<dynamic> response) {
    final buffer = StringBuffer()
      ..writeln('✅ HTTP RESPONSE')
      ..writeln('Status: ${response.statusCode} ${response.statusMessage}')
      ..writeln('URL: ${response.requestOptions.uri}');

    if (response.headers.map.isNotEmpty) {
      buffer.writeln('Headers:');
      response.headers.map.forEach((key, value) {
        buffer.writeln('  $key: ${value.join(', ')}');
      });
    }

    if (response.data != null) {
      buffer.writeln('Body: ${_formatBody(response.data)}');
    }

    return buffer.toString();
  }

  String _formatError(DioException err) {
    final buffer = StringBuffer()
      ..writeln('❌ HTTP ERROR')
      ..writeln('Type: ${err.type}')
      ..writeln('Message: ${err.message}');

    if (err.response != null) {
      buffer
        ..writeln('Status: ${err.response!.statusCode}')
        ..writeln('URL: ${err.requestOptions.uri}');

      if (err.response!.data != null) {
        buffer.writeln('Error Body: ${_formatBody(err.response!.data)}');
      }
    }

    return buffer.toString();
  }

  String _formatBody(dynamic data) {
    if (data == null) return 'null';

    try {
      // Limit body size for logging
      final dataString = data.toString();
      const maxLength = 1000;

      if (dataString.length > maxLength) {
        return '${dataString.substring(0, maxLength)}... (truncated)';
      }

      return dataString;
    } catch (e) {
      return 'Failed to format body: $e';
    }
  }

  bool _isSensitiveHeader(String key) {
    final sensitiveHeaders = [
      'authorization',
      'cookie',
      'x-api-key',
      'x-auth-token',
    ];

    return sensitiveHeaders.contains(key.toLowerCase());
  }
}
