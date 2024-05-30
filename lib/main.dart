import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mopen_test/presentation/screens/tab_bar.screen.dart';

import 'bloc/app_bloc.dart';
import 'theme/app.theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        theme: AppTheme.dark,
        home: const TabBarScreen(),
      ),
    );
  }
}
