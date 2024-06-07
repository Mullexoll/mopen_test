import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';

import '../../../bloc/app_bloc.dart';
import '../../screens/detail.screen.dart';
import 'top_five_card.dart';

class TopFiveSection extends StatelessWidget {
  const TopFiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.topFive,
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
        const Gap(20),
        BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppLoading) {
              return const CircularProgressIndicator();
            } else if (state is AppLoaded) {
              return SizedBox(
                height: 266,
                child: PageView.builder(
                  pageSnapping: false,
                  padEnds: false,
                  controller: PageController(
                    initialPage: 0,
                    viewportFraction: 0.85,
                  ),
                  itemCount: state.topMovies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DetailScreen(
                              movie: state.topMovies[index],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: TopFiveCard(
                          topMovie: state.topMovies[index],
                        ),
                      ),
                    );
                  },
                ),
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
