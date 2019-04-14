import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tubi/src/ui/category/movie_category.dart';
import 'package:flutter_tubi/src/ui/home/home_page.dart';
import 'package:flutter_tubi/src/ui/browse/browse_page.dart';
import 'package:flutter_tubi/src/ui/movie_page/movie_page.dart';
import 'package:flutter_tubi/src/ui/search/search_page.dart';
import 'package:flutter_tubi/src/blocs/home/bloc.dart';

class TabType {
  static const home = 0;
  static const browse = 1;
  static const search = 2;
}

class TabNavigatorRoutes {
  static const String root = '/';
  static const String movieCategory = 'movieCategory';
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final int currentTab;
  final HomeBloc homeBloc;

  TabNavigator(
      {Key key,
      @required this.navigatorKey,
      @required this.currentTab,
      @required this.homeBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return _routeForRouteSettings(routeSettings: routeSettings);
        });
  }

  PageRoute _routeForRouteSettings({@required RouteSettings routeSettings}) {
    return MaterialPageRoute(builder: (context) {
      if (routeSettings.name == TabNavigatorRoutes.root) {
        switch (currentTab) {
          case TabType.home:
            return HomePage(homeBloc: homeBloc);
          case TabType.browse:
            return BrowsePage(homeBloc: homeBloc);
          case TabType.search:
            return SearchPage();
          default:
            break;
        }
      }
      if (routeSettings.name == MoviePageArguments.routeName) {
        final MoviePageArguments args = routeSettings.arguments;
        return MoviePage(movie: args.movie);
      }
      if (routeSettings.name == TabNavigatorRoutes.movieCategory) {
        final MovieCategoryPageArguments args = routeSettings.arguments;
        return MovieCategoryPage(movies: args.movies, title: args.title);
      }
    });
  }
}
