import 'package:core/presentation/blocs/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:core/presentation/widgets/tv_series_card.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  const TopRatedTvSeriesPage({super.key});

  @override
  State<TopRatedTvSeriesPage> createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Tv Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
          builder: (_, state) {
            if (state is TopRatedTvSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTvSeriesHasData) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final tv = state.result[index];
                  return TvSeriesCard(tvSeries: tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is TopRatedTvSeriesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(child: Text('Empty data'));
            }
          },
        ),
      ),
    );
  }
}
