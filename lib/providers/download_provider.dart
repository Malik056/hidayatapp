import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hidayat/models/bayan.dart';
import 'package:hidayat/models/download_queue.dart';
import 'package:hidayat/models/download_state.dart';
import 'package:hidayat/models/playlist.dart';
import 'package:path_provider/path_provider.dart';

class DownloadProvider extends ChangeNotifier {
  final DownloadQueue _taskQueue = DownloadQueue();
  bool pauseDownloadButton = false;

  ///returns `-1` if the playlist in not present.
  ///
  ///returns total number of tasks corresponds to [playlistId]
  int totalTasks(String playlistId) {
    return _taskQueue.totalTasksByPlaylist(playlistId);
  }

  double avgProgress(String playlistId) {
    double avg = 0;
    List<DownloadTaskState> downloadStates =
        _taskQueue.getDownloadStateOfPlaylist(playlistId);
    if (downloadStates?.isEmpty ?? true) {
      return -1;
    }
    downloadStates.forEach((element) {
      avg += element.progress;
    });

    return avg / downloadStates.length;
  }

  void downloadPlaylist(Playlist playlist) async {
    pauseDownloadButton = true;
    notifyListeners();
    List<Bayan> bayans = playlist.bayans;
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    int pathSeparator =
        Platform.pathSeparator.codeUnitAt(Platform.pathSeparator.length - 1);
    if (path.codeUnitAt(path.length - 1) != pathSeparator) {
      path = path + Platform.pathSeparator;
    }
    for (int i = 0; i < bayans.length; i++) {
      try {
        File file = new File(path + bayans[i].getUniqueFileName());
        if (await file.exists()) {
          if (bayans[i].filePath == file.path) {
            continue;
          } else {
            await file.delete();
          }
        }
      } catch (ex) {
        print(ex);
      }
      String taskId = "${DateTime.now().millisecondsSinceEpoch}";
      var downloadState = DownloadTaskState()
        ..bayan = bayans[i]
        ..progress = 0
        ..path = path + bayans[i].getUniqueFileName()
        ..status = DownloadTaskStatus.enqueued
        ..taskId = taskId
        ..totalFiles = bayans.length
        ..playlistId = playlist.id;
      _taskQueue.addTask(downloadState);
      // final taskId = await FlutterDownloader.enqueue(
      //   url: bayans[i].link,
      //   fileName: bayans[i].getUniqueFileName(),
      //   showNotification: false,
      //   requiresStorageNotLow: true,
      //   savedDir: directory.path,
      // );
    }
    pauseDownloadButton = false;
    if (_taskQueue.getDownloadStateOfPlaylist(playlist.id)?.isEmpty ?? true) {
      notifyListeners();
      return;
    }
    _taskQueue.startDownloadQueue(playlist.id, () {
      notifyListeners();
    });
    notifyListeners();
  }

  void removeAlltasksForPlaylist(String playlistId) {
    _taskQueue.removePlaylistTasks(playlistId);
  }
}
