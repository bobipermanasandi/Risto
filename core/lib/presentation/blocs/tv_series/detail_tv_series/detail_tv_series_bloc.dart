import 'package:core/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:core/domain/usecases/tv_series/get_watchlist_tv_series_status.dart';
import 'package:core/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:core/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/entities/tv_series/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

part 'detail_tv_series_event.dart';
part 'detail_tv_series_state.dart';

class DetailTvSeriesBloc
    extends Bloc<DetailTvSeriesEvent, DetailTvSeriesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;
  final GetWatchListTvSeriesStatus getWatchListTvSeriesStatus;
  DetailTvSeriesBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
    required this.getWatchListTvSeriesStatus,
  }) : super(DetailTvSeriesState.initial()) {
    on<FetchDetailTvSeries>(_onFetchDetailTvSeries);
    on<AddWatchlistTvSeries>(_onAddWatchlistTvSeries);
    on<RemoveFromWatchlistTvSeries>(_onRemoveFromWatchlistTvSeries);
    on<LoadWatchlistStatusTvSeries>(_onLoadWatchlistStatusTvSeries);
  }

  Future<void> _onFetchDetailTvSeries(
    FetchDetailTvSeries event,
    Emitter<DetailTvSeriesState> emit,
  ) async {
    emit(state.copyWith(tvSeriesDetailState: RequestState.loading));

    final id = event.id;

    final detailtvSeriesResult = await getTvSeriesDetail.execute(id);
    final recommendationtvSeriessResult = await getTvSeriesRecommendations
        .execute(id);

    detailtvSeriesResult.fold(
      (failure) => emit(
        state.copyWith(
          tvSeriesDetailState: RequestState.error,
          message: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            tvSeriesRecommendationsState: RequestState.loading,
            tvSeriesDetailState: RequestState.loaded,
            tvSeriesDetail: success,
          ),
        );
        recommendationtvSeriessResult.fold(
          (failure) => emit(
            state.copyWith(
              tvSeriesRecommendationsState: RequestState.error,
              message: failure.message,
            ),
          ),
          (tvSeriesRecommendations) {
            if (tvSeriesRecommendations.isEmpty) {
              emit(
                state.copyWith(
                  tvSeriesRecommendationsState: RequestState.empty,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  tvSeriesRecommendationsState: RequestState.loaded,
                  tvSeriesRecommendations: tvSeriesRecommendations,
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _onAddWatchlistTvSeries(
    AddWatchlistTvSeries event,
    Emitter<DetailTvSeriesState> emit,
  ) async {
    final tvSeriesDetail = event.tvSeriesDetail;
    final result = await saveWatchlistTvSeries.execute(tvSeriesDetail);

    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (success) => emit(state.copyWith(watchlistMessage: success)),
    );

    add(LoadWatchlistStatusTvSeries(tvSeriesDetail.id));
  }

  Future<void> _onRemoveFromWatchlistTvSeries(
    RemoveFromWatchlistTvSeries event,
    Emitter<DetailTvSeriesState> emit,
  ) async {
    final tvSeriesDetail = event.tvSeriesDetail;
    final result = await removeWatchlistTvSeries.execute(tvSeriesDetail);

    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (success) => emit(state.copyWith(watchlistMessage: success)),
    );

    add(LoadWatchlistStatusTvSeries(tvSeriesDetail.id));
  }

  Future<void> _onLoadWatchlistStatusTvSeries(
    LoadWatchlistStatusTvSeries event,
    Emitter<DetailTvSeriesState> emit,
  ) async {
    final status = await getWatchListTvSeriesStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }
}
