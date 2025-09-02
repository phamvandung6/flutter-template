import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_template/features/auth/data/models/user_dto.dart';

part 'login_response_dto.freezed.dart';
part 'login_response_dto.g.dart';

/// Data Transfer Object for login response
@freezed
class LoginResponseDto with _$LoginResponseDto {
  const factory LoginResponseDto({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_in') required int expiresIn,
    required UserDto user,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);
}
