
// utils/screen_logger.dart

import 'package:flutter/material.dart';
import '../main.dart';

/// Logs an error message in a bottom snackbar in the viewport.
void logOnScreen(String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  );
  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}
