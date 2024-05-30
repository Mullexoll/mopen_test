import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 26.0,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.2;

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(
          SvgPicture.asset(
            'assets/icons/full_star.svg',
            width: size,
            height: size,
          ),
        );
      } else if (i == fullStars && hasHalfStar) {
        stars.add(
          SvgPicture.asset(
            'assets/icons/half_star.svg',
            width: size + 4,
            height: size + 4,
          ),
        );
      } else {
        stars.add(
          SvgPicture.asset(
            'assets/icons/empty_star.svg',
            width: size,
            height: size,
          ),
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: stars,
    );
  }
}
