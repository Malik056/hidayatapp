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

  void createEmptyTaskListIfAbsent(String playlistId) {
    _downloadQueue.putIfAbsent(playlistId, () => []);
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
          ?.removeWhere((element) => element.taskId == taskId);
      return state;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<void> stopTask(String taskId) async {
    await FlutterDownloader.cancel(taskId: taskId);
    await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: true);
    var state = _tasksQueue.remove(taskId);
    if (state == null) return;
    _downloadQueue[state.playlistId]
        ?.removeWhere((element) => element.taskId == taskId);
  }

  Future<void> stopAllPlaylistTasks(String playlistId) async {
    List<DownloadTaskState> taskStates = _downloadQueue[playlistId];
    taskStates?.forEach((element) async {
      await FlutterDownloader.cancel(taskId: element.taskId);
      await FlutterDownloader.remove(
          taskId: element.taskId, shouldDeleteContent: true);
      _tasksQueue.remove(element.taskId);
    });
    _downloadQueue[playlistId]?.clear();
    _downloadQueue[playlistId] = null;
  }

  void removePlaylistTasks(String playlistId) {
    _downloadQueue[playlistId] = null;
  }
}
