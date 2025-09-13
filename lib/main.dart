import 'package:risto/common/constants.dart';
import 'package:risto/common/utils.dart';
import 'package:risto/presentation/pages/about_page.dart';
import 'package:risto/presentation/pages/home_page.dart';
import 'package:risto/presentation/pages/movie/movie_detail_page.dart';
import 'package:risto/presentation/pages/movie/popular_movies_page.dart';
import 'package:risto/presentation/pages/movie/search_movie_page.dart';
import 'package:risto/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:risto/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:risto/presentation/pages/tv_series/popular_tv_series_page.dart';
import 'package:risto/presentation/pages/tv_series/search_tv_series_page.dart';
import 'package:risto/presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'package:risto/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:risto/presentation/pages/tv_series/watchlist_tv_series_page.dart';
import 'package:risto/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:risto/presentation/provider/movie/movie_list_notifier.dart';
import 'package:risto/presentation/provider/movie/movie_search_notifier.dart';
import 'package:risto/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:risto/presentation/provider/movie/top_rated_movies_notifier.dart';
import 'package:risto/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risto/injection.dart' as di;
import 'package:risto/presentation/provider/tv_series/popular_tv_series_notifier.dart';
import 'package:risto/presentation/provider/tv_series/top_rated_tv_series_notifier.dart';
import 'package:risto/presentation/provider/tv_series/tv_series_detail_notifier.dart';
import 'package:risto/presentation/provider/tv_series/tv_series_list_notifier.dart';
import 'package:risto/presentation/provider/tv_series/tv_series_search_notifier.dart';
import 'package:risto/presentation/provider/tv_series/watchlist_tv_series_notifier.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// MOVIE PROVIDER
        ChangeNotifierProvider(create: (_) => di.locator<MovieListNotifier>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),

        /// TV SERIES PROVIDER
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvSeriesNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Risto',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());

            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => AboutPage());

            /// MOVIE
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviePage.routeName:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());

            /// TV SERIES
            case PopularTvSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedTvSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case TvSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case SearchTvSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => SearchTvSeriesPage());
            case WatchlistTvSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistTvSeriesPage());

            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
