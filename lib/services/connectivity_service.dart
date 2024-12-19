import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  bool _hasConnection = true;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _hasConnection = result != ConnectivityResult.none;
  }

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    _hasConnection = result != ConnectivityResult.none;
    return _hasConnection;
  }

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  bool get hasConnection => _hasConnection;
}
