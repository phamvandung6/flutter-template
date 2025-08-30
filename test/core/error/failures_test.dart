import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('should be equatable', () {
      const failure1 = ServerFailure(message: 'Test message', statusCode: 500);
      const failure2 = ServerFailure(message: 'Test message', statusCode: 500);
      const failure3 =
          ServerFailure(message: 'Different message', statusCode: 500);

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });

    test('should have correct props', () {
      const failure = ServerFailure(message: 'Test message', statusCode: 500);
      expect(failure.props, equals(['Test message', 500]));
    });
  });

  group('ServerFailure', () {
    test('should create instance with message and status code', () {
      const message = 'Server error occurred';
      const statusCode = 500;

      const failure = ServerFailure(message: message, statusCode: statusCode);

      expect(failure.message, equals(message));
      expect(failure.statusCode, equals(statusCode));
    });

    test('should be a Failure', () {
      const failure = ServerFailure(message: 'Test', statusCode: 500);
      expect(failure, isA<Failure>());
    });

    test('should have toString implementation', () {
      const failure = ServerFailure(message: 'Server error', statusCode: 500);
      final string = failure.toString();

      expect(string, contains('ServerFailure'));
      expect(string, contains('Server error'));
      expect(string, contains('500'));
    });
  });

  group('CacheFailure', () {
    test('should create instance with message and status code', () {
      const message = 'Cache error occurred';
      const statusCode = 404;

      const failure = CacheFailure(message: message, statusCode: statusCode);

      expect(failure.message, equals(message));
      expect(failure.statusCode, equals(statusCode));
    });

    test('should be a Failure', () {
      const failure = CacheFailure(message: 'Test', statusCode: 404);
      expect(failure, isA<Failure>());
    });

    test('should have toString implementation', () {
      const failure = CacheFailure(message: 'Cache error', statusCode: 404);
      final string = failure.toString();

      expect(string, contains('CacheFailure'));
      expect(string, contains('Cache error'));
      expect(string, contains('404'));
    });
  });

  group('NetworkFailure', () {
    test('should create instance with message and status code', () {
      const message = 'Network error occurred';
      const statusCode = 0;

      const failure = NetworkFailure(message: message, statusCode: statusCode);

      expect(failure.message, equals(message));
      expect(failure.statusCode, equals(statusCode));
    });

    test('should be a Failure', () {
      const failure = NetworkFailure(message: 'Test', statusCode: 0);
      expect(failure, isA<Failure>());
    });

    test('should have toString implementation', () {
      const failure = NetworkFailure(message: 'Network error', statusCode: 0);
      final string = failure.toString();

      expect(string, contains('NetworkFailure'));
      expect(string, contains('Network error'));
      expect(string, contains('0'));
    });
  });

  group('ValidationFailure', () {
    test('should create instance with message and status code', () {
      const message = 'Validation error occurred';
      const statusCode = 400;

      const failure =
          ValidationFailure(message: message, statusCode: statusCode);

      expect(failure.message, equals(message));
      expect(failure.statusCode, equals(statusCode));
    });

    test('should be a Failure', () {
      const failure = ValidationFailure(message: 'Test', statusCode: 400);
      expect(failure, isA<Failure>());
    });

    test('should have toString implementation', () {
      const failure =
          ValidationFailure(message: 'Validation error', statusCode: 400);
      final string = failure.toString();

      expect(string, contains('ValidationFailure'));
      expect(string, contains('Validation error'));
      expect(string, contains('400'));
    });
  });

  group('AuthenticationFailure', () {
    test('should create instance with message and status code', () {
      const message = 'Authentication failed';
      const statusCode = 401;

      const failure =
          AuthenticationFailure(message: message, statusCode: statusCode);

      expect(failure.message, equals(message));
      expect(failure.statusCode, equals(statusCode));
    });

    test('should be a Failure', () {
      const failure = AuthenticationFailure(message: 'Test', statusCode: 401);
      expect(failure, isA<Failure>());
    });

    test('should have toString implementation', () {
      const failure =
          AuthenticationFailure(message: 'Auth failed', statusCode: 401);
      final string = failure.toString();

      expect(string, contains('AuthenticationFailure'));
      expect(string, contains('Auth failed'));
      expect(string, contains('401'));
    });
  });

  group('GeneralFailure', () {
    test('should create instance with message and status code', () {
      const message = 'General error occurred';
      const statusCode = -1;

      const failure = GeneralFailure(message: message, statusCode: statusCode);

      expect(failure.message, equals(message));
      expect(failure.statusCode, equals(statusCode));
    });

    test('should be a Failure', () {
      const failure = GeneralFailure(message: 'Test', statusCode: -1);
      expect(failure, isA<Failure>());
    });

    test('should have toString implementation', () {
      const failure = GeneralFailure(message: 'General error', statusCode: -1);
      final string = failure.toString();

      expect(string, contains('GeneralFailure'));
      expect(string, contains('General error'));
      expect(string, contains('-1'));
    });
  });
}
