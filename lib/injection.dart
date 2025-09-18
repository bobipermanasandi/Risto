import 'package:core/common/http_ssl_pinning.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie/movie_local_data_source.dart';
import 'package:core/data/datasources/movie/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_series/tv_series_local_data_source.dart';
import 'package:core/data/datasources/tv_series/tv_series_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_series_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:core/domain/usecases/movie/get_movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:core/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:core/domain/usecases/movie/get_watchlist_status.dart';
import 'package:core/domain/usecases/movie/remove_watchlist.dart';
import 'package:core/domain/usecases/movie/save_watchlist.dart';
import 'package:core/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:core/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_watchlist_tv_series_status.dart';
import 'package:core/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:core/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:core/presentation/blocs/movie/detail_movie/detail_movie_bloc.dart';
import 'package:core/presentation/blocs/movie/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:core/presentation/blocs/movie/popular_movie/popular_movie_bloc.dart';
import 'package:core/presentation/blocs/movie/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:core/presentation/blocs/movie/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:core/presentation/blocs/tv_series/detail_tv_series/detail_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/now_playing_tv_series/now_playing_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:search/domain/usecases/movie/search_movies.dart';
import 'package:search/domain/usecases/tv_series/search_tv_series.dart';
import 'package:search/presentation/blocs/movie/search_movie_bloc.dart';
import 'package:search/presentation/blocs/tv_series/search_tv_series_bloc.dart';

final locator = GetIt.instance;

void init() {
  // provider Movie
  locator.registerFactory(() => NowPlayingMovieBloc(locator()));
  locator.registerFactory(() => PopularMovieBloc(locator()));
  locator.registerFactory(() => TopRatedMovieBloc(locator()));
  locator.registerFactory(() => WatchlistMovieBloc(locator()));
  locator.registerFactory(
    () => DetailMovieBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListMovieStatus: locator(),
      saveWatchlistMovie: locator(),
      removeWatchlistMovie: locator(),
    ),
  );
  locator.registerFactory(() => SearchMovieBloc(locator()));

  // provider Tv Series
  locator.registerFactory(() => NowPlayingTvSeriesBloc(locator()));
  locator.registerFactory(() => PopularTvSeriesBloc(locator()));
  locator.registerFactory(() => TopRatedTvSeriesBloc(locator()));
  locator.registerFactory(() => WatchlistTvSeriesBloc(locator()));
  locator.registerFactory(
    () => DetailTvSeriesBloc(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getWatchListTvSeriesStatus: locator(),
      saveWatchlistTvSeries: locator(),
      removeWatchlistTvSeries: locator(),
    ),
  );
  locator.registerFactory(() => SearchTvSeriesBloc(locator()));

  // use case Movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));

  // use case Tv Series
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListTvSeriesStatus(locator()));

  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));

  // repository movie
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // repository tv series
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources movie
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );

  // data sources tv series
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
    () => TvSeriesRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
    () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => HttpSslPinning.client);
}
