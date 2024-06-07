import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../bloc/app_bloc.dart';
import '../../../domain/models/movie.model.dart';
import 'star_rating.dart';

class TopFiveCard extends StatefulWidget {
  final Movie topMovie;

  const TopFiveCard({
    super.key,
    required this.topMovie,
  });

  @override
  State<TopFiveCard> createState() => _TopFiveCardState();
}

class _TopFiveCardState extends State<TopFiveCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 266,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w400/${widget.topMovie.backdropPath}',
                  width: 300,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: InkWell(
                  onTap: () {
                    final _ = BlocProvider.of<AppBloc>(context).add(
                      FavoriteHandler(movie: widget.topMovie),
                    );
                  },
                  child: SvgPicture.asset(
                    widget.topMovie.isFavorite
                        ? 'assets/icons/bookmark_active_icon.svg'
                        : 'assets/icons/bookmark_disable_icon.svg',
                  ),
                ),
              ),
            ],
          ),
          const Gap(5),
          Text(
            widget.topMovie.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  (widget.topMovie.voteAverage / 2).toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              const Gap(10),
              StarRating(
                rating: double.parse(
                  (widget.topMovie.voteAverage / 2).toStringAsFixed(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
