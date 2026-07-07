import 'package:equatable/equatable.dart';

/// Base event class for all BLoC events
abstract class BaseBlocEvent extends Equatable {
  const BaseBlocEvent();

  @override
  List<Object?> get props => [];
}
