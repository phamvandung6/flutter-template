import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/utils/typedef.dart';
import 'package:flutter_template/core/utils/usecase.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user registration
@injectable
class RegisterUser extends UseCase<UserEntity, RegisterUserParams> {

  RegisterUser(this._repository);
  final AuthRepository _repository;

  @override
  ResultFuture<UserEntity> call(RegisterUserParams params) async {
    return _repository.register(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      phoneNumber: params.phoneNumber,
      termsAccepted: params.termsAccepted,
    );
  }
}

/// Parameters for register use case
class RegisterUserParams extends Equatable {

  const RegisterUserParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.phoneNumber,
    required this.termsAccepted,
  });
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? phoneNumber;
  final bool termsAccepted;

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        password,
        passwordConfirmation,
        phoneNumber,
        termsAccepted,
      ];
}
