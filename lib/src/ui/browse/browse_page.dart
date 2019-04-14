import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tubi/src/blocs/home/bloc.dart';
import 'package:flutter_tubi/src/models/models.dart';
import 'package:flutter_tubi/src/ui/category/movie_category.dart';

class BrowsePage extends StatefulWidget {
  final HomeBloc homeBloc;
  const BrowsePage({Key key, @required this.homeBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BrowsePageState(homeBloc: homeBloc);
  }
}

class _BrowsePageState extends State<BrowsePage> {
  final HomeBloc homeBloc;

  _BrowsePageState({@required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: homeBloc,
        builder: (ctx, HomeState state) {
          if (state is HomeLoaded) {
            return _buildListView(model: state.model, context: ctx);
          }
          if (state is HomeError) {
            return Center(child: Text(state.error.toString()));
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildListView({HomePageModel model, BuildContext context}) {
    var movieLists = model.movieLists
        .where((list) => list.type != 'continue_watching')
        .toList();
    movieLists.sort((a, b) {
      return a.title.compareTo(b.title);
    });
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          title: Text("Browse"),
          pinned: true,
          backgroundColor: Color(0xff26262d)),
      SliverFixedExtentList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return _buildListItem(model: movieLists[index], context: context);
          }, childCount: movieLists.length),
          itemExtent: 70),
    ]);
  }

  Widget _buildListItem({MovieList model, BuildContext context}) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, MovieCategoryPageArguments.routeName,
              arguments: MovieCategoryPageArguments(
                  movies: model.childrenMovies, title: model.title));
        },
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)),
            margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Container(
                child: Stack(children: <Widget>[
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      width: 180,
                      child: CachedNetworkImage(
                          imageUrl: model.thumbnail ?? "", fit: BoxFit.cover))),
              Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.transparent, Colors.grey])),
                  )),
              Container(
                  padding: EdgeInsets.only(left: 24),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        model.title,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )))
            ]))));
  }
}
