import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/blocs/movie/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:core/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/movie/dummy_objects.dart';

class MockWatchlistMoviesBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class FakeWatchlistMoviesEvent extends Fake implements WatchlistMovieEvent {}

class FakeWatchlistMoviesState extends Fake implements WatchlistMovieState {}

void main() {
  late MockWatchlistMoviesBloc mockWatchlistMoviesBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistMoviesEvent());
    registerFallbackValue(FakeWatchlistMoviesState());
  });

  setUp(() {
    mockWatchlistMoviesBloc = MockWatchlistMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>.value(
      value: mockWatchlistMoviesBloc,
      child: MaterialApp(home: body),
    );
  }

  group('WatchList Movie Page Test ===', () {
    testWidgets('Page should display center progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(
        () => mockWatchlistMoviesBloc.state,
      ).thenReturn(WatchlistMovieLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded', (
      WidgetTester tester,
    ) async {
      when(
        () => mockWatchlistMoviesBloc.state,
      ).thenReturn(WatchlistMovieHasData([testMovie]));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error', (
      WidgetTester tester,
    ) async {
      when(
        () => mockWatchlistMoviesBloc.state,
      ).thenReturn(WatchlistMovieError('Error message'));

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

      expect(textFinder, findsOneWidget);
    });
  });
}
