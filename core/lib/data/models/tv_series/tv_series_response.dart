import 'package:equatable/equatable.dart';
import 'package:core/data/models/tv_series/tv_series_model.dart';

class TvSeriesResponse extends Equatable {
  final List<TvSeriesModel> tvSeriesList;

  const TvSeriesResponse({required this.tvSeriesList});

  factory TvSeriesResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesResponse(
        tvSeriesList: List<TvSeriesModel>.from(
          (json['results'] as List)
              .map((x) => TvSeriesModel.fromJson(x))
              .where(
                (element) =>
                    element.posterPath != null && element.overview != '',
              ),
        ),
      );

  // coverage:ignore-start
  Map<String, dynamic> toJson() => {
    'results': List<dynamic>.from(tvSeriesList.map((x) => x.toJson())),
  };
  // coverage:ignore-end

  @override
  List<Object?> get props => [tvSeriesList];
}
