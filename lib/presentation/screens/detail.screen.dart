import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mopen_test/domain/models/movie.model.dart';

import '../../bloc/app_bloc.dart';
import '../widgets/home_screen_widgets/star_rating.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 561,
            child: Stack(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500/${widget.movie.posterPath}',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (e, o, s) {
                    return Image.asset(
                      'assets/icons/coming_soon.png',
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(1.0),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 351,
                        child: Text(
                          widget.movie.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: true,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              (widget.movie.voteAverage / 2).toStringAsFixed(1),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          const Gap(10),
                          StarRating(
                            rating: double.parse(
                              (widget.movie.voteAverage / 2).toStringAsFixed(1),
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          ...widget.movie.genres.map(
                            (e) => Text(
                              '$e, ',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 80,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: SvgPicture.asset(
                      'assets/icons/back_button.svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.none,
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      final _ = BlocProvider.of<AppBloc>(context).add(
                        FavoriteHandler(movie: widget.movie),
                      );
                    },
                    icon: SvgPicture.asset(
                      widget.movie.isFavorite
                          ? 'assets/icons/bookmark_active_icon.svg'
                          : 'assets/icons/bookmark_disable_icon.svg',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              widget.movie.overview.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 50,
              softWrap: true,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
