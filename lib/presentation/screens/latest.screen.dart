import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:tmdb_project/services/api.service.dart';

import '../../domain/models/movie.model.dart';
import '../../infrastructure/datasource/fetch_latest_movies.api.dart';
import '../widgets/latest_screen_widgets/movie_card_without_right_side.dart';
import '../widgets/screens_header.dart';
import 'detail.screen.dart';

class LatestScreen extends StatefulWidget {
  const LatestScreen({super.key});

  @override
  State<LatestScreen> createState() => _LatestScreenState();
}

class _LatestScreenState extends State<LatestScreen> {
  final List<Movie> movies = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final List<Movie> latestMovies =
          await FetchLatestMoviesAPI(apiService: APIService()).fetch(
                page: currentPage.toString(),
              ) ??
              [];

      setState(() {
        movies.addAll(latestMovies);
        currentPage++;
        hasMore = movies.isNotEmpty;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (hasMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchMovies();
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                              builder: (BuildContext context) => DetailScreen(
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
      ),
    );
  }
}
//
// InkWell(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (BuildContext context) =>
// DetailScreen(
// movie: movies[index],
// ),
// ),
// );
// },
// child: MovieCardWithoutRightSide(
// movie: movies[index],
// ),
// ),
