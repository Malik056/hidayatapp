import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  // ignore: unused_element
  static Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  static void showInSnackbarError(
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context, String text) {
    ScaffoldState? scaffoldState = scaffoldKey.currentState;
    if (scaffoldState != null && scaffoldState.mounted) {
      SnackBar snackbar = getSnackbar(text);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  static SnackBar getSnackbar(
    String text, {
    String actionText = "Retry",
    Color textColor = Colors.white,
    Color? actionTextColor,
    VoidCallback? onAction,
    Color backgroundColor = Colors.black,
  }) {
    return SnackBar(
      content: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
      backgroundColor: backgroundColor,
      action: onAction == null
          ? null
          : SnackBarAction(
              label: actionText,
              textColor: actionTextColor ?? Colors.yellow[700],
              onPressed: onAction,
            ),
    );
  }

  static void showErrorWithReload(GlobalKey<ScaffoldState> scaffoldKey,
      BuildContext context, String text, VoidCallback onRetry) {
    ScaffoldState? scaffoldState = scaffoldKey.currentState;
    if (scaffoldState != null && scaffoldState.mounted) {
      SnackBar snackbar = getSnackbar(text);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
