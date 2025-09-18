import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/tv_series/search_tv_series.dart';
import 'package:search/presentation/blocs/tv_series/search_tv_series_bloc.dart';

import 'search_tv_series_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late SearchTvSeriesBloc searchTvSeriesBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    searchTvSeriesBloc = SearchTvSeriesBloc(mockSearchTvSeries);
  });

  final testTvSeries = TvSeries(
    backdropPath: "/image.jpg",
    firstAirDate: "2023-09-20",
    genreIds: const [1, 2],
    id: 1,
    name: "name",
    popularity: 111.111,
    posterPath: "/xxxx.jpg",
    originCountry: const ["OC"],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "",
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeriesList = <TvSeries>[testTvSeries];
  const tQuery = 'jujutsu';

  group('Search Tv Series Bloc === ', () {
    test('initial state should be empty', () {
      expect(searchTvSeriesBloc.state, SearchTvSeriesInitial());
    });

    blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
      'Should emit [Loading, HasData] when data search tv series is gotten successfully',
      build: () {
        when(
          mockSearchTvSeries.execute(tQuery),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return searchTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchTvSeriesLoading(),
        SearchTvSeriesHasData(tTvSeriesList),
      ],
      verify: (bloc) => verify(mockSearchTvSeries.execute(tQuery)),
    );

    blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
      'Should emit [Loading, Empty] when data search tv series is empty',
      build: () {
        when(
          mockSearchTvSeries.execute(tQuery),
        ).thenAnswer((_) async => Right([]));
        return searchTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [SearchTvSeriesLoading(), SearchTvSeriesEmpty()],
      verify: (bloc) => verify(mockSearchTvSeries.execute(tQuery)),
    );

    blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
      'Should emit [Loading, Error] when get search tv series is unsuccessful',
      build: () {
        when(
          mockSearchTvSeries.execute(tQuery),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return searchTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchTvSeriesLoading(),
        SearchTvSeriesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      },
    );
  });
}
