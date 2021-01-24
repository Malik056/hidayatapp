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
}
