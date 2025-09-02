import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/utils/logger.dart';

/// Global BLoC observer for logging and error tracking
@injectable
class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._logger);
  final AppLogger _logger;

  @override
  void onCreate(BlocBase<Object?> bloc) {
    super.onCreate(bloc);
    _logger.debug('BLoC Created: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<Object?> bloc, Change<Object?> change) {
    super.onChange(bloc, change);
    _logger.debug(
      'BLoC Change: ${bloc.runtimeType}\n'
      'Current: ${change.currentState.runtimeType}\n'
      'Next: ${change.nextState.runtimeType}',
    );
  }

  @override
  void onTransition(
    Bloc<Object?, Object?> bloc,
    Transition<Object?, Object?> transition,
  ) {
    super.onTransition(bloc, transition);
    _logger.debug(
      'BLoC Transition: ${bloc.runtimeType}\n'
      'Event: ${transition.event.runtimeType}\n'
      'Current: ${transition.currentState.runtimeType}\n'
      'Next: ${transition.nextState.runtimeType}',
    );
  }

  @override
  void onEvent(Bloc<Object?, Object?> bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger
        .debug('BLoC Event: ${bloc.runtimeType} received ${event.runtimeType}');
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.error(
      'BLoC Error in ${bloc.runtimeType}: $error',
      error,
      stackTrace,
    );
  }

  @override
  void onClose(BlocBase<Object?> bloc) {
    super.onClose(bloc);
    _logger.debug('BLoC Closed: ${bloc.runtimeType}');
  }
}
