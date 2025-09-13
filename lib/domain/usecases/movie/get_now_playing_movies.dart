import 'package:dartz/dartz.dart';
import 'package:risto/domain/entities/movie/movie.dart';
import 'package:risto/domain/repositories/movie_repository.dart';
import 'package:risto/common/failure.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowPlayingMovies();
  }
}
