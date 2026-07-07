import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_template/core/error/failures.dart';

part 'base_view_state.freezed.dart';

/// Enum for representing common async view states.
enum ViewStatus {
  initial,
  loading,
  success,
  error,
  empty,
}

/// Base state class for simple async Cubit/BLoC view state.
@freezed
abstract class BaseViewState<T> with _$BaseViewState<T> {
  const factory BaseViewState({
    @Default(ViewStatus.initial) ViewStatus status,
    T? data,
    Failure? failure,
    String? message,
    String? context,
  }) = _BaseViewState<T>;
}
