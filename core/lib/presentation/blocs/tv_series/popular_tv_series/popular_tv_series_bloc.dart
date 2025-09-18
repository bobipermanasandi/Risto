import 'package:core/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_series_event.dart';
part 'popular_tv_series_state.dart';

class PopularTvSeriesBloc
    extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries _getPopularTvSeries;
  PopularTvSeriesBloc(this._getPopularTvSeries)
    : super(PopularTvSeriesEmpty()) {
    on<PopularTvSeriesEvent>(_onPopularTvSeriesEvent);
  }

  Future<void> _onPopularTvSeriesEvent(
    PopularTvSeriesEvent event,
    Emitter<PopularTvSeriesState> emit,
  ) async {
    emit(PopularTvSeriesLoading());

    final result = await _getPopularTvSeries.execute();

    result.fold((failure) => emit(PopularTvSeriesError(failure.message)), (
      data,
    ) {
      if (data.isEmpty) {
        emit(PopularTvSeriesEmpty());
      } else {
        emit(PopularTvSeriesHasData(data));
      }
    });
  }
}
