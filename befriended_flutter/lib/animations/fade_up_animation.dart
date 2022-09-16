import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// define animated properties
enum AniProps { opacity, translateY }

class FadeUpAnimation extends StatelessWidget {
  const FadeUpAnimation({Key? key, required this.delay, required this.child})
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
      )
          .animate(
            AniProps.opacity,
            tween: Tween<double>(begin: 0, end: 1),
          )
          .animate(
            AniProps.translateY,
            tween: Tween<double>(begin: 130, end: 0),
            curve: Curves.easeOut,
          );

    return PlayAnimation<TimelineValue<AniProps>>(
      tween: tween, // Pass in tween
      duration: tween.duration, // Obtain duration
      delay: Duration(milliseconds: delay),
      builder: (context, child, value) {
        return Opacity(
          opacity: value.get(AniProps.opacity),
          child: Transform.translate(
            offset: Offset(0, value.get(AniProps.translateY)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
