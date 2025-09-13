import 'package:dartz/dartz.dart';
import 'package:risto/common/failure.dart';
import 'package:risto/domain/entities/movie/movie_detail.dart';
import 'package:risto/domain/repositories/movie_repository.dart';

class SaveWatchlist {
  final MovieRepository repository;

  SaveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
