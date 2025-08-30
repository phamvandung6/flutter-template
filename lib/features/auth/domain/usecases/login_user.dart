import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/typedef.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
@injectable
class LoginUser extends UseCase<UserEntity, LoginUserParams> {
  final AuthRepository _repository;

  LoginUser(this._repository);

  @override
  ResultFuture<UserEntity> call(LoginUserParams params) async {
    return _repository.login(
      email: params.email,
      password: params.password,
      rememberMe: params.rememberMe,
      deviceId: params.deviceId,
    );
  }
}

/// Parameters for login use case
class LoginUserParams extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;
  final String? deviceId;

  const LoginUserParams({
    required this.email,
    required this.password,
    this.rememberMe = false,
    this.deviceId,
  });

  @override
  List<Object?> get props => [email, password, rememberMe, deviceId];
}
