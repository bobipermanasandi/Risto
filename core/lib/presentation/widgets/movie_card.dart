import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        // coverage:ignore-start
        onTap: () {
          Navigator.pushNamed(context, detailMovieRoute, arguments: movie.id);
        },
        // coverage:ignore-end
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    SizedBox(height: 16),
                    Text(
                      movie.overview ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  width: 80,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  // coverage:ignore-start
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  // coverage:ignore-end
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
