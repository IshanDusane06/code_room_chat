import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class ConnectivityService {
  Future<bool> get isOnline;
  Stream<bool> get onlineChanges;
}

class ConnectivityPlusService implements ConnectivityService {
  ConnectivityPlusService(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isOnline async =>
      _hasConnection(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onlineChanges =>
      _connectivity.onConnectivityChanged.map(_hasConnection).distinct();

  bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((result) => result != ConnectivityResult.none);
}
