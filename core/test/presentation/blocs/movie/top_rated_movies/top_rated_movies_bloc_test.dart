import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:core/presentation/blocs/movie/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/movie/dummy_objects.dart';
import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMovieBloc topRatedMovieBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMovieBloc = TopRatedMovieBloc(mockGetTopRatedMovies);
  });

  final tMoviesList = <Movie>[testMovie];

  group('Top Rated Movies -->', () {
    test('initial state should be empty', () {
      expect(topRatedMovieBloc.state, TopRatedMovieEmpty());
    });

    blocTest<TopRatedMovieBloc, TopRatedMovieState>(
      'Should emit [Loading, Empty] when get top rated movies is empty',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => const Right([]));
        return topRatedMovieBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      wait: const Duration(milliseconds: 100),
      expect: () => [TopRatedMovieLoading(), TopRatedMovieEmpty()],
      verify: (bloc) => verify(mockGetTopRatedMovies.execute()),
    );

    blocTest<TopRatedMovieBloc, TopRatedMovieState>(
      'Should emit [Loading, HasData] when get top rated movies is gotten successfully',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(tMoviesList));
        return topRatedMovieBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      wait: const Duration(milliseconds: 100),
      expect: () => [TopRatedMovieLoading(), TopRatedMovieHasData(tMoviesList)],
      verify: (bloc) => verify(mockGetTopRatedMovies.execute()),
    );

    blocTest<TopRatedMovieBloc, TopRatedMovieState>(
      'Should emit [Loading, Error] when get top rated movies is unsuccessful',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return topRatedMovieBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedMovieLoading(),
        TopRatedMovieError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTopRatedMovies.execute()),
    );
  });
}
