import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:flutter_template/features/auth/data/models/login_request_dto.dart';
import 'package:flutter_template/features/auth/data/models/login_response_dto.dart';
import 'package:flutter_template/features/auth/data/models/register_request_dto.dart';
import 'package:flutter_template/features/auth/data/models/user_dto.dart';

part 'auth_remote_datasource.g.dart';

/// Remote data source interface for authentication
abstract class AuthRemoteDataSource {
  Future<LoginResponseDto> login(LoginRequestDto request);
  Future<UserDto> register(RegisterRequestDto request);
  Future<LoginResponseDto> refreshToken(String refreshToken);
  Future<void> logout();
  Future<UserDto> getCurrentUser();
  Future<UserDto> updateProfile(Map<String, dynamic> profileData);
  Future<void> changePassword(Map<String, dynamic> passwordData);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
}

/// Retrofit API client for authentication endpoints
@RestApi(baseUrl: '/api/v1/auth')
@injectable
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST('/login')
  Future<LoginResponseDto> login(@Body() LoginRequestDto request);

  @POST('/register')
  Future<UserDto> register(@Body() RegisterRequestDto request);

  @POST('/refresh')
  Future<LoginResponseDto> refreshToken(@Body() Map<String, String> body);

  @POST('/logout')
  Future<void> logout();

  @GET('/me')
  Future<UserDto> getCurrentUser();

  @PUT('/profile')
  Future<UserDto> updateProfile(@Body() Map<String, dynamic> profileData);

  @PUT('/password')
  Future<void> changePassword(@Body() Map<String, dynamic> passwordData);

  @POST('/forgot-password')
  Future<void> forgotPassword(@Body() Map<String, String> body);

  @POST('/reset-password')
  Future<void> resetPassword(@Body() Map<String, String> body);
}

/// Implementation of AuthRemoteDataSource using AuthApiClient
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);
  final AuthApiClient _apiClient;

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) {
    return _apiClient.login(request);
  }

  @override
  Future<UserDto> register(RegisterRequestDto request) {
    return _apiClient.register(request);
  }

  @override
  Future<LoginResponseDto> refreshToken(String refreshToken) {
    final body = {'refresh_token': refreshToken};
    return _apiClient.refreshToken(body);
  }

  @override
  Future<void> logout() {
    return _apiClient.logout();
  }

  @override
  Future<UserDto> getCurrentUser() {
    return _apiClient.getCurrentUser();
  }

  @override
  Future<UserDto> updateProfile(Map<String, dynamic> profileData) {
    return _apiClient.updateProfile(profileData);
  }

  @override
  Future<void> changePassword(Map<String, dynamic> passwordData) {
    return _apiClient.changePassword(passwordData);
  }

  @override
  Future<void> forgotPassword(String email) {
    final body = {'email': email};
    return _apiClient.forgotPassword(body);
  }

  @override
  Future<void> resetPassword(String token, String newPassword) {
    final body = {'token': token, 'password': newPassword};
    return _apiClient.resetPassword(body);
  }
}
