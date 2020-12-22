import 'package:flutter/material.dart';
import 'package:volume_watcher/volume_watcher.dart';

class VolumeProvider extends ChangeNotifier {
  double _volume = 0;
  double maxVolume = 100;
  static const double STEP = 5;
  Future initialize;
  VolumeProvider() {
    try {
      initialize = VolumeWatcher.getMaxVolume.then((value) async {
        maxVolume = value;
        await VolumeWatcher.getCurrentVolume.then((value) {
          volume = value;
        });
      });
    } catch (ex) {
      print(ex);
      print("Failed to get Max Volume");
    }
    VolumeWatcher(
      onVolumeChangeListener: (value) async {
        _volume = value;
        notifyListeners();
      },
    );
  }

  double get volume => _volume;
  set volume(double value) {
    _volume = value;
    notifyListeners();
  }
}
