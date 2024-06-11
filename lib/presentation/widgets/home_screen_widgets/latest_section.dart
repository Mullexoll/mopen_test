import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tmdb_project/blocs/latest_movies_bloc/latest_movies_bloc.dart';

import '../../../domain/models/movie.model.dart';
import '../../screens/detail.screen.dart';
import '../../screens/latest.screen.dart';
import '../movie_card_right_side_info.dart';

class LatestSection extends StatelessWidget {
  const LatestSection({super.key});

  void addToFavorite(
    BuildContext context,
    Movie movie,
  ) {
    BlocProvider.of<LatestMoviesBloc>(context).add(
      AddLatestMovieToFavorite(
        movie: movie,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.latest,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.yellowAccent,
                      ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LatestScreen(),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.seeMore,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
        BlocBuilder<LatestMoviesBloc, LatestMoviesState>(
          builder: (context, state) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.latestMovies.take(6).length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => DetailScreen(
                            movie: state.latestMovies[index],
                          ),
                        ),
                      );
                    },
                    child: MovieCardRightSideInfo(
                      movie: state.latestMovies[index],
                      onTapFavorite: addToFavorite,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
