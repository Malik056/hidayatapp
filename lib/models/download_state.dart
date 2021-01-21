import 'package:flutter_downloader/flutter_downloader.dart';

import 'bayan.dart';

class DownloadTaskState {
  DownloadTaskStatus status;
  int progress;
  int totalFiles;
  String taskId;
  Bayan bayan;
  String playlistId;
  String path;
}
