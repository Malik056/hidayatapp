import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidayat/models/bayan.dart';

class BayanAPIs {
  static Stream<List<Bayan>> getBayans(String playlist) {
    // ignore: close_sinks
    StreamController<List<Bayan>> bayansStreamController =
        StreamController<List<Bayan>>();
    var ref = FirebaseFirestore.instance
        .collection("bayans")
        .where('playlistId', isEqualTo: playlist)
        .orderBy('name');
    ref.snapshots().listen((event) {
      bayansStreamController.add(
        event.docs.map((e) => Bayan.fromSnapshot(e)).toList(),
      );
    });
    return bayansStreamController.stream;
  }
}
