import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import '../utils/logger.dart';

/// Abstract class for network connectivity information
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
  Future<ConnectivityResult> get connectivityResult;
}

/// Implementation of NetworkInfo using connectivity_plus package
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final AppLogger _logger;

  NetworkInfoImpl(this._connectivity, this._logger);

  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      final connected = _isConnectedResult(result.first);
      _logger.debug('Network connectivity check: ${connected ? 'Connected' : 'Disconnected'} ($result)');
      return connected;
    } catch (e) {
      _logger.error('Error checking network connectivity', e);
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      final connected = _isConnectedResult(results.first);
      _logger.info('Network connectivity changed: ${connected ? 'Connected' : 'Disconnected'} ($results)');
      return connected;
    });
  }

  @override
  Future<ConnectivityResult> get connectivityResult async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.first;
    } catch (e) {
      _logger.error('Error getting connectivity result', e);
      return ConnectivityResult.none;
    }
  }

  bool _isConnectedResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        return true;
      case ConnectivityResult.none:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        return false;
    }
  }

  /// Check if device has strong connection (WiFi or mobile with good signal)
  Future<bool> hasStrongConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final result = results.first;
      
      switch (result) {
        case ConnectivityResult.wifi:
          // WiFi is generally considered a strong connection
          return true;
        case ConnectivityResult.mobile:
          // Mobile is considered strong (specific signal strength would require platform-specific code)
          return true;
        case ConnectivityResult.ethernet:
          // Ethernet is the strongest connection
          return true;
        default:
          return false;
      }
    } catch (e) {
      _logger.error('Error checking connection strength', e);
      return false;
    }
  }

  /// Get connection type as string for debugging/logging
  Future<String> getConnectionType() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.first.name;
    } catch (e) {
      _logger.error('Error getting connection type', e);
      return 'unknown';
    }
  }
}
