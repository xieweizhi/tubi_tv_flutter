import 'package:flutter/material.dart';
import 'package:flutter_tubi/src/tab_navigator.dart';
import 'package:flutter_tubi/src/ui/category/movie_category.dart';
import 'package:meta/meta.dart';

import 'package:flutter_tubi/src/models/models.dart';
import 'home_featured_row.dart';
import 'home_movie_scroll_row.dart';

class HomeListView extends StatelessWidget {
  final HomePageModel homePageModel;
  const HomeListView({Key key, @required this.homePageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MovieList> allMovieList =
        homePageModel.movieListExcludeFeatured() ?? [];
    var featuredMovies = homePageModel.getFeaturedMovies() ?? [];

    return Container(
        color: Color(0xff26262d),
        child: CustomScrollView(slivers: <Widget>[
          _buildAppBar(
              featuredMovies: featuredMovies,
              height: MediaQuery.of(context).size.width * 0.6),
          SliverFixedExtentList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return _buildRowView(allMovieList[index]);
              }, childCount: allMovieList.length),
              itemExtent: 303),
        ]));
  }

  Widget _buildRowView(MovieList movieList) {
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: _ListSectionTitleView(movieList: movieList)),
      Container(
          height: 250,
          child: HomeMovieScrollRow(
            key: PageStorageKey(movieList.id),
            movies: movieList.childrenMovies,
          )),
      Container(
        height: 1,
        child: Divider(color: Colors.white24),
      )
    ]);
  }

  Widget _buildAppBar({List<Movie> featuredMovies, double height}) {
    return SliverAppBar(
      title: Image.asset("assets/icons/icon_nav_logo.png"),
      pinned: true,
      backgroundColor: Color(0xff26262d),
      expandedHeight: height,
      flexibleSpace:
          FlexibleSpaceBar(background: HomeFeaturedRow(movies: featuredMovies)),
    );
  }
}

class _ListSectionTitleView extends StatelessWidget {
  final MovieList movieList;

  const _ListSectionTitleView({Key key, @required this.movieList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var button = MaterialButton(
      minWidth: 20,
      child: Image.asset("assets/icons/iconOverflow.png"),
      onPressed: () {
        Navigator.pushNamed(context, TabNavigatorRoutes.movieCategory,
            arguments: MovieCategoryPageArguments(
                movies: movieList.childrenMovies, title: movieList.title));
      },
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 52,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: Text(movieList.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold))),
          Align(alignment: Alignment.centerRight, child: button)
        ],
      ),
    );
  }
}
