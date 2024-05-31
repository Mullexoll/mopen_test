import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../bloc/app_bloc.dart';
import '../../../domain/models/movie.model.dart';

class MovieCardWithoutRightSide extends StatelessWidget {
  final Movie movie;

  const MovieCardWithoutRightSide({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 182,
      height: 360,
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
                  'https://image.tmdb.org/t/p/w400/${movie.posterPath}',
                  width: 182,
                  height: 273,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: InkWell(
                  onTap: () {
                    final _ = BlocProvider.of<AppBloc>(context).add(
                      FavoriteHandler(movie: movie),
                    );
                  },
                  child: SvgPicture.asset(
                    movie.isFavorite
                        ? 'assets/icons/bookmark_active_icon.svg'
                        : 'assets/icons/bookmark_disable_icon.svg',
                  ),
                ),
              ),
            ],
          ),
          const Gap(5),
          SizedBox(
            width: 170,
            child: Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              softWrap: true,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  (movie.voteAverage / 2).toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              const Gap(5),
              SvgPicture.asset(
                'assets/icons/full_star.svg',
                width: 26,
                height: 26,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
