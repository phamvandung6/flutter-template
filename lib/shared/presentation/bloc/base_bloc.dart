import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/shared/presentation/bloc/base_bloc_event.dart';
import 'package:flutter_template/shared/presentation/bloc/base_bloc_state.dart';
import 'package:flutter_template/shared/presentation/bloc/base_bloc_state_extensions.dart';

/// Base BLoC class with common functionality using single state approach
abstract class BaseBloc<Event extends BaseBlocEvent, T>
    extends Bloc<Event, BaseBlocState<T>> {
  BaseBloc(super.initialState, this._logger);
  final AppLogger _logger;

  /// Override this method to handle refresh events
  Future<void> onRefresh(
    RefreshEvent event,
    Emitter<BaseBlocState<T>> emit,
  ) async {
    // Default implementation - override in subclasses
    _logger.debug('Default refresh implementation - override in subclass');
  }

  /// Override this method to handle reset events
  Future<void> onReset(ResetEvent event, Emitter<BaseBlocState<T>> emit) async {
    // Default implementation - override in subclasses
    _logger.debug('Default reset implementation - override in subclass');
  }

  /// Override this method to handle retry events
  Future<void> onRetry(RetryEvent event, Emitter<BaseBlocState<T>> emit) async {
    // Default implementation - override in subclasses
    _logger.debug('Default retry implementation - override in subclass');
  }

  /// Helper method to emit loading state
  void emitLoading(Emitter<BaseBlocState<T>> emit, {String? message}) {
    emit(state.toLoading(message: message));
  }

  /// Helper method to emit success state
  void emitSuccess(Emitter<BaseBlocState<T>> emit, T data, {String? message}) {
    emit(state.toSuccess(data, message: message));
  }

  /// Helper method to emit error state
  void emitError(
    Emitter<BaseBlocState<T>> emit,
    Failure failure, {
    String? context,
  }) {
    _logger.error('BLoC error: ${failure.message}', failure);
    emit(state.toError(failure, context: context));
  }

  /// Helper method to emit empty state
  void emitEmpty(Emitter<BaseBlocState<T>> emit, {String? message}) {
    emit(state.toEmpty(message: message));
  }

  /// Helper method to handle either result from use cases
  Future<void> handleEitherResult<R>(
    Emitter<BaseBlocState<T>> emit,
    Future<Either<Failure, R>> either, {
    void Function(R data)? onSuccess,
    String? context,
    bool showLoading = true,
  }) async {
    if (showLoading) {
      emitLoading(emit);
    }

    final result = await either;
    result.fold(
      (failure) => emitError(emit, failure, context: context),
      (data) {
        if (onSuccess != null) {
          onSuccess(data);
        } else {
          // Default behavior: emit success with data if T matches R
          if (data is T) {
            emitSuccess(emit, data);
          } else {
            emitEmpty(emit);
          }
        }
      },
    );
  }

  @override
  void onChange(Change<BaseBlocState<T>> change) {
    super.onChange(change);
    _logger.debug(
      '$runtimeType state changed: ${change.currentState.status} -> ${change.nextState.status}',
    );
  }

  @override
  void onTransition(Transition<Event, BaseBlocState<T>> transition) {
    super.onTransition(transition);
    _logger.debug(
      '$runtimeType transition: ${transition.event.runtimeType} -> ${transition.nextState.status}',
    );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    _logger.error('BLoC error in $runtimeType', error, stackTrace);
  }
}
