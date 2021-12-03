import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';

class InternetConnectionState {
  final ConnectivityResult type;
  final bool connected;

  InternetConnectionState(this.type, this.connected) {
    print(connected);
  }
}

class ConnectivityProvider extends ChangeNotifier {
  InternetConnectionState? state;
  late Connectivity _connectivity;
  late Future<void> initialize;
  ConnectivityProvider() {
    _connectivity = Connectivity();
    initialize = _initialize();
  }

  Future<bool> _isOnline() async {
    Ping ping = Ping('8.8.8.8');
    bool result = await ping.stream.first.then<bool>((value) async {
      if (value.error != null) {
        return false;
      }
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
