import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:easyping/easyping.dart';
import 'package:flutter/material.dart';

class InternetConnectionState {
  final ConnectivityResult type;
  final bool connected;

  InternetConnectionState(this.type, this.connected) {
    print(connected);
  }
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
    bool result = await ping('8.8.8.8').then<bool>((value) async {
      return true;
    }).timeout(
      Duration(seconds: 5),
      onTimeout: () {
        return false;
      },
    );
    return result;
  }

  Future<void> _initialize() async {
    Completer<void> completer = Completer<void>();
    Stream.periodic(Duration(seconds: 2)).listen((event) async {
      await _connectivity.checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          state = InternetConnectionState(value, await _isOnline());
        } else {
          state = InternetConnectionState(value, false);
        }
        notifyListeners();
      });
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
  }
}
