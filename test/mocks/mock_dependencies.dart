import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template/core/navigation/navigation_service.dart';
import 'package:flutter_template/core/network/network_info.dart';
import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_template/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Mock classes for testing dependencies

// Core mocks
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockDio extends Mock implements Dio {}

class MockConnectivity extends Mock implements Connectivity {}

class MockAppLogger extends Mock implements AppLogger {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockNavigationService extends Mock implements NavigationService {}

// Auth feature mocks
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock setup helper class
class MockSetup {
  static void setupMocks() {
    // Register fallback values for common types
    registerFallbackValue(AndroidOptions.defaultOptions);
    registerFallbackValue(IOSOptions.defaultOptions);
    registerFallbackValue(RequestOptions());
    registerFallbackValue(StackTrace.empty);
    registerFallbackValue(ConnectivityResult.wifi);
  }
}
