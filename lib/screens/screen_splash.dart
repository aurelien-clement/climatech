
// screens/screen_splash.dart

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Splash screen displayed during app initialization.
class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3F6EB5), Color(0xff3F51B5), Color(0xff3F51B5), Color(0xff4B3FB5)],
                stops: [0, 0.25, 0.75, 1],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitThreeBounce(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                  size: 32.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
