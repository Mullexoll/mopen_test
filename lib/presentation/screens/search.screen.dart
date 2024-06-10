import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:tmdb_project/presentation/widgets/search_screen_widgets/search_result_section.dart';

import '../../blocs/search_movies_bloc/search_movies_bloc.dart';
import '../../domain/models/movie.model.dart';
import '../widgets/screens_header.dart';
import '../widgets/search_screen_widgets/search_bar.dart';

class SearchScreen extends StatelessWidget {
  final Future<bool> Function() onWillPop;

  SearchScreen({
    super.key,
    required this.onWillPop,
  });

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 35),
      child: BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
        builder: (context, state) {
          bool hasMore = state.searchedMovies.isNotEmpty;
          List<Movie> movies = state.searchedMovies;

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (hasMore &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                BlocProvider.of<SearchMoviesBloc>(context).add(
                  FetchSearchedMovies(
                    page: state.currentPage,
                    query: textController.text,
                  ),
                );
              }
              return false;
            },
            child: CustomScrollView(
              controller: ScrollController(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 150,
                  collapsedHeight: 150,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  backgroundColor: Colors.black,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ScreensHeader(
                          onWillPop: onWillPop,
                          title: AppLocalizations.of(context)!.latest,
                        ),
                        const Gap(15),
                        CustomSearchBar(
                          textController: textController,
                        ),
                        const Gap(15),
                        Text(
                          '${AppLocalizations.of(context)!.searchResult} (${state.searchedMovies.length})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverGap(15),
                SearchResultSection(
                  movies: movies,
                  hasMore: hasMore,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
