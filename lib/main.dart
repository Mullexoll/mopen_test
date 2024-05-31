import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:mopen_test/presentation/screens/tab_bar.screen.dart';
import 'package:mopen_test/services/localization.dart';

import 'bloc/app_bloc.dart';
import 'theme/app.theme.dart';

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
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'TMDB',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null && locale.languageCode == 'uk') {
                BlocProvider.of<AppBloc>(context)
                    .add(AddCurrentLocal(currentLocal: 'uk'));
                return const Locale('uk');
              }
              BlocProvider.of<AppBloc>(context)
                  .add(AddCurrentLocal(currentLocal: 'en'));
              return const Locale('en');
            },
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.dark,
            home: const TabBarScreen(),
          );
        },
      ),
    );
  }
}
