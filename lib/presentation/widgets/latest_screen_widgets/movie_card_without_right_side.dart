import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../domain/models/movie.model.dart';
import '../home_screen_widgets/rating.dart';

class MovieCardWithoutRightSide extends StatelessWidget {
  final Movie movie;
  final Function onTapFavorite;

  const MovieCardWithoutRightSide({
    super.key,
    required this.movie,
    required this.onTapFavorite,
  });

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
                  height: 249,
                  fit: BoxFit.cover,
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
                  ),
            ),
          ),
          const Gap(10),
          MovieRating(
            rating: movie.voteAverage,
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
