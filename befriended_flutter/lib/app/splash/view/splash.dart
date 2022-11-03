import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/home/home.dart';
import 'package:befriended_flutter/app/launch/launch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

/*
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashState();
}

// Country picker state class
class _SplashState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    final appState = context.read<AppCubit>().state;
    if (appState.nameStatus == NameStatus.success) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          navigateNextPage(appState.name);
        },
      );
    }
  }

  void navigateNextPage(String name) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder<void>(
        settings: RouteSettings(
            name:
                name.isNotEmpty ? RouteConstants.home : RouteConstants.launch),
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
                child: name.isNotEmpty ? const HomePage() : const LaunchPage(),
              );
            },
          );
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listenWhen: (previous, current) {
        return previous.nameStatus != current.nameStatus;
      },
      listener: (context, state) {
        if (state.nameStatus == NameStatus.success) {
          navigateNextPage(state.name);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              const Positioned.fill(
                child: SizedBox(),
              ),
              const Align(
                child: Hero(
                  tag: 'AppLogo',
                  child: Image(
                    width: 200,
                    height: 200,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 100,
                  ),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballClipRotateMultiple,
                      colors: [Theme.of(context).colorScheme.onBackground],
                      strokeWidth: 2,
                      // backgroundColor: Colors.black,
                      // pathBackgroundColor: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
