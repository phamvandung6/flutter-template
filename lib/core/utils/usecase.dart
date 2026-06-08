import 'package:flutter_template/core/utils/typedef.dart';

/// Base class for all use cases
// ignore: one_member_abstracts
abstract class UseCase<TResult, Params> {
  const UseCase();

  ResultFuture<TResult> call(Params params);
}

/// Use case with no parameters
// ignore: one_member_abstracts
abstract class UseCaseWithoutParams<TResult> {
  const UseCaseWithoutParams();

  ResultFuture<TResult> call();
}

/// Use case with stream return type
// ignore: one_member_abstracts
abstract class StreamUseCase<TResult, Params> {
  const StreamUseCase();

  Stream<TResult> call(Params params);
}

/// Parameters class for use cases that don't need parameters
class NoParams {
  const NoParams();
}
