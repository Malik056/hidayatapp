import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidayat/models/playlist.dart';

class PlaylistAPIs {
  static Stream<List<Playlist>> getPlaylists(String categoryId) {
    // ignore: close_sinks
    StreamController<List<Playlist>> playlistsStreamController =
        StreamController<List<Playlist>>();
    var ref = FirebaseFirestore.instance
        .collection("playlists")
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('name');
    ref.snapshots().listen((event) {
      playlistsStreamController.add(
        event.docs.map((e) => Playlist.fromJson(e.data())).toList(),
      );
    });
    return playlistsStreamController.stream;
  }
}
