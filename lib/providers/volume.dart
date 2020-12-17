import 'package:flutter/material.dart';
import 'package:volume_watcher/volume_watcher.dart';

class VolumeProvider extends ChangeNotifier {
  double _volume = 0;
  double maxVolume = 100;
  static const double STEP = 5;

  VolumeProvider() {
    VolumeWatcher(
      onVolumeChangeListener: (value) async {
        try {
          maxVolume = await VolumeWatcher.getMaxVolume;
        } catch (ex) {
          print(ex);
          print("Failed to get Max Volume");
        }
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
