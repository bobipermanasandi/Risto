import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:risto/presentation/widgets/movie_card.dart';
import 'package:risto/presentation/widgets/tv_series_card.dart';

void main() {
  group('Testing Risto App', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    final drawerButton = find.byKey(const Key('drawerButton'));
    final watchlistMovieButton = find.byKey(const Key('watchlistButton-movie'));
    final watchlistTvSeriesButton = find.byKey(
      const Key('watchlistButton-tvseries'),
    );
    final iconCheck = find.byIcon(Icons.check);
    final iconBack = find.byIcon(Icons.arrow_back);
    final iconMenuWatchlist = find.byIcon(Icons.bookmark);

    testWidgets('Verify watchlist movies & tv series', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // click movie item
      final movieItem = find.byKey(const Key('movieOnTap')).first;
      await tester.tap(movieItem);
      await tester.pumpAndSettle();

      // click watchlist button
      await tester.tap(watchlistMovieButton);
      await tester.pumpAndSettle();
      expect(iconCheck, findsOneWidget);

      // back to home page
      await tester.tap(iconBack);
      await tester.pumpAndSettle();

      // click watchlist menu in movie page
      await tester.tap(iconMenuWatchlist);
      await tester.pumpAndSettle();

      // check save movie item in watchlist page
      expect(find.byType(MovieCard), findsOneWidget);

      // back to home page
      await tester.tap(find.byKey(const Key('iconBack-movie')));
      await tester.pumpAndSettle();

      // navigate to menu tv series
      await tester.tap(drawerButton);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('menu-tv-series')));
      await tester.pumpAndSettle();

      // click tv series item
      final tvSeriesItem = find.byKey(const Key('tvSeriesOnTap')).first;
      await tester.tap(tvSeriesItem);
      await tester.pumpAndSettle();

      // click watchlist button
      await tester.tap(watchlistTvSeriesButton);
      await tester.pumpAndSettle();
      expect(iconCheck, findsOneWidget);

      // back to home page
      await tester.tap(iconBack);
      await tester.pumpAndSettle();

      // click watchlist menu in tv series
      await tester.tap(iconMenuWatchlist);
      await tester.pumpAndSettle();

      // check save movie item in watchlist page
      expect(find.byType(TvSeriesCard), findsOneWidget);
    });
  });
}
