import 'package:flutter_template/core/utils/typedef.dart';

/// Base class for all use cases
abstract class UseCase<Type, Params> {
  const UseCase();
  
  ResultFuture<Type> call(Params params);
}

/// Use case with no parameters
abstract class UseCaseWithoutParams<Type> {
  const UseCaseWithoutParams();
  
  ResultFuture<Type> call();
}

/// Use case with stream return type
abstract class StreamUseCase<Type, Params> {
  const StreamUseCase();
  
  Stream<Type> call(Params params);
}

/// Parameters class for use cases that don't need parameters
class NoParams {
  const NoParams();
}
