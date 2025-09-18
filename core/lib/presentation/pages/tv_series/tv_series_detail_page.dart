import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/entities/tv_series/tv_series_detail.dart';
import 'package:core/presentation/blocs/tv_series/detail_tv_series/detail_tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvSeriesDetailPage extends StatefulWidget {
  final int id;
  const TvSeriesDetailPage({super.key, required this.id});

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<DetailTvSeriesBloc>().add(FetchDetailTvSeries(widget.id));
        context.read<DetailTvSeriesBloc>().add(
          LoadWatchlistStatusTvSeries(widget.id),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DetailTvSeriesBloc, DetailTvSeriesState>(
        listener: (context, state) {
          final message = state.watchlistMessage;
          if (message == DetailTvSeriesBloc.watchlistAddSuccessMessage ||
              message == DetailTvSeriesBloc.watchlistRemoveSuccessMessage) {
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
          final movieDetailState = state.tvSeriesDetailState;
          if (movieDetailState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieDetailState == RequestState.loaded) {
            return SafeArea(
              child: DetailContent(
                tvSeries: state.tvSeriesDetail!,
                recommendations: state.tvSeriesRecommendations,
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
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;
  const DetailContent({
    super.key,
    required this.tvSeries,
    required this.recommendations,
    required this.isAddedWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
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
                            Text(tvSeries.name, style: kHeading5),
                            FilledButton(
                              key: const Key('watchlistButton-tvseries'),
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context.read<DetailTvSeriesBloc>().add(
                                    AddWatchlistTvSeries(tvSeries),
                                  );
                                } else {
                                  context.read<DetailTvSeriesBloc>().add(
                                    RemoveFromWatchlistTvSeries(tvSeries),
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
                            Text(_showGenres(tvSeries.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: kMikadoYellow),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(tvSeries.overview),
                            SizedBox(height: 16),
                            Text('Seasons', style: kHeading6),
                            SizedBox(
                              height: 200,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: tvSeries.seasons.map((season) {
                                  return SizedBox(
                                    width: 100,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${season.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                // coverage:ignore-start
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                // coverage:ignore-end
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              season.name,
                                              style: kSubtitle,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              'Episode: ${season.episodeCount}',
                                              style: kBodyText,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Text('Recommendations', style: kHeading6),
                            BlocBuilder<
                              DetailTvSeriesBloc,
                              DetailTvSeriesState
                            >(
                              builder: (context, state) {
                                final recommendationsState =
                                    state.tvSeriesRecommendationsState;
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
                                                detailTvSeriesRoute,
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
}
