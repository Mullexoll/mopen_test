import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_project/blocs/search_movies_bloc/search_movies_bloc.dart';
import 'package:tmdb_project/domain/models/movie.model.dart';

import '../../screens/detail.screen.dart';
import '../movie_card_right_side_info.dart';

class SearchResultSection extends StatelessWidget {
  final List<Movie> movies;
  final bool hasMore;

  const SearchResultSection({
    super.key,
    required this.movies,
    required this.hasMore,
  });

  void addToFavorite(
    BuildContext context,
    Movie movie,
  ) {
    BlocProvider.of<SearchMoviesBloc>(context).add(
      AddSearchedMovieToFavorite(
        movie: movie,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.30,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == movies.length) {
            return hasMore
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DetailScreen(
                      movie: movies[index],
                    ),
                  ),
                );
              },
              child: MovieCardRightSideInfo(
                movie: movies[index],
                onTapFavorite: addToFavorite,
              ),
            ),
          );
        },
        childCount: movies.length + 1,
      ),
    );
  }
}
