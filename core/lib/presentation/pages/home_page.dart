import 'package:core/core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:core/presentation/pages/movie/movie_list_page.dart';
import 'package:core/presentation/pages/tv_series/tv_series_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MovieListPage(),
    TvSeriesListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          (_selectedIndex == 0) ? 'Movie' : 'Tv Series',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              key: const Key('drawerButton'),
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseCrashlytics.instance.crash();
              (_selectedIndex == 0)
                  ? Navigator.pushNamed(context, searchMovieRoute)
                  : Navigator.pushNamed(context, searchTvSeriesRoute);
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              (_selectedIndex == 0)
                  ? Navigator.pushNamed(context, watchListMovieRoute)
                  : Navigator.pushNamed(context, watchListTvSeriesRoute);
            },
            icon: const Icon(Icons.bookmark, color: Colors.yellowAccent),
          ),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text(
                'CodeSynesia',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text('info@codesynesia.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              key: const Key('menu-tv-series'),
              leading: Icon(Icons.tv_rounded),
              title: Text('Tv Series'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, aboutRoute);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}
