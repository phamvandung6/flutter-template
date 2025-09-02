import 'package:dio/dio.dart';

import 'package:flutter_template/core/error/exceptions.dart';
import 'package:flutter_template/core/utils/logger.dart';

/// Interceptor for handling and transforming network errors
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._logger);
  final AppLogger _logger;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _mapDioExceptionToAppException(err);
    _logger.error('Network error occurred', appException);

    // Transform DioException to custom AppException
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException,
        message: appException.message,
      ),
    );
  }

  AppException _mapDioExceptionToAppException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(dioException);

      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'Request was cancelled.',
          statusCode: 499,
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message:
              'No internet connection. Please check your network settings.',
          statusCode: 0,
        );

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Certificate verification failed.',
          statusCode: 495,
        );

      case DioExceptionType.unknown:
      default:
        return NetworkException(
          message: dioException.message ?? 'An unexpected error occurred.',
          statusCode: 0,
        );
    }
  }

  AppException _handleResponseError(DioException dioException) {
    final response = dioException.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    // Try to extract error message from response
    var errorMessage = 'An error occurred';

    if (data is Map<String, dynamic>) {
      errorMessage = (data['message'] ??
          data['error'] ??
          data['detail'] ??
          errorMessage) as String;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'Invalid request. Please check your input.',
          statusCode: 400,
        );

      case 401:
        return const AuthenticationException(
          message: 'Authentication failed. Please login again.',
          statusCode: 401,
        );

      case 403:
        return const AuthenticationException(
          message:
              "Access denied. You don't have permission to perform this action.",
          statusCode: 403,
        );

      case 404:
        return const ServerException(
          message: 'The requested resource was not found.',
          statusCode: 404,
        );

      case 422:
        return ValidationException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'The provided data is invalid.',
          statusCode: 422,
        );

      case 429:
        return ServerException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'Too many requests. Please try again later.',
          statusCode: 429,
        );

      case 500:
        return ServerException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'Internal server error. Please try again later.',
          statusCode: 500,
        );

      case 502:
      case 503:
      case 504:
        return ServerException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'Server is temporarily unavailable. Please try again later.',
          statusCode: statusCode ?? 503,
        );

      default:
        return ServerException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : 'Server error occurred (${statusCode ?? 'Unknown'}).',
          statusCode: statusCode,
        );
    }
  }
}
