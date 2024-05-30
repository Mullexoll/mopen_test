import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mopen_test/presentation/screens/detail.screen.dart';
import 'package:mopen_test/presentation/widgets/movie_card_right_side_info.dart';

import '../../../bloc/app_bloc.dart';

class LatestSection extends StatelessWidget {
  const LatestSection({super.key});

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
                  'Latest',
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
              onTap: () {},
              child: Text(
                'SEE MORE',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
        BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppLoading) {
              return const CircularProgressIndicator();
            } else if (state is AppLoaded) {
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
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
