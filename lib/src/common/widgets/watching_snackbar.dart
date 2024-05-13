import 'package:flutter/material.dart';

/// Reusable snackbar with 5 seconds standard duration.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar({
  required BuildContext context,
  required String message,
  Duration? duration,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration ?? const Duration(seconds: 5),
      content: Text(message),
    ),
  );
}
