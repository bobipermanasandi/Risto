import 'package:core/presentation/blocs/movie/popular_movie/popular_movie_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';

class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PopularMovieBloc>().add(FetchPopularMovies());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieBloc, PopularMovieState>(
          builder: (_, state) {
            if (state is PopularMovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PopularMovieHasData) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final movie = state.result[index];
                  return MovieCard(movie: movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is PopularMovieError) {
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
