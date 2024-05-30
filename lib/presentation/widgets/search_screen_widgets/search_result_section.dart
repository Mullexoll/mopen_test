import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../bloc/app_bloc.dart';
import '../../screens/detail.screen.dart';
import '../movie_card_right_side_info.dart';

class SearchResultSection extends StatelessWidget {
  const SearchResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is AppLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search result (${state.searchedMovies.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              state.isSearching
                  ? const Column(
                      children: [
                        Gap(20),
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.searchedMovies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailScreen(
                                    movie: state.searchedMovies[index],
                                  ),
                                ),
                              );
                            },
                            child: MovieCardRightSideInfo(
                                movie: state.searchedMovies[index]),
                          ),
                        );
                      },
                    ),
            ],
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
