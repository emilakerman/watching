///  Class containing all the routes paths used in the web app
class WatchingRoutesNames {
  /// Route is: /
  static const root = '/';

  /// Route is: (login) /
  static const home = root;

  /// Route is: discover
  static const discover = 'discover';

  /// Route is: profile
  static const profile = 'profile';

  /// Route is: watching
  static const watching = 'watching';

  /// Route is: completed
  static const completed = 'completed';

  /// Route is: plan-to-watch
  static const planToWatch = 'planToWatch';

  /// Route is: featured
  static const featured = 'featured';

  /// Route is: settings
  static const settings = 'settings';

  /// Route is: leaderboard
  static const leaderboard = 'leaderboard';

  /// Route is: show
  static const show = 'show';
}

extension RoutesX on String {
  String get path => this == '/' ? this : '/$this';
}
