import 'package:core/presentation/blocs/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils.dart';
import 'package:flutter/material.dart';
import 'package:core/presentation/widgets/tv_series_card.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  const WatchlistTvSeriesPage({super.key});

  @override
  State<WatchlistTvSeriesPage> createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeries());
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  // coverage:ignore-start
  @override
  void didPopNext() {
    context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeries());
  }
  // coverage:ignore-end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist Tv Series'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
          builder: (_, state) {
            if (state is WatchlistTvSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WatchlistTvSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvSeriesCard(tvSeries: tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is WatchlistTvSeriesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility_off, size: 32),
                    SizedBox(height: 2),
                    Text('Empty Watchlist'),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
