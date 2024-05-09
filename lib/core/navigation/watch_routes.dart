import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/core/core.dart';
import 'package:watching/src/src.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

final watchingRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      final isOnLoginPage = state.fullPath == WatchingRoutesNames.root.path;
      final isOnProfilePage = state.fullPath == '/discover/profile';
      final isOnSettingsPage = state.fullPath == '/discover/profile/settings';
      if (isOnLoginPage) {
        return child;
      } else {
        return Scaffold(
          key: scaffoldKey,
          appBar: !isOnProfilePage
              ? AppBar(
                  title: const Text('Watching'),
                  leading: isOnSettingsPage
                      ? BackButton(
                          onPressed: context.pop,
                        )
                      : null,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () =>
                            context.pushNamed(WatchingRoutesNames.profile),
                        child: const CircleAvatar(
                          radius: 15,
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : null,
          body: child,
          drawer: !isOnSettingsPage
              ? const Drawer(
                  child: HamburgerMenu(),
                )
              : null,
        );
      }
    },
    routes: <RouteBase>[
      _rootRoute,
    ],
  ),
];

final authRepository = FirebaseAuthRepository();

/// --- Root route
final _rootRoute = GoRoute(
  path: WatchingRoutesNames.root.path,
  name: WatchingRoutesNames.root,
  builder: (context, state) {
    return const AuthenticationScreen(
      key: Key(WatchingRoutesNames.root),
    );
  },
  routes: [
    _discoverRoute,
  ],
  redirect: (context, state) {
    final isOnRoot = state.fullPath == WatchingRoutesNames.root.path;
    final isAuthenticated = authRepository.isAuthenticated();
    if (!isAuthenticated) {
      return WatchingRoutesNames.root.path;
    }
    if (isOnRoot && isAuthenticated) {
      return WatchingRoutesNames.discover.path;
    }
    return null;
  },
);

/// --- Discover route
final _discoverRoute = GoRoute(
  path: WatchingRoutesNames.discover,
  name: WatchingRoutesNames.discover,
  builder: (context, state) {
    return const DiscoverScreen(
      key: Key(WatchingRoutesNames.discover),
    );
  },
  routes: [
    _profileRoute,
    _watchingRoute,
    _completedRoute,
    _planToWatchRoute,
    _featuredRoute,
    _leaderboardRoute,
  ],
);

/// --- Profile route
final _profileRoute = GoRoute(
  path: WatchingRoutesNames.profile,
  name: WatchingRoutesNames.profile,
  builder: (context, state) {
    return const ProfileScreen(
      key: Key(WatchingRoutesNames.profile),
    );
  },
  routes: [
    _settingsRoute,
  ],
);

/// --- Watching Screen route
final _watchingRoute = GoRoute(
  path: WatchingRoutesNames.watching,
  name: WatchingRoutesNames.watching,
  builder: (context, state) {
    return const WatchingScreen(
      key: Key(WatchingRoutesNames.watching),
    );
  },
  routes: const [],
);

/// --- Completed Screen route
final _completedRoute = GoRoute(
  path: WatchingRoutesNames.completed,
  name: WatchingRoutesNames.completed,
  builder: (context, state) {
    return const CompletedScreen(
      key: Key(WatchingRoutesNames.completed),
    );
  },
  routes: const [],
);

/// --- Plan To Watch Screen route
final _planToWatchRoute = GoRoute(
  path: WatchingRoutesNames.planToWatch,
  name: WatchingRoutesNames.planToWatch,
  builder: (context, state) {
    return const PlanToWatchScreen(
      key: Key(WatchingRoutesNames.planToWatch),
    );
  },
  routes: const [],
);

/// --- Featured Screen route
final _featuredRoute = GoRoute(
  path: WatchingRoutesNames.featured,
  name: WatchingRoutesNames.featured,
  builder: (context, state) {
    return const FeaturedScreen(
      key: Key(WatchingRoutesNames.featured),
    );
  },
  routes: const [],
);

/// --- Settings Screen route
final _settingsRoute = GoRoute(
  path: WatchingRoutesNames.settings,
  name: WatchingRoutesNames.settings,
  builder: (context, state) {
    return const SettingsScreen(
      key: Key(WatchingRoutesNames.settings),
    );
  },
  routes: const [],
);

/// --- Leaderboard Screen route
final _leaderboardRoute = GoRoute(
  path: WatchingRoutesNames.leaderboard,
  name: WatchingRoutesNames.leaderboard,
  builder: (context, state) {
    return const LeaderboardScreen(
      key: Key(WatchingRoutesNames.leaderboard),
    );
  },
  routes: const [],
);
