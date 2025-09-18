import 'package:core/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;
  WatchlistMovieBloc(this._getWatchlistMovies) : super(WatchlistMovieEmpty()) {
    on<WatchlistMovieEvent>(_onWatchlistMovieEvent);
  }

  Future<void> _onWatchlistMovieEvent(
    WatchlistMovieEvent event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    emit(WatchlistMovieLoading());

    final result = await _getWatchlistMovies.execute();

    result.fold((failure) => emit(WatchlistMovieError(failure.message)), (
      data,
    ) {
      if (data.isEmpty) {
        emit(WatchlistMovieEmpty());
      } else {
        emit(WatchlistMovieHasData(data));
      }
    });
  }
}
