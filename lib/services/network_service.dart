import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }
}