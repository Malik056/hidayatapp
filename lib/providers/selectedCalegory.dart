import 'package:flutter/material.dart';

class SelectedCategory extends ChangeNotifier {
  int _current = 0;

  set current(int value) {
    _current = value;
    notifyListeners();
  }

  int get current => _current;
}
