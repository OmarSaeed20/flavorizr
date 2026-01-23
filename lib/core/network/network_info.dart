// lib/core/network/network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart';

/// Utility class for checking network connectivity.
abstract class NetworkInfo {
  /// Returns true if the device has an active internet connection.
  Future<bool> get isConnected;

  /// Stream of connectivity changes.
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of [NetworkInfo] using connectivity_plus.
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity();
  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.isNotEmpty &&
        results.any(
          (result) =>
              result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi ||
              result == ConnectivityResult.ethernet,
        );
  }
}
