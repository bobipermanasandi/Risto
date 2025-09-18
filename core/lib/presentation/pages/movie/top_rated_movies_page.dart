import 'package:core/presentation/blocs/movie/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';

class TopRatedMoviesPage extends StatefulWidget {
  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TopRatedMovieBloc>().add(FetchTopRatedMovies());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
          builder: (_, state) {
            if (state is TopRatedMovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedMovieHasData) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final movie = state.result[index];
                  return MovieCard(movie: movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is TopRatedMovieError) {
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
