/// Base class for all exceptions in the application
abstract class AppException implements Exception {

  const AppException({
    required this.message,
    this.statusCode,
  });
  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'AppException(message: $message, statusCode: $statusCode)';
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
  });
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.statusCode,
  });
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.statusCode,
  });
}

/// Authentication-related exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.statusCode,
  });
}

/// Validation-related exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.statusCode,
  });
}
