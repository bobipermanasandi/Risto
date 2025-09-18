import 'package:about/about.dart';
import 'package:core/common/http_ssl_pinning.dart';
import 'package:core/core.dart';
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
import 'package:core/presentation/pages/home_page.dart';
import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:core/presentation/pages/movie/popular_movies_page.dart';
import 'package:core/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:core/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:core/presentation/pages/tv_series/popular_tv_series_page.dart';
import 'package:core/presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'package:core/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:core/presentation/pages/tv_series/watchlist_tv_series_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risto/injection.dart' as di;
import 'package:search/presentation/blocs/movie/search_movie_bloc.dart';
import 'package:search/presentation/blocs/tv_series/search_tv_series_bloc.dart';
import 'package:search/presentation/pages/movie/search_movie_page.dart';
import 'package:search/presentation/pages/tv_series/search_tv_series_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSslPinning.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// MOVIE BLOC
        BlocProvider(create: (_) => di.locator<NowPlayingMovieBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMovieBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMovieBloc>()),
        BlocProvider(create: (_) => di.locator<DetailMovieBloc>()),
        BlocProvider(create: (_) => di.locator<SearchMovieBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),

        /// TV SERIES BLOC
        BlocProvider(create: (_) => di.locator<NowPlayingTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<DetailTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<SearchTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvSeriesBloc>()),
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
            case homeRoute:
              return MaterialPageRoute(builder: (_) => HomePage());
            case aboutRoute:
              return MaterialPageRoute(builder: (_) => AboutPage());

            /// MOVIE
            case popularMovieRoute:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case topRatedMovieRoute:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case detailMovieRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case searchMovieRoute:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case watchListMovieRoute:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());

            /// TV SERIES
            case popularTvSeriesRoute:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case topRatedTvSeriesRoute:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case detailTvSeriesRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case searchTvSeriesRoute:
              return CupertinoPageRoute(builder: (_) => SearchTvSeriesPage());
            case watchListTvSeriesRoute:
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
