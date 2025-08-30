import 'user_entity.dart';

/// Extension methods for UserEntity business logic
extension UserEntityX on UserEntity {
  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Get display name (full name or email if name is empty)
  String get displayName {
    final name = fullName.trim();
    return name.isNotEmpty ? name : email;
  }

  /// Check if user has specific role
  bool hasRole(String role) => roles.contains(role);

  /// Check if user has any of the specified roles
  bool hasAnyRole(List<String> roleList) =>
      roleList.any((role) => hasRole(role));

  /// Check if user has all of the specified roles
  bool hasAllRoles(List<String> roleList) =>
      roleList.every((role) => hasRole(role));

  /// Check if user has specific permission
  bool hasPermission(String permission) => permissions.containsKey(permission);

  /// Get permission value
  T? getPermission<T>(String permission) => permissions[permission] as T?;

  /// Check if user is admin
  bool get isAdmin => hasRole('admin') || hasRole('super_admin');

  /// Check if user can perform action based on permissions
  bool canPerform(String action) =>
      hasPermission(action) && getPermission<bool>(action) == true;
}
