import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VideoLoadingWidget extends StatelessWidget {
  const VideoLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/loading3.json',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}
