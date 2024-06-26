import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';

import '../../blocs/app_bloc/app_bloc.dart';
import '../widgets/movie_card_right_side_info.dart';
import '../widgets/screens_header.dart';
import 'detail.screen.dart';

class FavoritesScreen extends StatelessWidget {
  final Future<bool> Function() onWillPop;

  const FavoritesScreen({
    super.key,
    required this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 35),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ScreensHeader(
              title: AppLocalizations.of(context)!.bookmarks,
              onWillPop: onWillPop,
            ),
            const Gap(15),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (context.watch<AppBloc>().state as AppLoaded)
                  .favoritesMovies
                  .length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => DetailScreen(
                            movie: (context.watch<AppBloc>().state as AppLoaded)
                                .favoritesMovies[index],
                          ),
                        ),
                      );
                    },
                    child: MovieCardRightSideInfo(
                      movie: (context.watch<AppBloc>().state as AppLoaded)
                          .favoritesMovies[index],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
