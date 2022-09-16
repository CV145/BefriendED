// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/availability_schedule/availability_schedule.dart';
import 'package:befriended_flutter/app/availability_schedule/cubit/availability_schedule_cubit.dart';
import 'package:befriended_flutter/app/buddy_request/cubit/cubit.dart';
import 'package:befriended_flutter/app/login/cubit/login_cubit.dart';
import 'package:befriended_flutter/app/name/name.dart';
import 'package:befriended_flutter/app/splash/splash.dart';
import 'package:befriended_flutter/app/support/cubit/cubit.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:befriended_flutter/l10n/l10n.dart';
import 'package:befriended_flutter/local_storage/local_storage.dart';
import 'package:befriended_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';

// when logged in calll many items to register

class App extends StatelessWidget {
  const App({Key? key, required this.localStorage}) : super(key: key);

  final LocalStorage localStorage;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: localStorage,
      child: const AppProvider(),
    );
    // return const AppProvider();
  }
}

class AppProvider extends StatelessWidget {
  const AppProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) =>
              AppCubit(localStorage: context.read<LocalStorage>())
                ..getName()
                ..getPhoneNumber()
                ..checkLogIn(preValidation: FirebaseProvider().isLoggedIn()),
        ),
        BlocProvider<LoginCubit>(
          create: (context) =>
              LoginCubit(localStorage: context.read<LocalStorage>()),
        ),
        BlocProvider<AvialabiliyScheduleCubit>(
          create: (context) => AvialabiliyScheduleCubit(),
        ),
        BlocProvider<SupportCubit>(
          create: (context) => SupportCubit()..getRequest(),
        ),
        BlocProvider<RequestBuddyCubit>(
          create: (context) => RequestBuddyCubit()..getBuddyRequest(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
  // bool _isLaunched = false;

  // void _whenLaunched() {
  //   setState(() {
  //     _isLaunched = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        // home: const LaunchPage(),
        initialRoute: '/loading',
        routes: {
          '/loading': (context) => const SplashPage(),
          // When navigating to the "/" route, build the FirstScreen widget.
          // '/launch': (context) => const LaunchPage(),
          // // When navigating to the "/second" route, build the SecondScreen widget.
          // '/otpScreen': (context) => const CounterPage(),
        },
        onGenerateRoute: (settings) {
          // switch (settings.name) {
          //   case '/namepage':
          //     return PageTransition<CounterPage>(
          //       child: const NamePage(),
          //       type: PageTransitionType.fade,
          //       settings: settings,
          //       reverseDuration: const Duration(seconds: 3),
          //     );
          //   default:
          //     return null;
          // }
        },
      ),
    );
  }
}

// _isLaunched
//         ? MaterialApp(
//             theme: AppTheme.light,
//             darkTheme: AppTheme.dark,
//             localizationsDelegates: const [
//               AppLocalizations.delegate,
//               GlobalMaterialLocalizations.delegate,
//             ],
//             supportedLocales: AppLocalizations.supportedLocales,
//             home: const CounterPage(),
//           )
//         :
