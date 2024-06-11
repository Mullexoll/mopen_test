import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../domain/models/movie.model.dart';
import 'home_screen_widgets/rating.dart';

class MovieCardRightSideInfo extends StatelessWidget {
  final Movie movie;
  final Function onTapFavorite;

  const MovieCardRightSideInfo({
    super.key,
    required this.movie,
    required this.onTapFavorite,
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
                onTap: () => onTapFavorite(context, movie),
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
              const Gap(10),
              MovieRating(
                rating: movie.voteAverage,
              ),
              const Gap(10),
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
