import 'package:injectable/injectable.dart';

import '../../../../core/utils/typedef.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting current authenticated user
@injectable
class GetCurrentUser extends UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;

  GetCurrentUser(this._repository);

  @override
  ResultFuture<UserEntity> call(NoParams params) async {
    return _repository.getCurrentUser();
  }
}
