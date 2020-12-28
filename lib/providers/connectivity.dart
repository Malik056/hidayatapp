import 'package:connectivity/connectivity.dart';
import 'package:easyping/easyping.dart';
import 'package:flutter/material.dart';

class InternetConnectionState {
  final ConnectivityResult type;
  final bool connected;

  InternetConnectionState(this.type, this.connected);
}

class ConnectivityProvider extends ChangeNotifier {
  InternetConnectionState state;
  Connectivity _connectivity;
  Future<void> initialize;
  ConnectivityProvider() {
    _connectivity = Connectivity();
    initialize = _initialize();
  }

  Future<bool> _isOnline() async {
    return await ping('8.8.8.8').then((value) {
      return true;
    }).timeout(
      Duration(seconds: 3),
      onTimeout: () {
        return false;
      },
    );
  }

  Future<void> _initialize() async {
    await _connectivity.checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        state = InternetConnectionState(value, await _isOnline());
      } else {
        state = InternetConnectionState(value, false);
      }
      notifyListeners();
    });
  }
}
