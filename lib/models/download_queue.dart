import 'package:flutter_downloader/flutter_downloader.dart';

import 'download_state.dart';

class DownloadQueue {
  final Map<String, List<DownloadTaskState>> _downloadQueue = {};
  final Map<String, DownloadTaskState> _tasksQueue = {};

  int totalTasksByPlaylist(String playlistId) {
    return _downloadQueue[playlistId]?.length ?? -1;
  }

  List<DownloadTaskState> getDownloadStateOfPlaylist(String playlistId) {
    return _downloadQueue[playlistId];
  }

  DownloadTaskState getDownloadStateByTaskId(String taskId) {
    return _tasksQueue[taskId];
  }

  List<DownloadTaskState> addTask(DownloadTaskState state) {
    assert(state?.playlistId?.isNotEmpty ?? false);
    String playlistId = state.playlistId;
    List<DownloadTaskState> tasks = _downloadQueue[playlistId];
    if (tasks == null) {
      tasks = [];
      _downloadQueue.putIfAbsent(playlistId, () => tasks);
    }
    _tasksQueue.putIfAbsent(state.taskId, () => state);
    return tasks..add(state);
  }

  DownloadTaskState removeTaskById(String taskId) {
    try {
      DownloadTaskState state = _tasksQueue.remove(taskId);
      _downloadQueue[state.playlistId]
          .removeWhere((element) => element.taskId == taskId);
      return state;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  void stopAllPlaylistTasks(String playlistId) {
    List<DownloadTaskState> taskStates = _downloadQueue[playlistId];
    taskStates?.forEach((element) {
      FlutterDownloader.remove(taskId: element.taskId);
      _tasksQueue.remove(element.taskId);
    });
    _downloadQueue[playlistId]?.clear();
    _downloadQueue[playlistId] = null;
  }

  void removePlaylistTasks(String playlistId) {
    _downloadQueue[playlistId] = null;
  }
}
