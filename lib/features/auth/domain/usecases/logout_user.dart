import 'package:injectable/injectable.dart';

import '../../../../core/utils/typedef.dart';
import '../../../../core/utils/usecase.dart';
import '../repositories/auth_repository.dart';

/// Use case for user logout
@injectable
class LogoutUser extends UseCase<void, NoParams> {
  final AuthRepository _repository;

  LogoutUser(this._repository);

  @override
  ResultVoid call(NoParams params) async {
    return _repository.logout();
  }
}
