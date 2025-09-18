import 'package:core/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tv_series_event.dart';
part 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries _getTopRatedTvSeries;
  TopRatedTvSeriesBloc(this._getTopRatedTvSeries)
    : super(TopRatedTvSeriesEmpty()) {
    on<TopRatedTvSeriesEvent>(_onTopRatedTvSeriesEvent);
  }

  Future<void> _onTopRatedTvSeriesEvent(
    TopRatedTvSeriesEvent event,
    Emitter<TopRatedTvSeriesState> emit,
  ) async {
    emit(TopRatedTvSeriesLoading());

    final result = await _getTopRatedTvSeries.execute();

    result.fold((failure) => emit(TopRatedTvSeriesError(failure.message)), (
      data,
    ) {
      if (data.isEmpty) {
        emit(TopRatedTvSeriesEmpty());
      } else {
        emit(TopRatedTvSeriesHasData(data));
      }
    });
  }
}
