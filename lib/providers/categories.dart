import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/database/database.dart';
import 'package:hidayat/models/category.dart';

class CategoriesProvider extends ChangeNotifier {
  StreamSubscription _querySnapshotStreamSubscription;
  StreamController<List<Category>> _categoriesStreamController;
  List<Category> state = [];
  ConnectionState connectionState = ConnectionState.waiting;
  String error;

  CategoriesProvider() {
    _categoriesStreamController = StreamController.broadcast();
    MySQLiteDatabase mySQLiteDatabase = MySQLiteDatabase.getInstance();
    mySQLiteDatabase.categoryDbHelper.getCategories().then((value) {
      // if (value == null || value.isEmpty) {
      //   return;
      // }
      state = value;
      _categoriesStreamController.add(state);
      connectionState = ConnectionState.active;
      notifyListeners();

      _querySnapshotStreamSubscription = FirebaseFirestore.instance
          .collection("categories")
          .snapshots()
          .listen((event) async {
        error = null;
        // await mySQLiteDatabase.categoryDbHelper.clearCategories(categoryId);
        if (connectionState != ConnectionState.active) {
          connectionState = ConnectionState.active;
        }
        // state = event.docs.map((e) => Category.fromSnapshot(e)).toList();
        List<Category> tempState = [];

        event.docChanges.forEach((element) {
          Category category = Category.fromSnapshot(element.doc);
          if (element.type == DocumentChangeType.added) {
            Category categoryLocal =
                state.firstWhere((_) => category.id == _.id, orElse: () {
              return null;
            });
            if (categoryLocal == null) {
              mySQLiteDatabase.categoryDbHelper.addCategory(category);
            } else if (!categoryLocal.equals(category)) {
              mySQLiteDatabase.categoryDbHelper.updateCategory(category);
            }
            tempState.add(category);
          } else if (element.type == DocumentChangeType.modified) {
            mySQLiteDatabase.categoryDbHelper.updateCategory(category);
            tempState.add(category);
          } else if (element.type == DocumentChangeType.removed) {
            mySQLiteDatabase.categoryDbHelper.deleteCategory(category.id);
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
        _categoriesStreamController.add(state);
        notifyListeners();
      }, onError: (err) {
        if (state?.isEmpty ?? true) {
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
    _querySnapshotStreamSubscription.cancel();
    _categoriesStreamController.close();
    super.dispose();
  }
}
