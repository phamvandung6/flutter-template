import 'package:equatable/equatable.dart';

/// Base event class for all BLoC events
abstract class BaseBlocEvent extends Equatable {
  const BaseBlocEvent();

  @override
  List<Object?> get props => [];
}

/// Refresh event to reload data
class RefreshEvent extends BaseBlocEvent {
  final bool forceRefresh;

  const RefreshEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

/// Reset event to clear state
class ResetEvent extends BaseBlocEvent {
  const ResetEvent();
}

/// Load more event for pagination
class LoadMoreEvent extends BaseBlocEvent {
  final int page;
  final int limit;

  const LoadMoreEvent({
    required this.page,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [page, limit];
}

/// Retry event for error recovery
class RetryEvent extends BaseBlocEvent {
  final String? context;

  const RetryEvent({this.context});

  @override
  List<Object?> get props => [context];
}
