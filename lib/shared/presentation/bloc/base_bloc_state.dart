import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_template/core/error/failures.dart';

part 'base_bloc_state.freezed.dart';

/// Enum for representing different states in BLoC
enum BlocStatus {
  initial,
  loading,
  success,
  error,
  empty,
}

/// Base state class using single state approach with enum
@freezed
class BaseBlocState<T> with _$BaseBlocState<T> {
  const factory BaseBlocState({
    @Default(BlocStatus.initial) BlocStatus status,
    T? data,
    Failure? failure,
    String? message,
    String? context,
  }) = _BaseBlocState<T>;
}
