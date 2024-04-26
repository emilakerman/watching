import 'package:flutter/material.dart';

/// A class contains the wathcing app platform theme.
class AppTheme {
  /// Returns the standard light theme.
  static ThemeData get standard {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }
}
