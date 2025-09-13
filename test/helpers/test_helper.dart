import 'package:risto/data/datasources/db/database_helper.dart';
import 'package:risto/data/datasources/movie/movie_local_data_source.dart';
import 'package:risto/data/datasources/movie/movie_remote_data_source.dart';
import 'package:risto/data/datasources/tv_series/tv_series_local_data_source.dart';
import 'package:risto/data/datasources/tv_series/tv_series_remote_data_source.dart';
import 'package:risto/domain/repositories/movie_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:risto/domain/repositories/tv_series_repository.dart';

@GenerateMocks(
  [
    MovieRepository,
    MovieRemoteDataSource,
    MovieLocalDataSource,
    TvSeriesRepository,
    TvSeriesRemoteDataSource,
    TvSeriesLocalDataSource,
    DatabaseHelper,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
