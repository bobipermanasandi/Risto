import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/routes.dart';
import 'package:core/presentation/blocs/movie/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:core/presentation/blocs/movie/popular_movie/popular_movie_bloc.dart';
import 'package:core/presentation/blocs/movie/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/constants.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:flutter/material.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<NowPlayingMovieBloc>().add(FetchNowPlayingMovies());
        context.read<PopularMovieBloc>().add(FetchPopularMovies());
        context.read<TopRatedMovieBloc>().add(FetchTopRatedMovies());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Now Playing', style: kHeading6),
            BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
              builder: (_, state) {
                if (state is NowPlayingMovieLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NowPlayingMovieHasData) {
                  return MovieList(state.result);
                } else {
                  return const Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, popularMovieRoute),
            ),
            BlocBuilder<PopularMovieBloc, PopularMovieState>(
              builder: (_, state) {
                if (state is PopularMovieLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PopularMovieHasData) {
                  return MovieList(state.result);
                } else {
                  return const Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, topRatedMovieRoute),
            ),
            BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
              builder: (_, state) {
                if (state is TopRatedMovieLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TopRatedMovieHasData) {
                  return MovieList(state.result);
                } else {
                  return const Text('Failed');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: const Key('movieOnTap'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  detailMovieRoute,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
