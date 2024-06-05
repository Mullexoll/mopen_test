import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mopen_test/presentation/screens/tab_bar.screen.dart';
import 'package:mopen_test/services/localization.dart';

import 'bloc/app_bloc.dart';
import 'theme/app.theme.dart';

GetIt getIt = GetIt.instance;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (BuildContext context) => AppBloc()
            ..add(
              FetchTopMovies(),
            )
            ..add(
              FetchLatestMovies(),
            ),
        ),
      ],
      child: MaterialApp(
        title: 'TMDB',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale != null && locale.languageCode == 'uk') {
            final _ = getIt.registerSingleton<Locale>(const Locale('uk'));
            return const Locale('uk');
          }
          final _ = getIt.registerSingleton<Locale>(const Locale('en'));
          return const Locale('en');
        },
        supportedLocales: AppLocalizationsInit.supportedLocales,
        theme: AppTheme.dark,
        home: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              if (state is AppLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const TabBarScreen();
            },
          ),
        ),
      ),
    );
  }
}
