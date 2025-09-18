import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;
  TopRatedMovieBloc(this._getTopRatedMovies) : super(TopRatedMovieEmpty()) {
    on<TopRatedMovieEvent>(_onTopRatedMovieEvent);
  }

  Future<void> _onTopRatedMovieEvent(
    TopRatedMovieEvent event,
    Emitter<TopRatedMovieState> emit,
  ) async {
    emit(TopRatedMovieLoading());

    final result = await _getTopRatedMovies.execute();

    result.fold((failure) => emit(TopRatedMovieError(failure.message)), (data) {
      if (data.isEmpty) {
        emit(TopRatedMovieEmpty());
      } else {
        emit(TopRatedMovieHasData(data));
      }
    });
  }
}
