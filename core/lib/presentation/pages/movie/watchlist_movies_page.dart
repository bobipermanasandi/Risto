import 'package:core/presentation/blocs/movie/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils.dart';
import 'package:core/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';

class WatchlistMoviesPage extends StatefulWidget {
  const WatchlistMoviesPage({super.key});

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
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
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
  }
  // coverage:ignore-end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Watchlist Movie'),
        leading: IconButton(
          key: const Key('iconBack-movie'),
          icon: Icon(Icons.arrow_back),
          // coverage:ignore-start
          onPressed: () {
            Navigator.pop(context);
          },
          // coverage:ignore-end
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
          builder: (_, state) {
            if (state is WatchlistMovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WatchlistMovieHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie: movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is WatchlistMovieError) {
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
