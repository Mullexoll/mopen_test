import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tmdb_project/presentation/screens/tab_bar.screen.dart';

class SplashImageScreen extends StatefulWidget {
  const SplashImageScreen({
    super.key,
  });

  @override
  State<SplashImageScreen> createState() => _SplashImageScreenState();
}

class _SplashImageScreenState extends State<SplashImageScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool splashScreenFinished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2900),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(
          () {
            splashScreenFinished = true;
          },
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: const TabBarScreen(),
            ),
          ),
        );
      }
    });
    final _ = _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/loading_animation.json',
      controller: _controller,
    );
  }
}
