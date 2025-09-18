import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies _getPopularMovies;
  PopularMovieBloc(this._getPopularMovies) : super(PopularMovieEmpty()) {
    on<FetchPopularMovies>(_onFetchPopularMovies);
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMovies event,
    Emitter<PopularMovieState> emit,
  ) async {
    emit(PopularMovieLoading());

    final result = await _getPopularMovies.execute();

    result.fold((failure) => emit(PopularMovieError(failure.message)), (data) {
      if (data.isEmpty) {
        emit(PopularMovieEmpty());
      } else {
        emit(PopularMovieHasData(data));
      }
    });
  }
}
