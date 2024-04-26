import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/core/core.dart';
import 'package:watching/src/src.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

final watchingRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      final isOnLoginPage = state.fullPath == WatchingRoutesNames.root.path;
      if (isOnLoginPage) {
        return child;
      } else {
        return Scaffold(
          key: scaffoldKey,
          body: child,
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
    _profileRoute,
  ],
  redirect: (context, state) {
    final isOnRoot = state.fullPath == WatchingRoutesNames.root.path;
    final isAuthenticated = authRepository.getUser() != null;
    if (!isAuthenticated) {
      return WatchingRoutesNames.root.path;
    }
    if (isOnRoot && isAuthenticated) {
      return WatchingRoutesNames.discover.path;
    }
    return null;
  },
);

/// --- Patients route
final _profileRoute = GoRoute(
  path: WatchingRoutesNames.discover,
  name: WatchingRoutesNames.discover,
  builder: (context, state) {
    return const DiscoverScreen(
      key: Key(WatchingRoutesNames.discover),
    );
  },
  routes: const [],
);
