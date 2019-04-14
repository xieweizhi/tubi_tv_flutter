import 'package:flutter/material.dart';
import 'package:flutter_tubi/src/ui/movie_page/movie_page.dart';
import 'package:meta/meta.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tubi/src/models/models.dart';

class HomeFeaturedRow extends StatefulWidget {
  final List<Movie> movies;

  const HomeFeaturedRow({Key key, @required this.movies}) : super(key: key);

  @override
  _HomeFeaturedRowState createState() => _HomeFeaturedRowState(this.movies);
}

class _HomeFeaturedRowState extends State<HomeFeaturedRow>
    with AutomaticKeepAliveClientMixin<HomeFeaturedRow> {
  final List<Movie> movies;
  int _currentPage = 0;

  _HomeFeaturedRowState(this.movies);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var pageController = PageController(initialPage: _currentPage);

    var pageView = PageView.builder(
      key: PageStorageKey(context),
      itemCount: movies.length,
      controller: pageController,
      itemBuilder: (context, index) {
        return _PageItemView(
            movie: movies[index], totalPage: movies.length, currentPage: index);
      },
      onPageChanged: (page) {
        setState(() {
          this._currentPage = page;
        });
      },
    );

    return Container(child: pageView);
  }

  @override
  bool get wantKeepAlive => true;
}

class _PageItemView extends StatelessWidget {
  final Movie movie;
  final int totalPage;
  final int currentPage;

  const _PageItemView(
      {Key key,
      @required this.movie,
      @required this.totalPage,
      @required this.currentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, MoviePageArguments.routeName,
              arguments: MoviePageArguments(movie));
        },
        child: Stack(children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CachedNetworkImage(
                  imageUrl: movie.heroImages.first, fit: BoxFit.cover)),
          Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87])),
              )),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            movie.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: RichText(
                              text: TextSpan(
                            text: '${currentPage + 1}',
                            style: TextStyle(
                                color: Color(0xffee5c32), fontSize: 12),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' / $totalPage',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12))
                            ],
                          ))),
                    ],
                  )))
        ]));
  }
}
