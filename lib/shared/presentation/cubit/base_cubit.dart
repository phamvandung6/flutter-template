import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/shared/presentation/bloc/base_bloc_state.dart';
import 'package:flutter_template/shared/presentation/bloc/base_bloc_state_extensions.dart';

/// Base Cubit class for simple state management using single state approach
abstract class BaseCubit<T> extends Cubit<BaseBlocState<T>> {
  BaseCubit(super.initialState, this._logger);
  final AppLogger _logger;

  /// Helper method to emit loading state safely
  void emitLoading({String? message}) {
    if (!isClosed) {
      emit(state.toLoading(message: message));
    }
  }

  /// Helper method to emit success state safely
  void emitSuccess(T data, {String? message}) {
    if (!isClosed) {
      emit(state.toSuccess(data, message: message));
    }
  }

  /// Helper method to emit error state safely
  void emitError(Failure failure, {String? context}) {
    if (!isClosed) {
      _logger.error('Cubit error: ${failure.message}', failure);
      emit(state.toError(failure, context: context));
    }
  }

  /// Helper method to emit empty state safely
  void emitEmpty({String? message}) {
    if (!isClosed) {
      emit(state.toEmpty(message: message));
    }
  }

  /// Helper method to handle either result from use cases
  Future<void> handleEitherResult<R>(
    Future<Either<Failure, R>> either, {
    void Function(R data)? onSuccess,
    String? context,
    bool showLoading = true,
  }) async {
    if (showLoading) {
      emitLoading();
    }

    final result = await either;

    if (!isClosed) {
      result.fold(
        (failure) => emitError(failure, context: context),
        (data) {
          if (onSuccess != null) {
            onSuccess(data);
          } else {
            // Default behavior: emit success with data if T matches R
            if (data is T) {
              emitSuccess(data);
            } else {
              emitEmpty();
            }
          }
        },
      );
    }
  }

  /// Safe emit method that checks if cubit is not closed
  void safeEmit(BaseBlocState<T> newState) {
    if (!isClosed) {
      emit(newState);
    }
  }

  @override
  void onChange(Change<BaseBlocState<T>> change) {
    super.onChange(change);
    _logger.debug(
      '$runtimeType state changed: ${change.currentState.status} -> ${change.nextState.status}',
    );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    _logger.error('Cubit error in $runtimeType', error, stackTrace);
  }
}
