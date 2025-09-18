import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/entities/movie/movie_detail.dart';
import 'package:core/presentation/blocs/movie/detail_movie/detail_movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<DetailMovieBloc>().add(FetchDetailMovie(widget.id));
        context.read<DetailMovieBloc>().add(
          LoadWatchlistStatusMovie(widget.id),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DetailMovieBloc, DetailMovieState>(
        listener: (context, state) {
          final message = state.watchlistMessage;
          if (message == DetailMovieBloc.watchlistAddSuccessMessage ||
              message == DetailMovieBloc.watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          } else {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(content: Text(message));
              },
            );
          }
        },
        listenWhen: (oldState, newState) {
          return oldState.watchlistMessage != newState.watchlistMessage &&
              newState.watchlistMessage != '';
        },
        builder: (_, state) {
          final movieDetailState = state.movieDetailState;
          if (movieDetailState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieDetailState == RequestState.loaded) {
            return SafeArea(
              child: DetailContent(
                movieDetail: state.movieDetail!,
                recommendations: state.movieRecommendations,
                isAddedWatchlist: state.isAddedToWatchlist,
              ),
            );
          } else if (movieDetailState == RequestState.error) {
            return Center(child: Text(state.message));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movieDetail;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;
  const DetailContent({
    super.key,
    required this.movieDetail,
    required this.recommendations,
    required this.isAddedWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${movieDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          // coverage:ignore-start
          errorWidget: (context, url, error) => Icon(Icons.error),
          // coverage:ignore-end
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movieDetail.title, style: kHeading5),
                            FilledButton(
                              key: const Key('watchlistButton-movie'),
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context.read<DetailMovieBloc>().add(
                                    AddWatchlistMovie(movieDetail),
                                  );
                                } else {
                                  context.read<DetailMovieBloc>().add(
                                    RemoveFromWatchlistMovie(movieDetail),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(movieDetail.genres)),
                            Text(_showDuration(movieDetail.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movieDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: kMikadoYellow),
                                  itemSize: 24,
                                ),
                                Text('${movieDetail.voteAverage}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(movieDetail.overview),
                            SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            BlocBuilder<DetailMovieBloc, DetailMovieState>(
                              builder: (context, state) {
                                final recommendationsState =
                                    state.movieRecommendationsState;
                                if (recommendationsState ==
                                    RequestState.loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (recommendationsState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            // coverage:ignore-start
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                detailMovieRoute,
                                                arguments: movie.id,
                                              );
                                            },
                                            // coverage:ignore-end
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$baseImageUrl${movie.posterPath}',
                                                placeholder: (_, __) =>
                                                    const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                // coverage:ignore-start
                                                errorWidget: (_, __, ___) =>
                                                    const Icon(Icons.error),
                                                // coverage:ignore-end
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else if (recommendationsState ==
                                    RequestState.error) {
                                  return Text(state.message);
                                } else {
                                  return const Text('No Recommendations');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              key: const Key('iconBack'),
              icon: Icon(Icons.arrow_back),
              // coverage:ignore-start
              onPressed: () {
                Navigator.pop(context);
              },
              // coverage:ignore-end
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      // coverage:ignore-start
      return '${minutes}m';
      // coverage:ignore-end
    }
  }
}
