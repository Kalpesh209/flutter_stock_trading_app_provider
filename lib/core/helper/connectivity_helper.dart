import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  ConnectivityHelper._(); // private constructor
  static final Connectivity _connectivity = Connectivity();
  static Future<bool> hasNetwork() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  static Future<bool> isConnected() async {
    final hasNet = await hasNetwork();

    if (!hasNet) return false;

    return await hasInternet();
  }

  static Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (results) => results.isNotEmpty ? results.first : ConnectivityResult.none,
    );
  }
}
