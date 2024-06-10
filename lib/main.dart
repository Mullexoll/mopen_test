import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:tmdb_project/blocs/latest_movies_bloc/latest_movies_bloc.dart';
import 'package:tmdb_project/blocs/search_movies_bloc/search_movies_bloc.dart';
import 'package:tmdb_project/presentation/screens/splash_screen.dart';
import 'package:tmdb_project/services/localization.dart';

import 'blocs/app_bloc/app_bloc.dart';
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
            ),
        ),
        BlocProvider<LatestMoviesBloc>(
          create: (BuildContext context) => LatestMoviesBloc()
            ..add(
              FetchLatestMovies(page: 1),
            ),
        ),
        BlocProvider<SearchMoviesBloc>(
          create: (BuildContext context) => SearchMoviesBloc(),
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

              return const SplashImageScreen();
            },
          ),
        ),
      ),
    );
  }
}
