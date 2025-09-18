part of 'now_playing_movie_bloc.dart';

abstract class NowPlayingMovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NowPlayingMovieEmpty extends NowPlayingMovieState {}

class NowPlayingMovieLoading extends NowPlayingMovieState {}

class NowPlayingMovieHasData extends NowPlayingMovieState {
  final List<Movie> result;

  NowPlayingMovieHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class NowPlayingMovieError extends NowPlayingMovieState {
  final String message;

  NowPlayingMovieError(this.message);

  @override
  List<Object?> get props => [message];
}
