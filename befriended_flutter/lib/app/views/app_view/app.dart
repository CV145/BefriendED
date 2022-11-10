// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:befriended_flutter/l10n/l10n.dart';
import 'package:befriended_flutter/local_storage/local_storage.dart';
import 'package:befriended_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';

import '../launch.dart';

// when logged in call many items to register
class App extends StatelessWidget {
  const App({Key? key, required this.localStorage}) : super(key: key);

  final LocalStorage localStorage;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: localStorage,
      child: const AppProvider(),
    );
  }
}

class AppProvider extends StatelessWidget {
  const AppProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return const AppView();
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

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
        initialRoute: '/launching',
        routes: {
          '/launching': (context) => const LaunchPage(),
        },
        onGenerateRoute: (settings) {
          return null;
        },
      ),
    );
  }
}



