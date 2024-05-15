import 'dart:ui';

Color stringToColour(String str) {
  int hash = 0;
  for (int i = 0; i < str.length; i++) {
    hash = str.codeUnitAt(i) + ((hash << 5) - hash);
  }
  final int r = (hash & 0xFF0000) >> 16;
  final int g = (hash & 0x00FF00) >> 8;
  final int b = hash & 0x0000FF;
  return Color.fromRGBO(r, g, b, 1.0);
}
