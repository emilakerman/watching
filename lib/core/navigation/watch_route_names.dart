///  Class containing all the routes paths used in the web app
class WatchingRoutesNames {
  /// Route is: /
  static const root = '/';

  /// Route is: (login) /
  static const home = root;

  /// Route is: profile
  static const discover = 'discover';
}

extension RoutesX on String {
  String get path => this == '/' ? this : '/$this';
}
