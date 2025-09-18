import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_movie_event.dart';
part 'now_playing_movie_state.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  NowPlayingMovieBloc(this._getNowPlayingMovies)
    : super(NowPlayingMovieEmpty()) {
    on<NowPlayingMovieEvent>(_onNowPlayingMovieEvent);
  }

  Future<void> _onNowPlayingMovieEvent(
    NowPlayingMovieEvent event,
    Emitter<NowPlayingMovieState> emit,
  ) async {
    emit(NowPlayingMovieLoading());

    final result = await _getNowPlayingMovies.execute();

    result.fold((failure) => emit(NowPlayingMovieError(failure.message)), (
      data,
    ) {
      if (data.isEmpty) {
        emit(NowPlayingMovieEmpty());
      } else {
        emit(NowPlayingMovieHasData(data));
      }
    });
  }
}
