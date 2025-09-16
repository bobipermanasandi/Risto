import 'package:dartz/dartz.dart';
import '../../../common/failure.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}
