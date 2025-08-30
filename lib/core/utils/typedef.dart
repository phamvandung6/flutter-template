import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/failures.dart';

/// Type definitions for common return types
typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = Future<Either<Failure, void>>;
typedef DataMap = Map<String, dynamic>;
