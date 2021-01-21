import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hidayat/database/database.dart';
import 'package:hidayat/models/bayan.dart';
import 'package:hidayat/models/download_queue.dart';
import 'package:hidayat/models/download_state.dart';
import 'package:hidayat/models/playlist.dart';
import 'package:path_provider/path_provider.dart';

class DownloadProvider extends ChangeNotifier {
  final DownloadQueue _taskQueue = DownloadQueue();
  ReceivePort _port = ReceivePort();

  static void callback(String id, DownloadTaskStatus status, int progress) {
    print("Downlaoding Callback");
    print("id $id");
    print("progress $progress");
    print("status $status");
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  DownloadProvider() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      print("Downlaoding Callback in Provider");
      print("id $id");
      print("progress $progress");
      print("status $status");
      var downloadTaskState = _taskQueue.getDownloadStateByTaskId(id);
      downloadTaskState
        ..progress = progress
        ..status = status;
      if (status == DownloadTaskStatus.complete) {
        Bayan bayan = downloadTaskState.bayan;
        downloadTaskState.bayan.filePath = downloadTaskState.path;

        MySQLiteDatabase.getInstance().bayanDbHelper.updateBayan(bayan);
        _taskQueue.removeTaskById(id);
      }
      notifyListeners();
    });
    FlutterDownloader.registerCallback(callback);
  }

  ///returns `-1` if the playlist in not present.
  ///
  ///returns total number of tasks corresponds to [playlistId]
  int totalTasks(String playlistId) {
    return _taskQueue.totalTasksByPlaylist(playlistId);
  }

  double avgProgress(String playlistId) {
    int avg = 0;
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
    List<Bayan> bayans = playlist.bayans;
    Directory directory = await getApplicationDocumentsDirectory();
    // List<DownloadTaskState> tasks =
    //     _taskQueue.getDownloadStateOfPlaylist(playlist.id);
    // if (tasks == null) {
    //   tasks = [];
    //   _downloadQueue.putIfAbsent(playlist.id, () => tasks);
    // }
    for (int i = 0; i < bayans.length; i++) {
      if (bayans[i].filePath == null || bayans[i].filePath.isEmpty) {
        String path = directory.path;
        int pathSeparator = Platform.pathSeparator
            .codeUnitAt(Platform.pathSeparator.length - 1);
        if (path.codeUnitAt(path.length - 1) != pathSeparator) {
          path = path + Platform.pathSeparator;
        }
        try {
          File file = new File(path + bayans[i].getUniqueFileName());
          if (await file.exists()) {
            await file.delete();
          }
        } catch (ex) {
          print(ex);
        }
        final taskId = await FlutterDownloader.enqueue(
          url: bayans[i].link,
          fileName: bayans[i].getUniqueFileName(),
          showNotification: false,
          requiresStorageNotLow: true,
          savedDir: directory.path,
        );
        var downloadState = DownloadTaskState()
          ..bayan = bayans[i]
          ..progress = 0
          ..path = directory.path + bayans[i].link
          ..status = DownloadTaskStatus.enqueued
          ..taskId = taskId
          ..playlistId = playlist.id;
        _taskQueue.addTask(downloadState);
      }
    }
  }

  void removeAlltasksForPlaylist(String playlistId) {
    _taskQueue.removePlaylistTasks(playlistId);
  }
}
