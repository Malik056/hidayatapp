import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/database/database.dart';
import 'package:hidayat/models/playlist.dart';

class PlaylistsProvider extends ChangeNotifier {
  StreamSubscription _querySnapshotStreamSubscription;
  StreamController<List<Playlist>> _playlistsStreamController;
  List<Playlist> state = [];
  String categoryId;
  ConnectionState connectionState = ConnectionState.waiting;
  String error;

  PlaylistsProvider(this.categoryId) {
    _playlistsStreamController = StreamController();
    MySQLiteDatabase mySQLiteDatabase = MySQLiteDatabase.getInstance();
    mySQLiteDatabase.playlistDbHelper.getPlaylists(categoryId).then((value) {
      state = value;
      _playlistsStreamController.add(state);
      connectionState = ConnectionState.active;
      notifyListeners();

      _querySnapshotStreamSubscription = FirebaseFirestore.instance
          .collection("playlists")
          .where("categoryId", isEqualTo: categoryId)
          .snapshots()
          .listen((event) async {
        error = null;
        // await mySQLiteDatabase.playlistDbHelper.clearPlaylists(categoryId);
        if (connectionState != ConnectionState.active) {
          connectionState = ConnectionState.active;
        }
        // state = event.docs.map((e) => Playlist.fromSnapshot(e)).toList();
        List<Playlist> tempState = [];

        event.docChanges.forEach((element) {
          Playlist playlist = Playlist.fromSnapshot(element.doc);
          if (element.type == DocumentChangeType.added) {
            Playlist playlistLocal =
                state.firstWhere((_) => playlist.id == _.id, orElse: () {
              return null;
            });
            if (playlistLocal == null) {
              mySQLiteDatabase.playlistDbHelper.addPlaylist(playlist);
            } else if (!playlistLocal.equals(playlist)) {
              mySQLiteDatabase.playlistDbHelper.updatePlaylist(playlist);
            }
            tempState.add(playlist);
          } else if (element.type == DocumentChangeType.modified) {
            mySQLiteDatabase.playlistDbHelper.updatePlaylist(playlist);
            tempState.add(playlist);
          } else if (element.type == DocumentChangeType.removed) {
            mySQLiteDatabase.playlistDbHelper.deletePlaylist(playlist.id);
          }
        });

        if (state == null ||
            state.isEmpty ||
            state.length != tempState.length) {
          state = tempState;
        } else {
          for (int i = 0; i < state.length; i++) {
            if (!state[i].equals(tempState[i])) {
              state = tempState;
              break;
            }
          }
        }
        _playlistsStreamController.add(state);
        notifyListeners();
      }, onError: (err) {
        if (state == null || state.isEmpty) {
          error = err.toString();
          notifyListeners();
        }
      });
      _playlistsStreamController.onCancel = () {
        _playlistsStreamController.close();
      };
    });
  }

  Stream<List<Playlist>> getPlaylists() {
    return _playlistsStreamController.stream;
  }

  @override
  void dispose() {
    _querySnapshotStreamSubscription.cancel();
    _playlistsStreamController.close();
    super.dispose();
  }
}
