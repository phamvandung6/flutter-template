import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/utils/typedef.dart';
import 'package:flutter_template/core/utils/usecase.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting current authenticated user
@injectable
class GetCurrentUser extends UseCase<UserEntity, NoParams> {

  GetCurrentUser(this._repository);
  final AuthRepository _repository;

  @override
  ResultFuture<UserEntity> call(NoParams params) async {
    return _repository.getCurrentUser();
  }
}
