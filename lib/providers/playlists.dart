import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/database/database.dart';
import 'package:hidayat/models/playlist.dart';

class PlaylistsProvider extends ChangeNotifier {
  late StreamSubscription? _querySnapshotStreamSubscription;
  late StreamController<List<Playlist>>? _playlistsStreamController;
  List<Playlist> state = [];
  String categoryId;
  ConnectionState connectionState = ConnectionState.waiting;
  String? error;

  PlaylistsProvider(this.categoryId) {
    _playlistsStreamController = StreamController();
    MySQLiteDatabase mySQLiteDatabase = MySQLiteDatabase.getInstance();
    mySQLiteDatabase.playlistDbHelper.getPlaylists(categoryId).then((value) {
      state = value;
      if (state.isNotEmpty) {
        state.sort();
        _playlistsStreamController!.add(state);
        connectionState = ConnectionState.active;
        notifyListeners();
      }

      _querySnapshotStreamSubscription = FirebaseFirestore.instance
          .collection("playlists")
          .where("categoryId", isEqualTo: categoryId)
          .orderBy('name')
          .snapshots()
          .listen((event) async {
        error = null;
        connectionState = ConnectionState.active;
        event.docChanges.forEach((element) {
          Playlist playlist = Playlist.fromSnapshot(element.doc);
          if (element.type == DocumentChangeType.added) {
            Playlist? playlistLocal;
            try {
              playlistLocal = state.firstWhere(
                (_) => playlist.id == _.id,
              );
            } catch (ex) {
              print(ex);
            }
            if (playlistLocal == null) {
              mySQLiteDatabase.playlistDbHelper.addPlaylist(playlist);
              state.add(playlist);
            } else if (!playlistLocal.equals(playlist)) {
              mySQLiteDatabase.playlistDbHelper.updatePlaylist(playlist);
              state.removeWhere((e) => e.id == playlist.id);
              state.add(playlist);
            }
          } else if (element.type == DocumentChangeType.modified) {
            mySQLiteDatabase.playlistDbHelper.updatePlaylist(playlist);
            state.removeWhere((e) => e.id == playlist.id);
            state.add(playlist);
          } else if (element.type == DocumentChangeType.removed) {
            mySQLiteDatabase.playlistDbHelper.deletePlaylist(playlist.id);
            state.removeWhere((e) => e.id == playlist.id);
          }
        });

        // if (state == null) state = [];
        state.sort();
        _playlistsStreamController!.add(state);
        notifyListeners();
      }, onError: (err) {
        if (state.isEmpty) {
          error = err.toString();
          notifyListeners();
        }
      });
      _playlistsStreamController!.onCancel = () {
        _playlistsStreamController!.close();
      };
    });
  }

  Stream<List<Playlist>> getPlaylists() {
    return _playlistsStreamController!.stream;
  }

  @override
  void dispose() {
    _querySnapshotStreamSubscription?.cancel();
    _playlistsStreamController?.close();
    super.dispose();
  }
}
