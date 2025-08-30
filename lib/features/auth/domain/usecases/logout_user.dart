import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/utils/typedef.dart';
import 'package:flutter_template/core/utils/usecase.dart';
import 'package:flutter_template/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user logout
@injectable
class LogoutUser extends UseCase<void, NoParams> {

  LogoutUser(this._repository);
  final AuthRepository _repository;

  @override
  ResultVoid call(NoParams params) async {
    return _repository.logout();
  }
}
