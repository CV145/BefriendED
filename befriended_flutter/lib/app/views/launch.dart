import 'package:befriended_flutter/animations/fade_up_animation.dart';
import 'package:befriended_flutter/app/views/arrow_button.dart';
import 'package:flutter/material.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                child: Hero(
                  tag: 'AppLogo',
                  child: Image(
                    width: 200,
                    height: 200,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
              FadeUpAnimation(
                delay: 700,
                child: Align(
                  child: Hero(
                    tag: 'BefriendEDTitle',
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: Text(
                        'BefriendED',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FadeUpAnimation(
                delay: 900,
                child: Align(
                  child: Text(
                    'We are always here for you!',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),
              const Spacer(),
              const FadeUpAnimation(
                delay: 1500,
                child: ArrowButton(),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget overlayImage(BuildContext context, int delay, double top) {
    final width = MediaQuery.of(context).size.width;
    return Positioned(
      top: top,
      left: 0,
      child: FadeUpAnimation(
        delay: delay,
        child: Container(
          width: width,
          height: 400,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/one.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
