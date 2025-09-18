part of 'search_tv_series_bloc.dart';

@immutable
abstract class SearchTvSeriesState extends Equatable {
  const SearchTvSeriesState();

  @override
  List<Object> get props => [];
}

class SearchTvSeriesInitial extends SearchTvSeriesState {}

class SearchTvSeriesEmpty extends SearchTvSeriesState {}

class SearchTvSeriesLoading extends SearchTvSeriesState {}

class SearchTvSeriesError extends SearchTvSeriesState {
  final String message;

  SearchTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchTvSeriesHasData extends SearchTvSeriesState {
  final List<TvSeries> result;

  SearchTvSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
