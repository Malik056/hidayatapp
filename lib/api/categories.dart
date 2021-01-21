import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidayat/models/category.dart';

class CategoryAPIs {
  static Stream<List<Category>> getCategories() {
    // ignore: close_sinks
    StreamController<List<Category>> categoriesStreamController =
        StreamController<List<Category>>.broadcast();
    var ref =
        FirebaseFirestore.instance.collection("categories").orderBy('name');
    var streamSubscription = ref.snapshots().listen((event) {
      categoriesStreamController.add(
        event.docs.map((e) => Category.fromSnapshot(e)).toList(),
      );
    });
    streamSubscription.cancel();
    return categoriesStreamController.stream;
  }
}
