import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/database/database.dart';
import 'package:hidayat/models/bayan.dart';

class BayansProvider extends ChangeNotifier {
  StreamSubscription? _querySnapshotStreamSubscription;
  StreamController<List<Bayan>>? _bayansStreamController;
  List<Bayan> state = [];
  String playlistId;
  ConnectionState connectionState = ConnectionState.waiting;
  String? error;

  BayansProvider(this.playlistId) {
    _bayansStreamController = StreamController();
    MySQLiteDatabase mySQLiteDatabase = MySQLiteDatabase.getInstance();
    mySQLiteDatabase.bayanDbHelper.getBayans(playlistId).then((value) {
      state = value;
      if (state.isNotEmpty) {
        _bayansStreamController!.add(state);
        connectionState = ConnectionState.active;
        notifyListeners();
      }

      _querySnapshotStreamSubscription = FirebaseFirestore.instance
          .collection("bayans")
          .where("playlistId", isEqualTo: playlistId)
          .orderBy('name')
          .snapshots()
          .listen((event) async {
        error = null;
        // await mySQLiteDatabase.bayanDbHelper.clearBayans(bayanId);
        // state = event.docs.map((e) => Bayan.fromSnapshot(e)).toList();
        // List<Bayan> tempState = [];
        connectionState = ConnectionState.active;
        event.docChanges.forEach((element) {
          Bayan bayan = Bayan.fromSnapshot(element.doc);
          if (element.type == DocumentChangeType.added) {
            Bayan? bayanLocal;
            try {
              bayanLocal = state.firstWhere((_) => bayan.id == _.id);
            } catch (ex) {
              print(ex);
            }
            if (bayanLocal == null) {
              mySQLiteDatabase.bayanDbHelper.addBayan(bayan);
              state.add(bayan);
            } else if (!bayanLocal.equals(bayan)) {
              mySQLiteDatabase.bayanDbHelper.updateBayan(bayan);
              state.removeWhere((_) => _.id == bayan.id);
              state.add(bayan);
            }
          } else if (element.type == DocumentChangeType.modified) {
            mySQLiteDatabase.bayanDbHelper.updateBayan(bayan);
            state.removeWhere((e) => e.id == bayan.id);
            state.add(bayan);
          } else if (element.type == DocumentChangeType.removed) {
            mySQLiteDatabase.bayanDbHelper.deleteBayan(element.doc.id);
            state.removeWhere((_) => _.id == bayan.id);
          }
        });
        _bayansStreamController!.add(state);
        notifyListeners();
      }, onError: (_) {
        if (connectionState == ConnectionState.waiting) {
          error = _.toString();
        }
      });
      _bayansStreamController!.onCancel = () {
        _bayansStreamController!.close();
      };
    });
  }

  Stream<List<Bayan>> getBayans() {
    return _bayansStreamController!.stream;
  }

  @override
  void dispose() {
    _querySnapshotStreamSubscription?.cancel();
    _bayansStreamController?.close();
    super.dispose();
  }
}
