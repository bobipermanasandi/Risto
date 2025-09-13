import 'package:dartz/dartz.dart';
import 'package:risto/domain/entities/movie/movie.dart';
import 'package:risto/domain/repositories/movie_repository.dart';
import 'package:risto/common/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
