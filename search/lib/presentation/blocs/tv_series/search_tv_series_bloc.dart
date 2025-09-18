import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecases/tv_series/search_tv_series.dart';

part 'search_tv_series_event.dart';
part 'search_tv_series_state.dart';

class SearchTvSeriesBloc
    extends Bloc<SearchTvSeriesEvent, SearchTvSeriesState> {
  final SearchTvSeries _searchTvSeries;
  SearchTvSeriesBloc(this._searchTvSeries) : super(SearchTvSeriesInitial()) {
    on<OnQueryChanged>(
      (_onOnQueryChanged),
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onOnQueryChanged(
    OnQueryChanged event,
    Emitter<SearchTvSeriesState> emit,
  ) async {
    final query = event.query;

    emit(SearchTvSeriesLoading());
    final result = await _searchTvSeries.execute(query);

    result.fold(
      (failure) {
        emit(SearchTvSeriesError(failure.message));
      },
      (data) {
        (data.isEmpty)
            ? emit(SearchTvSeriesEmpty())
            : emit(SearchTvSeriesHasData(data));
      },
    );
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
