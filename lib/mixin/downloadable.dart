import 'package:hidayat/database/database.dart';
import 'package:hidayat/models/download_state.dart';

abstract class Downloadable {
  Future<void> downloadComplete(DownloadTaskState state) async {
    await MySQLiteDatabase.getInstance().bayanDbHelper.updateBayan(state.bayan);
  }
}
