import 'package:flutter/material.dart';

/// A class contains the wathcing app platform theme.
class AppTheme {
  /// Returns the standard light theme.
  static ThemeData get standard {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xff010101),
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
        displayLarge: TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
        displayMedium: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
