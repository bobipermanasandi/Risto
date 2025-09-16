import '../../../common/state_enum.dart';
import 'package:core/presentation/provider/tv_series/top_rated_tv_series_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        Provider.of<TopRatedTvSeriesNotifier>(
          context,
          listen: false,
        ).fetchTopRatedTvSeries();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Tv Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tvSeries[index];
                  return TvSeriesCard(tvSeries: tv);
                },
                itemCount: data.tvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
