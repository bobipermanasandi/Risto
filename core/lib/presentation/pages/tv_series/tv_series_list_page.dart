import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/presentation/blocs/tv_series/now_playing_tv_series/now_playing_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';

class TvSeriesListPage extends StatefulWidget {
  const TvSeriesListPage({super.key});

  @override
  State<TvSeriesListPage> createState() => _TvSeriesListPageState();
}

class _TvSeriesListPageState extends State<TvSeriesListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<NowPlayingTvSeriesBloc>().add(FetchNowPlayingTvSeries());
        context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeries());
        context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries());
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
            BlocBuilder<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
              builder: (_, state) {
                if (state is NowPlayingTvSeriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NowPlayingTvSeriesHasData) {
                  return TvSeriesList(state.result);
                } else if (state is NowPlayingTvSeriesError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Failed'));
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, popularTvSeriesRoute),
            ),
            BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
              builder: (_, state) {
                if (state is PopularTvSeriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PopularTvSeriesHasData) {
                  return TvSeriesList(state.result);
                } else if (state is PopularTvSeriesError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Failed'));
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, topRatedTvSeriesRoute),
            ),
            BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
              builder: (_, state) {
                if (state is TopRatedTvSeriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TopRatedTvSeriesHasData) {
                  return TvSeriesList(state.result);
                } else if (state is TopRatedTvSeriesError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Failed'));
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

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesList(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: const Key('tvSeriesOnTap'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  detailTvSeriesRoute,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
