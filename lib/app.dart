import 'package:flutter/material.dart';
import 'src/src.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthenticationScreen(),
    );
  }
}
