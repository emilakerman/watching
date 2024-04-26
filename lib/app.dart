import 'package:flutter/material.dart';
import 'package:watching/core/core.dart';
import 'config/config.dart';

class App extends StatelessWidget {
  const App(this.environment, {super.key});
  final WatchingEnvironment environment;
  @override
  Widget build(BuildContext context) {
    final watchingRouter = WatchingRouter().router;
    return MaterialApp.router(
      routerConfig: watchingRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
