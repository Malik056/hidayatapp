import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  // ignore: unused_element
  static Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static void showInSnackbarError(
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context, String text) {
    ScaffoldState scaffoldState = scaffoldKey.currentState;
    if (scaffoldState != null && scaffoldState.mounted) {
      SnackBar snackbar = SnackBar(
        content: Text(text,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.white,
                )),
        backgroundColor: Colors.red,
      );
      scaffoldState.showSnackBar(snackbar);
    }
  }
}
