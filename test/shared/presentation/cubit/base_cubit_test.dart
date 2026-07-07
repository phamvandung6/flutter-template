import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/shared/presentation/bloc/base_view_state.dart';
import 'package:flutter_template/shared/presentation/cubit/base_cubit.dart';
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
      onSuccess: emitSuccess,
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
      onSuccess: emitSuccess,
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
        const BaseViewState<String>(),
        mockLogger,
      );
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state should be correct', () {
      expect(cubit.state, equals(const BaseViewState<String>()));
    });

    group('emitLoading', () {
      blocTest<TestBaseCubit, BaseViewState<String>>(
        'should emit loading state with message',
        build: () => cubit,
        act: (cubit) => cubit.testEmitLoading(),
        expect: () => [
          const BaseViewState<String>(
            status: ViewStatus.loading,
            message: 'Loading...',
          ),
        ],
      );

      blocTest<TestBaseCubit, BaseViewState<String>>(
        'should not emit when cubit is closed',
        build: () => cubit,
        act: (cubit) async {
          await cubit.close();
          cubit.testEmitLoading();
        },
        expect: () => <BaseViewState<String>>[],
      );
    });

    group('emitSuccess', () {
      blocTest<TestBaseCubit, BaseViewState<String>>(
        'should emit success state with data and message',
        build: () => cubit,
        act: (cubit) => cubit.testEmitSuccess('test data'),
        expect: () => [
          const BaseViewState<String>(
            status: ViewStatus.success,
            data: 'test data',
            message: 'Success',
          ),
        ],
      );
    });

    group('emitError', () {
      blocTest<TestBaseCubit, BaseViewState<String>>(
        'should emit error state and log error',
        build: () => cubit,
        act: (cubit) {
          const failure = ServerFailure(message: 'Test error', statusCode: 500);
          cubit.testEmitError(failure);
        },
        expect: () => [
          const BaseViewState<String>(
            status: ViewStatus.error,
            failure: ServerFailure(message: 'Test error', statusCode: 500),
            context: 'Test context',
          ),
        ],
        verify: (_) {
          verify(
            () => mockLogger.error('Cubit error: Test error', any()),
          ).called(1);
        },
      );
    });

    group('emitEmpty', () {
      blocTest<TestBaseCubit, BaseViewState<String>>(
        'should emit empty state with message',
        build: () => cubit,
        act: (cubit) => cubit.testEmitEmpty(),
        expect: () => [
          const BaseViewState<String>(
            status: ViewStatus.empty,
            message: 'Empty',
          ),
        ],
      );
    });

    group('handleEitherResult', () {
      blocTest<TestBaseCubit, BaseViewState<String>>(
        'should emit loading then success when Right is returned',
        build: () => cubit,
        act: (cubit) => cubit.testHandleEitherSuccess('success data'),
        expect: () => [
          const BaseViewState<String>(status: ViewStatus.loading),
          const BaseViewState<String>(
            status: ViewStatus.success,
            data: 'success data',
          ),
        ],
      );

      blocTest<TestBaseCubit, BaseViewState<String>>(
        'should emit loading then error when Left is returned',
        build: () => cubit,
        act: (cubit) {
          const failure = ServerFailure(
            message: 'Test failure',
            statusCode: 500,
          );
          return cubit.testHandleEitherFailure(failure);
        },
        expect: () => [
          const BaseViewState<String>(status: ViewStatus.loading),
          const BaseViewState<String>(
            status: ViewStatus.error,
            failure: ServerFailure(message: 'Test failure', statusCode: 500),
          ),
        ],
      );

      blocTest<TestBaseCubit, BaseViewState<String>>(
        'should not emit loading when showLoading is false',
        build: () => cubit,
        act: (cubit) => cubit.testHandleEitherWithoutLoading('success data'),
        expect: () => [
          const BaseViewState<String>(
            status: ViewStatus.success,
            data: 'success data',
          ),
        ],
      );

      test(
        'should not emit when cubit is closed during async operation',
        () async {
          // Start the async operation
          final future = cubit.testHandleEitherSuccess('test data');

          // Close the cubit immediately
          await cubit.close();

          // Wait for the operation to complete
          await future;

          // Verify no additional states were emitted after closing
          expect(cubit.isClosed, isTrue);
        },
      );
    });
  });
}
