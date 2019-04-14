import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tubi/src/models/models.dart';
import 'package:flutter_tubi/src/ui/movie_page/movie_page.dart';

class MovieCategoryPageArguments {
  static final routeName = "movieCategory";
  final String title;
  final List<Movie> movies;

  MovieCategoryPageArguments({@required this.movies, @required this.title});
}

class MovieCategoryPage extends StatefulWidget {
  final List<Movie> movies;
  final String title;
  final bool showAppBar;

  const MovieCategoryPage({Key key, @required this.movies, @required this.title, this.showAppBar})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MovieCategoryPageState();
  }
}

class _MovieCategoryPageState extends State<MovieCategoryPage> {
  List<Movie> get movies => widget.movies;
  String get title => widget.title;

  @override
  Widget build(BuildContext context) {
    final itemWidth = (MediaQuery.of(context).size.width - 2 * 16 - 8 * 2) / 3.0;
    final itemHeight = itemWidth * 1.46 + 80.0;
    final showAppBar = widget.showAppBar ?? true;
    return Container(
        color: Color(0xff26262d),
        child: Container(
          child: CustomScrollView(slivers: <Widget>[
            showAppBar ? SliverAppBar(
                title: Text(title),
                pinned: true,
                backgroundColor: Color(0xff26262d)) : SliverAppBar(),
            SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext contet, int index) {
                    var movie = movies[index];
                    return _buildGridItem(context, movie);
                  }, childCount: movies.length),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: itemWidth,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 8,
                      childAspectRatio: itemWidth / itemHeight),
                ))
          ]),
        ));
  }

  Widget _buildGridItem(BuildContext context, Movie movie) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, MoviePageArguments.routeName,
              arguments: MoviePageArguments(movie));
        },
        child: SizedBox(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              AspectRatio(
                  aspectRatio: 0.68,
                  child: CachedNetworkImage(
                      placeholder: (context, url) {
                        return Image.asset("assets/icons/placeholder.png");
                      },
                      imageUrl: movie.posterarts.first,
                      fit: BoxFit.cover)),
              SizedBox(height: 14),
              Text(movie.title,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14, color: Colors.white))
            ])));
  }
}
