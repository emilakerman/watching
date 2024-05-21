import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/core/core.dart';
import 'package:watching/src/src.dart';
import 'package:watching/utils/hash_converter.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final FirebaseAuthRepository firebaseAuthRepo = FirebaseAuthRepository();

final watchingRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      final isOnLoginPage = state.fullPath == WatchingRoutesNames.root.path;
      final isOnProfilePage = state.fullPath == '/discover/profile:userId';
      final isOnSettingsPage =
          state.fullPath == '/discover/profile:userId/settings';
      final isOnShowPage = state.fullPath!.contains('show');
      if (isOnLoginPage) {
        return child;
      } else {
        return Scaffold(
          key: scaffoldKey,
          appBar: !isOnProfilePage && !isOnShowPage
              ? AppBar(
                  title: Image.asset(
                    'assets/images/logo_3.png',
                    height: 58,
                  ),
                  leading: isOnSettingsPage
                      ? BackButton(
                          onPressed: () => context.goNamed(
                            WatchingRoutesNames.profile,
                          ),
                        )
                      : null,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () => context.goNamed(
                          WatchingRoutesNames.profile,
                          pathParameters: {
                            'userId': customStringHash(
                                    firebaseAuthRepo.getUser()!.uid)
                                .toString(),
                          },
                        ),
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
          drawer: !isOnSettingsPage || !isOnShowPage
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
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
      child: const DiscoverScreen(
        key: Key(WatchingRoutesNames.discover),
      ),
    );
  },
  routes: [
    _profileRoute,
    _watchingRoute,
    _completedRoute,
    _planToWatchRoute,
    _featuredRoute,
    _leaderboardRoute,
    _showRoute,
  ],
);

/// --- Profile route
final _profileRoute = GoRoute(
  path: 'profile/:userId',
  name: WatchingRoutesNames.profile,
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
      child: ProfileScreen(
        userId: int.parse(state.pathParameters['userId']!),
        key: const Key(WatchingRoutesNames.profile),
      ),
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

/// --- Show Screen route
final _showRoute = GoRoute(
  path: 'show/:showId',
  name: WatchingRoutesNames.show,
  builder: (context, state) {
    return ShowScreen(
      showId: int.tryParse(state.pathParameters['showId']!),
      key: const Key(WatchingRoutesNames.show),
    );
  },
  routes: const [],
);
