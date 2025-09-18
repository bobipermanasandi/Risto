import 'package:core/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_tv_series_event.dart';
part 'now_playing_tv_series_state.dart';

class NowPlayingTvSeriesBloc
    extends Bloc<NowPlayingTvSeriesEvent, NowPlayingTvSeriesState> {
  final GetNowPlayingTvSeries _getNowPlayingTvSeries;
  NowPlayingTvSeriesBloc(this._getNowPlayingTvSeries)
    : super(NowPlayingTvSeriesEmpty()) {
    on<NowPlayingTvSeriesEvent>(_onNowPlayingTvSeriesEvent);
  }

  Future<void> _onNowPlayingTvSeriesEvent(
    NowPlayingTvSeriesEvent event,
    Emitter<NowPlayingTvSeriesState> emit,
  ) async {
    emit(NowPlayingTvSeriesLoading());

    final result = await _getNowPlayingTvSeries.execute();

    result.fold((failure) => emit(NowPlayingTvSeriesError(failure.message)), (
      data,
    ) {
      if (data.isEmpty) {
        emit(NowPlayingTvSeriesEmpty());
      } else {
        emit(NowPlayingTvSeriesHasData(data));
      }
    });
  }
}
