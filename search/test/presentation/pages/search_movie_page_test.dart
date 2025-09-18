import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/presentation/blocs/movie/search_movie_bloc.dart';
import 'package:search/presentation/pages/movie/search_movie_page.dart';

import '../../../../core/test/dummy_data/movie/dummy_objects.dart';

class MockSearchMoviesBloc extends MockBloc<SearchMovieEvent, SearchMovieState>
    implements SearchMovieBloc {}

class FakeSearchMoviesEvent extends Fake implements SearchMovieEvent {}

class FakeSearchMoviesState extends Fake implements SearchMovieState {}

void main() {
  late MockSearchMoviesBloc mockSearchMoviesBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchMoviesEvent());
    registerFallbackValue(FakeSearchMoviesState());
  });

  setUp(() {
    mockSearchMoviesBloc = MockSearchMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchMovieBloc>.value(
      value: mockSearchMoviesBloc,
      child: MaterialApp(home: body),
    );
  }

  group('Search Movie Page --> ', () {
    testWidgets('should display when initial', (WidgetTester tester) async {
      when(() => mockSearchMoviesBloc.state).thenReturn(SearchMovieInitial());

      final textErrorBarFinder = find.byType(Container);

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      expect(textErrorBarFinder, findsOneWidget);
    });

    testWidgets('should display center progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(() => mockSearchMoviesBloc.state).thenReturn(SearchMovieLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('should display listView when data is loaded', (
      WidgetTester tester,
    ) async {
      when(
        () => mockSearchMoviesBloc.state,
      ).thenReturn(SearchMovieHasData(testMovieList));

      final formSearch = find.byType(TextField);
      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      await tester.enterText(formSearch, 'spiderman');
      await tester.pump();

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('should display text when data is empty', (
      WidgetTester tester,
    ) async {
      when(() => mockSearchMoviesBloc.state).thenReturn(SearchMovieEmpty());

      final textErrorBarFinder = find.text('No Result');

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      expect(textErrorBarFinder, findsOneWidget);
    });

    testWidgets('should display text with message when Error', (
      WidgetTester tester,
    ) async {
      when(
        () => mockSearchMoviesBloc.state,
      ).thenReturn(SearchMovieError('Error message'));

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      expect(textFinder, findsOneWidget);
    });
  });
}
