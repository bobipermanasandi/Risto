import 'package:core/core.dart';
import 'package:core/presentation/widgets/tv_series_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:search/presentation/blocs/tv_series/search_tv_series_bloc.dart';

class SearchTvSeriesPage extends StatelessWidget {
  const SearchTvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Tv Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchTvSeriesBloc>().add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title Tv Series',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<SearchTvSeriesBloc, SearchTvSeriesState>(
              builder: (context, state) {
                if (state is SearchTvSeriesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SearchTvSeriesHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final TvSeries = result[index];
                        return TvSeriesCard(tvSeries: TvSeries);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchTvSeriesEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: 200),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            'No Result',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Sorry, there no results for this search,\n please try another phase',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is SearchTvSeriesError) {
                  return Expanded(
                    child: Center(
                      child: Text(key: Key('error_message'), state.message),
                    ),
                  );
                } else {
                  return Expanded(child: Container());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
