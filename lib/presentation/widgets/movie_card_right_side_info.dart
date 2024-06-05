import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mopen_test/domain/models/movie.model.dart';

import '../../bloc/app_bloc.dart';
import 'home_screen_widgets/star_rating.dart';

class MovieCardRightSideInfo extends StatelessWidget {
  final Movie movie;

  const MovieCardRightSideInfo({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                  width: 180,
                  height: 273,
                  fit: BoxFit.cover,
                  errorBuilder: (e, o, s) {
                    return Image.asset(
                      'assets/icons/coming_soon.png',
                      width: 180,
                      height: 273,
                      fit: BoxFit.cover,
                    );
                  },
                ),
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
        const Gap(20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Text(
                  movie.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleMedium,
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
                  const Gap(10),
                  StarRating(
                    rating: double.parse(
                      (movie.voteAverage / 2).toStringAsFixed(1),
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  ...movie.genres.map(
                    (genre) => Text(
                      genre != movie.genres.last ? '$genre, ' : genre,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Text(
                movie.overview.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                softWrap: true,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
