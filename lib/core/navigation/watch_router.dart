import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/core/core.dart';

class WatchingRouter {
  late final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: WatchingRoutesNames.root.path,
    routes: watchingRoutes,
    errorBuilder: (_, __) => const Placeholder(),
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
  );
}
