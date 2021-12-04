import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/database/database.dart';
import 'package:hidayat/models/category.dart';

class CategoriesProvider extends ChangeNotifier {
  StreamSubscription? _querySnapshotStreamSubscription;
  late StreamController<List<Category>> _categoriesStreamController;
  List<Category> state = [];
  ConnectionState connectionState = ConnectionState.waiting;
  String? error;

  CategoriesProvider() {
    _categoriesStreamController = StreamController.broadcast();
    MySQLiteDatabase mySQLiteDatabase = MySQLiteDatabase.getInstance();
    mySQLiteDatabase.categoryDbHelper.getCategories().then((value) {
      // if (value == null || value.isEmpty) {
      //   return;
      // }
      state = value;
      notifyListeners();
      if (state.isNotEmpty) {
        state.sort();
        _categoriesStreamController.add(state);
        connectionState = ConnectionState.active;
        notifyListeners();
      }

      _querySnapshotStreamSubscription = FirebaseFirestore.instance
          .collection("categories")
          .orderBy('name')
          .snapshots()
          .listen((event) async {
        error = null;
        // await mySQLiteDatabase.categoryDbHelper.clearCategories(categoryId);
        connectionState = ConnectionState.active;
        print("COnnectionState: connectionState");
        print("QuerySnpshot: $event");
        print("MetaData: ${event.metadata}");
        print("Doc Changes in category ${event.docChanges.join(',')}");
        print("Doc Changes length Categories ${event.docChanges.length}");
        // state = event.docs.map((e) => Category.fromSnapshot(e)).toList();
        var docs;
        docs = event.docChanges;
        if (docs == null || docs.isEmpty) {
          docs = event.docs;
        }
        docs.forEach((element) {
          Category category = Category.fromSnapshot(element.doc);
          if (element.type == DocumentChangeType.added) {
            Category? categoryLocal;
            try {
              categoryLocal = state.firstWhere((_) => category.id == _.id);
            } catch (ex) {
              print(ex);
            }
            if (categoryLocal == null) {
              mySQLiteDatabase.categoryDbHelper.addCategory(category);
              state.add(category);
            } else if (!categoryLocal.equals(category)) {
              mySQLiteDatabase.categoryDbHelper.updateCategory(category);
              state.removeWhere((_) => _.id == category.id);
              state.add(category);
            }
          } else if (element.type == DocumentChangeType.modified) {
            mySQLiteDatabase.categoryDbHelper.updateCategory(category);
            state.removeWhere((_) => _.id == category.id);
            state.add(category);
          } else if (element.type == DocumentChangeType.removed) {
            mySQLiteDatabase.categoryDbHelper.deleteCategory(category.id);
            state.removeWhere((_) => _.id == category.id);
          }
        });

        state.sort();
        _categoriesStreamController.add(state);
        error = null;
        notifyListeners();
      }, onError: (err) {
        print("Error Occurred");
        print("Error: $err");
        if (state.isEmpty) {
          error = err.toString();
          notifyListeners();
        }
      });
      _categoriesStreamController.onCancel = () {
        _categoriesStreamController.close();
      };
    });
  }

  Stream<List<Category>> getCategories() {
    return _categoriesStreamController.stream;
  }

  @override
  void dispose() {
    _querySnapshotStreamSubscription?.cancel();
    _categoriesStreamController.close();
    super.dispose();
  }
}
