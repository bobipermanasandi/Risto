import 'package:dartz/dartz.dart';
import 'package:risto/common/failure.dart';
import 'package:risto/domain/entities/tv_series/tv_series_detail.dart';
import 'package:risto/domain/repositories/tv_series_repository.dart';

class RemoveWatchlistTvSeries {
  final TvSeriesRepository repository;

  RemoveWatchlistTvSeries(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail tvSeries) {
    return repository.removeWatchlistTvSeries(tvSeries);
  }
}
