import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';

import '../../blocs/latest_movies_bloc/latest_movies_bloc.dart';
import '../../domain/models/movie.model.dart';
import '../widgets/latest_screen_widgets/movie_card_without_right_side.dart';
import '../widgets/screens_header.dart';
import 'detail.screen.dart';

class LatestScreen extends StatelessWidget {
  const LatestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LatestMoviesBloc, LatestMoviesState>(
        builder: (context, state) {
          bool hasMore = state.latestMovies.isNotEmpty;
          List<Movie> movies = state.latestMovies;

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (hasMore &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                BlocProvider.of<LatestMoviesBloc>(context).add(
                  FetchLatestMovies(
                    page: state.currentPage,
                  ),
                );
              }
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 35),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    backgroundColor: Colors.black,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ScreensHeader(
                        onWillPop: () async {
                          Navigator.of(context).pop();
                          return Future.value(false);
                        },
                        title: AppLocalizations.of(context)!.latest,
                      ),
                    ),
                  ),
                  const SliverGap(15),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
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
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailScreen(
                                    movie: movies[index],
                                  ),
                                ),
                              );
                            },
                            child: MovieCardWithoutRightSide(
                              movie: movies[index],
                            ),
                          ),
                        );
                      },
                      childCount: movies.length + 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
