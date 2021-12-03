import 'bayan.dart';

enum DownloadTaskStatus { enqueued, downloading, completed }

class DownloadTaskState {
  DownloadTaskStatus status;
  double progress;
  int totalFiles;
  String taskId;
  Bayan bayan;
  String playlistId;
  String path;
  DownloadTaskState({
    required this.status,
    required this.progress,
    required this.totalFiles,
    required this.taskId,
    required this.bayan,
    required this.playlistId,
    required this.path,
  });
}
