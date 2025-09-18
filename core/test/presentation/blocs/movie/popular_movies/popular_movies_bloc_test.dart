import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:core/presentation/blocs/movie/popular_movie/popular_movie_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/movie/dummy_objects.dart';
import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMovieBloc popularMovieBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(mockGetPopularMovies);
  });

  final tMoviesList = <Movie>[testMovie];

  group('Popular Movies Bloc === ', () {
    test('initial state should be empty', () {
      expect(popularMovieBloc.state, PopularMovieEmpty());
    });

    blocTest<PopularMovieBloc, PopularMovieState>(
      'Should emit [Loading, Empty] when get popular movies is empty',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => const Right([]));
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      wait: const Duration(milliseconds: 100),
      expect: () => [PopularMovieLoading(), PopularMovieEmpty()],
      verify: (bloc) => verify(mockGetPopularMovies.execute()),
    );

    blocTest<PopularMovieBloc, PopularMovieState>(
      'Should emit [Loading, HasData] when get popular movies is gotten successfully',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(tMoviesList));
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      wait: const Duration(milliseconds: 100),
      expect: () => [PopularMovieLoading(), PopularMovieHasData(tMoviesList)],
      verify: (bloc) => verify(mockGetPopularMovies.execute()),
    );

    blocTest<PopularMovieBloc, PopularMovieState>(
      'Should emit [Loading, Error] when get popular movies is unsuccessful',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        PopularMovieLoading(),
        PopularMovieError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetPopularMovies.execute()),
    );
  });
}
