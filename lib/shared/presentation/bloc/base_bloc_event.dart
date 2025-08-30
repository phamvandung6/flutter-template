import 'package:equatable/equatable.dart';

/// Base event class for all BLoC events
abstract class BaseBlocEvent extends Equatable {
  const BaseBlocEvent();

  @override
  List<Object?> get props => [];
}

/// Refresh event to reload data
class RefreshEvent extends BaseBlocEvent {

  const RefreshEvent({this.forceRefresh = false});
  final bool forceRefresh;

  @override
  List<Object?> get props => [forceRefresh];
}

/// Reset event to clear state
class ResetEvent extends BaseBlocEvent {
  const ResetEvent();
}

/// Load more event for pagination
class LoadMoreEvent extends BaseBlocEvent {

  const LoadMoreEvent({
    required this.page,
    this.limit = 20,
  });
  final int page;
  final int limit;

  @override
  List<Object?> get props => [page, limit];
}

/// Retry event for error recovery
class RetryEvent extends BaseBlocEvent {

  const RetryEvent({this.context});
  final String? context;

  @override
  List<Object?> get props => [context];
}
