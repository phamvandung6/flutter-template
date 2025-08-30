import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';

@module
abstract class InjectableModules {
  // Network Module
  @lazySingleton
  Dio get dio => Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout:
              Duration(milliseconds: AppConfig.config.connectTimeout),
          receiveTimeout:
              Duration(milliseconds: AppConfig.config.receiveTimeout),
          sendTimeout: Duration(milliseconds: AppConfig.config.sendTimeout),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  // Connectivity Module
  @lazySingleton
  Connectivity get connectivity => Connectivity();

  // Storage Module
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
}
