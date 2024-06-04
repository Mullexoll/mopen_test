import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mopen_test/presentation/widgets/latest_screen_widgets/movie_card_without_right_side.dart';

import '../../bloc/app_bloc.dart';
import '../widgets/screens_header.dart';
import 'detail.screen.dart';

class LatestScreen extends StatelessWidget {
  const LatestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 35),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ScreensHeader(
                onWillPop: () => Future.value(true),
                title: 'Latest',
              ),
              const Gap(15),
              if ((context.watch<AppBloc>().state as AppLoaded)
                  .latestMovies
                  .isNotEmpty)
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: (context.watch<AppBloc>().state as AppLoaded)
                      .latestMovies
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
                                movie: (context.watch<AppBloc>().state
                                        as AppLoaded)
                                    .latestMovies[index],
                              ),
                            ),
                          );
                        },
                        child: MovieCardWithoutRightSide(
                          movie: (context.watch<AppBloc>().state as AppLoaded)
                              .latestMovies[index],
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.49,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
