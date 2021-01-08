import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Utils {
  // ignore: unused_element
  static Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
