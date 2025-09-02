import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// Domain Entity for User - pure business logic without external dependencies
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required bool isVerified,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? phoneNumber,
    String? avatarUrl,
    @Default([]) List<String> roles,
    @Default({}) Map<String, dynamic> permissions,
  }) = _UserEntity;
}
