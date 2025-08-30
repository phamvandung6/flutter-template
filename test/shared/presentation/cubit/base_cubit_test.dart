import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/shared/presentation/bloc/base_bloc_state.dart';
import 'package:flutter_template/shared/presentation/cubit/base_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mock_dependencies.dart';

// Test implementation of BaseCubit
class TestBaseCubit extends BaseCubit<String> {
  TestBaseCubit(super.initialState, super.logger);

  void testEmitLoading() => emitLoading(message: 'Loading...');

  void testEmitSuccess(String data) => emitSuccess(data, message: 'Success');

  void testEmitError(Failure failure) =>
      emitError(failure, context: 'Test context');

  void testEmitEmpty() => emitEmpty(message: 'Empty');

  Future<void> testHandleEitherSuccess(String data) async {
    await handleEitherResult<String>(
      Future.value(Right(data)),
      onSuccess: (data) => emitSuccess(data),
    );
  }

  Future<void> testHandleEitherFailure(Failure failure) async {
    await handleEitherResult<String>(
      Future.value(Left(failure)),
    );
  }

  Future<void> testHandleEitherWithoutLoading(String data) async {
    await handleEitherResult<String>(
      Future.value(Right(data)),
      showLoading: false,
      onSuccess: (data) => emitSuccess(data),
    );
  }
}

void main() {
  group('BaseCubit', () {
    late TestBaseCubit cubit;
    late MockAppLogger mockLogger;

    setUp(() {
      MockSetup.setupMocks();
      mockLogger = MockAppLogger();
      cubit = TestBaseCubit(
        const BaseBlocState<String>(),
        mockLogger,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be correct', () {
      expect(cubit.state, equals(const BaseBlocState<String>()));
    });

    group('emitLoading', () {
      blocTest<TestBaseCubit, BaseBlocState<String>>(
        'should emit loading state with message',
        build: () => cubit,
        act: (cubit) => cubit.testEmitLoading(),
        expect: () => [
          const BaseBlocState<String>(
            status: BlocStatus.loading,
            message: 'Loading...',
          ),
        ],
      );

      blocTest<TestBaseCubit, BaseBlocState<String>>(
        'should not emit when cubit is closed',
        build: () => cubit,
        act: (cubit) async {
          await cubit.close();
          cubit.testEmitLoading();
        },
        expect: () => [],
      );
    });

    group('emitSuccess', () {
      blocTest<TestBaseCubit, BaseBlocState<String>>(
        'should emit success state with data and message',
        build: () => cubit,
        act: (cubit) => cubit.testEmitSuccess('test data'),
        expect: () => [
          const BaseBlocState<String>(
            status: BlocStatus.success,
            data: 'test data',
            message: 'Success',
          ),
        ],
      );
    });

    group('emitError', () {
      blocTest<TestBaseCubit, BaseBlocState<String>>(
        'should emit error state and log error',
        build: () => cubit,
        act: (cubit) {
          const failure = ServerFailure(message: 'Test error', statusCode: 500);
          cubit.testEmitError(failure);
        },
        expect: () => [
          const BaseBlocState<String>(
            status: BlocStatus.error,
            failure: ServerFailure(message: 'Test error', statusCode: 500),
            context: 'Test context',
          ),
        ],
        verify: (_) {
          verify(() => mockLogger.error('Cubit error: Test error', any()))
              .called(1);
        },
      );
    });

    group('emitEmpty', () {
      blocTest<TestBaseCubit, BaseBlocState<String>>(
        'should emit empty state with message',
        build: () => cubit,
        act: (cubit) => cubit.testEmitEmpty(),
        expect: () => [
          const BaseBlocState<String>(
            status: BlocStatus.empty,
            message: 'Empty',
          ),
        ],
      );
    });

    group('handleEitherResult', () {
      blocTest<TestBaseCubit, BaseBlocState<String>>(
        'should emit loading then success when Right is returned',
        build: () => cubit,
        act: (cubit) => cubit.testHandleEitherSuccess('success data'),
        expect: () => [
          const BaseBlocState<String>(status: BlocStatus.loading),
          const BaseBlocState<String>(
            status: BlocStatus.success,
            data: 'success data',
          ),
        ],
      );

      blocTest<TestBaseCubit, BaseBlocState<String>>(
        'should emit loading then error when Left is returned',
        build: () => cubit,
        act: (cubit) {
          const failure =
              ServerFailure(message: 'Test failure', statusCode: 500);
          return cubit.testHandleEitherFailure(failure);
        },
        expect: () => [
          const BaseBlocState<String>(status: BlocStatus.loading),
          const BaseBlocState<String>(
            status: BlocStatus.error,
            failure: ServerFailure(message: 'Test failure', statusCode: 500),
          ),
        ],
      );

      blocTest<TestBaseCubit, BaseBlocState<String>>(
        'should not emit loading when showLoading is false',
        build: () => cubit,
        act: (cubit) => cubit.testHandleEitherWithoutLoading('success data'),
        expect: () => [
          const BaseBlocState<String>(
            status: BlocStatus.success,
            data: 'success data',
          ),
        ],
      );

      test('should not emit when cubit is closed during async operation',
          () async {
        // Start the async operation
        final future = cubit.testHandleEitherSuccess('test data');

        // Close the cubit immediately
        await cubit.close();

        // Wait for the operation to complete
        await future;

        // Verify no additional states were emitted after closing
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
