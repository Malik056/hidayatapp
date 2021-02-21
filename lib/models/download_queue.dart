import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'download_state.dart';

class DownloadQueue {
  final Map<String, List<DownloadTaskState>> _downloadQueue = {};

  int totalTasksByPlaylist(String playlistId) {
    return _downloadQueue[playlistId]?.length ?? -1;
  }

  List<DownloadTaskState> getDownloadStateOfPlaylist(String playlistId) {
    return _downloadQueue[playlistId];
  }

  List<DownloadTaskState> addTask(DownloadTaskState state) {
    assert(state?.playlistId?.isNotEmpty ?? false);
    String playlistId = state.playlistId;
    List<DownloadTaskState> tasks = _downloadQueue[playlistId];
    if (tasks == null) {
      tasks = [];
      _downloadQueue.putIfAbsent(playlistId, () => tasks);
    }
    return tasks..add(state);
  }

  void removePlaylistTasks(String playlistId) {
    _downloadQueue.remove(playlistId);
  }

  Future<void> startDownloadQueue(String playlistId,
      [Function() progressUpdate]) async {
    final dio = Dio();
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    int pathSeparator =
        Platform.pathSeparator.codeUnitAt(Platform.pathSeparator.length - 1);
    if (path.codeUnitAt(path.length - 1) != pathSeparator) {
      path = path + Platform.pathSeparator;
    }
    List<DownloadTaskState> queue = List.from(_downloadQueue[playlistId] ?? []);
    for (int i = 0; i < queue.length; i++) {
      var value = queue[i];
      if (value.status == DownloadTaskStatus.enqueued) {
        try {
          await dio.download(
            value.bayan.link,
            path + value.bayan.getUniqueFileName(),
            onReceiveProgress: (count, total) async {
              if (total == -1) return;
              var state = value;
              if (state == null) {
                return;
              }
              state.status = DownloadTaskStatus.downloading;
              if (progressUpdate != null) progressUpdate();
              state.progress = count / total;
              if (count == total) {
                state.bayan.filePath = state.path;
                state.status = DownloadTaskStatus.completed;
                await state.bayan.downloadComplete(state);
                if (i == queue.length - 1) {
                  _downloadQueue.remove(playlistId);
                  if (progressUpdate != null) progressUpdate();
                }
              }
            },
          );
        } catch (ex) {
          print(ex);
        }
      }
    }
  }
}
