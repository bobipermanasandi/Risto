part of 'popular_movie_bloc.dart';

abstract class PopularMovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularMovieEmpty extends PopularMovieState {}

class PopularMovieLoading extends PopularMovieState {}

class PopularMovieHasData extends PopularMovieState {
  final List<Movie> result;

  PopularMovieHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class PopularMovieError extends PopularMovieState {
  final String message;

  PopularMovieError(this.message);

  @override
  List<Object?> get props => [message];
}
