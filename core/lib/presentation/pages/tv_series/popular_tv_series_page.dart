import 'package:core/presentation/blocs/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:core/presentation/widgets/tv_series_card.dart';

class PopularTvSeriesPage extends StatefulWidget {
  const PopularTvSeriesPage({super.key});

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeries());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular Tv Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
          builder: (_, state) {
            if (state is PopularTvSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PopularTvSeriesHasData) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final tv = state.result[index];
                  return TvSeriesCard(tvSeries: tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is PopularTvSeriesError) {
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
