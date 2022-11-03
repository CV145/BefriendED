import 'dart:async';
import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/signin/view/signin.dart';
import 'package:flutter/material.dart';

class ArrowButton extends StatefulWidget {
  const ArrowButton({Key? key}) : super(key: key);

  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _scale2Controller;
  late AnimationController _widthController;
  late AnimationController _arrowPositionController;
  late AnimationController _positionController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _scale2Animation;
  late Animation<double> _widthAnimation;
  late Animation<double> _arrowPositionAnimation;
  late Animation<double> _positionAnimation;

  bool hideIcon = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation =
        Tween<double>(begin: 1, end: 0.8).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _widthController.forward();
            }
          });

    _widthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _widthAnimation =
        Tween<double>(begin: 80, end: 300).animate(_widthController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _positionController.forward();
            }
          });

    _positionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _positionAnimation =
        Tween<double>(begin: 0, end: 215).animate(_positionController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Timer(const Duration(seconds: 1), () {
                _scaleController.reset();
                _scale2Controller.reset();
                _widthController.reset();
                _arrowPositionController.reset();
                _positionController.reset();
              });
              Navigator.push(
                context,
                PageRouteBuilder<void>(
                  settings: const RouteSettings(name: RouteConstants.signIn),
                  pageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget? child) {
                        return Opacity(
                          opacity: animation.value,
                          child: const SignInPage(), //Widget being pushed
                        );
                      },
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 1000),
                ),
              );
            }
          });

    _arrowPositionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _arrowPositionAnimation =
        Tween<double>(begin: 14, end: 20).animate(_arrowPositionController);

    _scale2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scale2Animation =
        Tween<double>(begin: 1, end: 32).animate(_scale2Controller);
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //   }
    // });

    Timer(const Duration(milliseconds: 2400), () {
      _arrowPositionController.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleController,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Center(
          child: AnimatedBuilder(
            animation: _widthController,
            builder: (context, child) => Container(
              width: _widthAnimation.value,
              height: 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Theme.of(context).colorScheme.surface.withOpacity(.4),
              ),
              child: InkWell(
                onTap: () {
                  _scaleController.forward();
                  _arrowPositionController.stop();
                },
                child: Stack(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _positionController,
                      builder: (context, child) => Positioned(
                        left: _positionAnimation.value,
                        child: AnimatedBuilder(
                          animation: _scale2Controller,
                          builder: (context, child) => Transform.scale(
                            scale: _scale2Animation.value,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: hideIcon == false
                                  ? Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: <Widget>[
                                        const SizedBox(
                                          width: 60,
                                          height: 60,
                                        ),
                                        AnimatedBuilder(
                                          animation: _arrowPositionController,
                                          builder: (context, child) =>
                                              Positioned(
                                            left: _arrowPositionAnimation.value,
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
