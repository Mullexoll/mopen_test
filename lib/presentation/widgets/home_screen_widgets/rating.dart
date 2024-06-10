import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:tmdb_project/constants/rating_colors_consts.dart';

class MovieRating extends StatelessWidget {
  final double rating;
  final double size;

  const MovieRating({
    super.key,
    required this.rating,
    this.size = 20.0,
  });

  Color getColorForRating(double rating) {
    rating = rating.clamp(0.0, 10.0);

    int colorIndex =
        (rating / 10.0 * (RatingColorsConsts.ratingColors.length - 1)).round();

    return RatingColorsConsts.ratingColors[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/rating_icon.svg',
          width: size,
          height: size,
          // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        const Gap(10),
        Text(
          rating.toStringAsFixed(2),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: getColorForRating(rating),
              ),
        ),
      ],
    );
  }
}
