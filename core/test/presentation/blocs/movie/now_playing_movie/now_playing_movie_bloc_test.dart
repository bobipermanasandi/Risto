import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:core/presentation/blocs/movie/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../../dummy_data/movie/dummy_objects.dart';
import 'now_playing_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMovieBloc nowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  final tMovieList = <Movie>[testMovie];

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc = NowPlayingMovieBloc(mockGetNowPlayingMovies);
  });

  group('Now Playing Movies Bloc === ', () {
    test('initial state should be empty', () {
      expect(nowPlayingMoviesBloc.state, NowPlayingMovieEmpty());
    });

    blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'Should emit [Loading, Empty] when get now playing movies is empty',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => const Right([]));
        return nowPlayingMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      wait: const Duration(milliseconds: 100),
      expect: () => [NowPlayingMovieLoading(), NowPlayingMovieEmpty()],
      verify: (bloc) => verify(mockGetNowPlayingMovies.execute()),
    );

    blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'Should emit [Loading, HasData] when get now playing movies is gotten succesfully',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return nowPlayingMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        NowPlayingMovieLoading(),
        NowPlayingMovieHasData(tMovieList),
      ],
      verify: (bloc) => verify(mockGetNowPlayingMovies.execute()),
    );

    blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'Should emit [Loading, Error] when get now playing movies is unsuccessful',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return nowPlayingMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        NowPlayingMovieLoading(),
        NowPlayingMovieError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetNowPlayingMovies.execute()),
    );
  });
}
