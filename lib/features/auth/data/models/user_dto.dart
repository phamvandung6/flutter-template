import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// Data Transfer Object for User - maps to/from API responses
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_verified') required bool isVerified,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @Default([]) List<String> roles,
    @Default({}) Map<String, dynamic> permissions,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

/// Extension methods for UserDto mapping
extension UserDtoX on UserDto {
  /// Convert DTO to Domain Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
      isVerified: isVerified,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      roles: roles,
      permissions: permissions,
    );
  }
}

/// Extension methods for UserEntity mapping
extension UserEntityToDto on UserEntity {
  /// Create DTO from Domain Entity
  UserDto toDto() {
    return UserDto(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
      isVerified: isVerified,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      roles: roles,
      permissions: permissions,
    );
  }
}
