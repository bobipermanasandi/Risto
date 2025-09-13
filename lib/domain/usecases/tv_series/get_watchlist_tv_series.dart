import 'package:dartz/dartz.dart';
import 'package:risto/common/failure.dart';
import 'package:risto/domain/entities/tv_series/tv_series.dart';
import 'package:risto/domain/repositories/tv_series_repository.dart';

class GetWatchlistTvSeries {
  final TvSeriesRepository _repository;

  GetWatchlistTvSeries(this._repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return _repository.getWatchlistTvSeries();
  }
}
