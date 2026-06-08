import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/shared/presentation/bloc/base_view_state.dart';

/// Extensions for BaseViewState to provide convenient getters and methods
extension BaseViewStateX<T> on BaseViewState<T> {
  /// Check if state is initial
  bool get isInitial => status == ViewStatus.initial;

  /// Check if state is loading
  bool get isLoading => status == ViewStatus.loading;

  /// Check if state is success
  bool get isSuccess => status == ViewStatus.success;

  /// Check if state has error
  bool get hasError => status == ViewStatus.error;

  /// Check if state is empty
  bool get isEmpty => status == ViewStatus.empty;

  /// Check if state has data
  bool get hasData => data != null;

  /// Get data safely (null if not success or no data)
  T? get safeData => isSuccess ? data : null;

  /// Get error message with user-friendly fallbacks
  String get errorMessage {
    if (failure == null) return message ?? 'Unknown error occurred';

    switch (failure) {
      case NetworkFailure():
        return 'No internet connection. Please check your network.';
      case ServerFailure():
        return failure!.message.isNotEmpty
            ? failure!.message
            : 'Server error occurred. Please try again.';
      case AuthenticationFailure():
        return 'Authentication failed. Please login again.';
      case ValidationFailure():
        return failure!.message.isNotEmpty
            ? failure!.message
            : 'Invalid input. Please check your data.';
      case CacheFailure():
        return 'Data not available offline.';
      default:
        return failure!.message.isNotEmpty
            ? failure!.message
            : 'An unexpected error occurred.';
    }
  }

  /// Get loading message or default
  String get loadingMessage => message ?? 'Loading...';

  /// Get empty message or default
  String get emptyMessage => message ?? 'No data available';

  /// Check if state should show loading UI
  bool get shouldShowLoading => isLoading;

  /// Check if state should show error UI
  bool get shouldShowError => hasError && failure != null;

  /// Check if state should show empty UI
  bool get shouldShowEmpty => isEmpty || (isSuccess && !hasData);

  /// Check if state should show content UI
  bool get shouldShowContent => isSuccess && hasData;

  /// Create a loading state
  BaseViewState<T> toLoading({String? message}) {
    return copyWith(
      status: ViewStatus.loading,
      message: message,
      failure: null,
    );
  }

  /// Create a success state
  BaseViewState<T> toSuccess(T data, {String? message}) {
    return copyWith(
      status: ViewStatus.success,
      data: data,
      message: message,
      failure: null,
    );
  }

  /// Create an error state
  BaseViewState<T> toError(Failure failure, {String? context}) {
    return copyWith(
      status: ViewStatus.error,
      failure: failure,
      context: context,
      data: null,
    );
  }

  /// Create an empty state
  BaseViewState<T> toEmpty({String? message}) {
    return copyWith(
      status: ViewStatus.empty,
      message: message,
      failure: null,
      data: null,
    );
  }

  /// Create an initial state
  BaseViewState<T> toInitial() {
    return copyWith(
      status: ViewStatus.initial,
      data: null,
      failure: null,
      message: null,
      context: null,
    );
  }
}
