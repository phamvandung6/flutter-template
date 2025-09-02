import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/core/utils/logger.dart';

void main() {
  group('AppLogger', () {
    late AppLogger logger;

    setUp(() {
      logger = AppLogger();
    });

    test('should create logger instance', () {
      expect(logger, isA<AppLogger>());
    });

    test('should log debug message without throwing error', () {
      expect(() => logger.debug('Debug message'), returnsNormally);
    });

    test('should log info message without throwing error', () {
      expect(() => logger.info('Info message'), returnsNormally);
    });

    test('should log warning message without throwing error', () {
      expect(() => logger.warning('Warning message'), returnsNormally);
    });

    test('should log error message without throwing error', () {
      expect(() => logger.error('Error message'), returnsNormally);
    });

    test('should log error with exception without throwing error', () {
      final exception = Exception('Test exception');
      expect(
        () => logger.error('Error message', exception),
        returnsNormally,
      );
    });

    test('should log error with stack trace without throwing error', () {
      final stackTrace = StackTrace.current;
      expect(
        () => logger.error('Error message', null, stackTrace),
        returnsNormally,
      );
    });
  });
}
