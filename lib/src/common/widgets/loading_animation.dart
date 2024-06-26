import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: const Color.fromARGB(255, 28, 71, 30),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
