import 'package:flutter_template/core/utils/typedef.dart';

/// Base class for all use cases
// ignore: one_member_abstracts
abstract class UseCase<Type, Params> {
  const UseCase();

  ResultFuture<Type> call(Params params);
}

/// Use case with no parameters
// ignore: one_member_abstracts
abstract class UseCaseWithoutParams<Type> {
  const UseCaseWithoutParams();

  ResultFuture<Type> call();
}

/// Use case with stream return type
// ignore: one_member_abstracts
abstract class StreamUseCase<Type, Params> {
  const StreamUseCase();

  Stream<Type> call(Params params);
}

/// Parameters class for use cases that don't need parameters
class NoParams {
  const NoParams();
}
