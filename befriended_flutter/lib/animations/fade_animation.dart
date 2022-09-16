import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// define animated properties
enum AniProps { opacity }

class FadeAnimation extends StatelessWidget {
  const FadeAnimation({Key? key, required this.delay, required this.child})
      : super(key: key);

  final int delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // design tween by composing scenes
    final tween = TimelineTween<AniProps>()
      ..addScene(
        begin: Duration.zero,
        duration: const Duration(milliseconds: 500),
      ).animate(
        AniProps.opacity,
        tween: Tween<double>(begin: 0, end: 1),
      );

    return PlayAnimation<TimelineValue<AniProps>>(
      tween: tween, // Pass in tween
      duration: tween.duration, // Obtain duration
      delay: Duration(milliseconds: delay),
      builder: (context, child, value) {
        return Opacity(
          opacity: value.get(AniProps.opacity),
          child: child,
        );
      },
      child: child,
    );
  }
}
