import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/utils/typedef.dart';
import 'package:flutter_template/core/utils/usecase.dart';

// Test implementation of UseCase
class TestUseCase extends UseCase<String, TestParams> {
  @override
  ResultFuture<String> call(TestParams params) async {
    if (params.shouldSucceed) {
      return Right(params.data);
    } else {
      return const Left(
          ServerFailure(message: 'Test failure', statusCode: 500),);
    }
  }
}

// Test implementation of UseCaseWithoutParams
class TestUseCaseWithoutParams extends UseCaseWithoutParams<String> {

  TestUseCaseWithoutParams({this.shouldSucceed = true});
  final bool shouldSucceed;

  @override
  ResultFuture<String> call() async {
    if (shouldSucceed) {
      return const Right('Success');
    } else {
      return const Left(
          ServerFailure(message: 'Test failure', statusCode: 500),);
    }
  }
}

// Test implementation of StreamUseCase
class TestStreamUseCase extends StreamUseCase<String, TestParams> {
  @override
  Stream<String> call(TestParams params) {
    return Stream.fromIterable([params.data]);
  }
}

// Test parameters class
class TestParams {

  TestParams({required this.data, this.shouldSucceed = true});
  final String data;
  final bool shouldSucceed;
}

void main() {
  group('UseCase', () {
    late TestUseCase useCase;

    setUp(() {
      useCase = TestUseCase();
    });

    test('should return Right when successful', () async {
      // Arrange
      const testData = 'test data';
      final params = TestParams(data: testData);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Right<Failure, String>>());
      result.fold(
        (failure) => fail('Expected Right, got Left'),
        (data) => expect(data, equals(testData)),
      );
    });

    test('should return Left when failure occurs', () async {
      // Arrange
      const testData = 'test data';
      final params = TestParams(data: testData, shouldSucceed: false);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, isA<Left<Failure, String>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals('Test failure'));
          expect(failure.statusCode, equals(500));
        },
        (data) => fail('Expected Left, got Right'),
      );
    });
  });

  group('UseCaseWithoutParams', () {
    test('should return Right when successful', () async {
      // Arrange
      final useCase = TestUseCaseWithoutParams();

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Right<Failure, String>>());
      result.fold(
        (failure) => fail('Expected Right, got Left'),
        (data) => expect(data, equals('Success')),
      );
    });

    test('should return Left when failure occurs', () async {
      // Arrange
      final useCase = TestUseCaseWithoutParams(shouldSucceed: false);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Left<Failure, String>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals('Test failure'));
        },
        (data) => fail('Expected Left, got Right'),
      );
    });
  });

  group('StreamUseCase', () {
    late TestStreamUseCase streamUseCase;

    setUp(() {
      streamUseCase = TestStreamUseCase();
    });

    test('should return stream with correct data', () async {
      // Arrange
      const testData = 'stream data';
      final params = TestParams(data: testData);

      // Act
      final stream = streamUseCase(params);

      // Assert
      expect(stream, isA<Stream<String>>());
      await expectLater(stream, emits(testData));
    });
  });

  group('NoParams', () {
    test('should create NoParams instance', () {
      // Act
      const noParams = NoParams();

      // Assert
      expect(noParams, isA<NoParams>());
    });

    test('should be const constructor', () {
      // Act
      const noParams1 = NoParams();
      const noParams2 = NoParams();

      // Assert
      expect(identical(noParams1, noParams2), isTrue);
    });
  });
}
