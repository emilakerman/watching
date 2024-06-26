import 'package:flutter/material.dart';
import 'package:watching/core/core.dart';
import 'package:watching/src/themes/themes.dart';
import 'package:watching/watching_providers.dart';
import 'config/config.dart';

class App extends StatelessWidget {
  const App(this.environment, {super.key});
  final WatchingEnvironment environment;
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.standard;
    final watchingRouter = WatchingRouter().router;
    return WatchingProviders(
      environment: environment,
      child: MaterialApp.router(
        theme: appTheme,
        routerConfig: watchingRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
