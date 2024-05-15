import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingAnimationColor extends StatelessWidget {
  const LoadingAnimationColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: Colors.blue[600]!,
        size: 40,
      ),
    );
  }
}
