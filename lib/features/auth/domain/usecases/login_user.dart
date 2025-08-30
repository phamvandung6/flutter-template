import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/utils/typedef.dart';
import 'package:flutter_template/core/utils/usecase.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login
@injectable
class LoginUser extends UseCase<UserEntity, LoginUserParams> {

  LoginUser(this._repository);
  final AuthRepository _repository;

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

  const LoginUserParams({
    required this.email,
    required this.password,
    this.rememberMe = false,
    this.deviceId,
  });
  final String email;
  final String password;
  final bool rememberMe;
  final String? deviceId;

  @override
  List<Object?> get props => [email, password, rememberMe, deviceId];
}
