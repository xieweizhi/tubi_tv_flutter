import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tubi/src/models/models.dart';
import '../movie_page/movie_page.dart';

class HomeMovieScrollRow extends StatelessWidget {
  final List<Movie> movies;

  const HomeMovieScrollRow({@required Key key, @required this.movies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            key: key,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              var movie = movies[index];
              return Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: GestureDetector(
                      child: _ScrollItemView(movie: movie),
                      onTap: () {
                        Navigator.pushNamed(
                            context, MoviePageArguments.routeName,
                            arguments: MoviePageArguments(movie));
                      }));
            },
            padding: EdgeInsets.only(left: 16.0),
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics()));
  }
}

class _ScrollItemView extends StatelessWidget {
  final Movie movie;

  const _ScrollItemView({Key key, @required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 120,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                  placeholder: (context, url) {
                    return AspectRatio(
                        aspectRatio: 0.68,
                        child: Image.asset("assets/icons/placeholder.png",
                            fit: BoxFit.cover));
                  },
                  imageUrl: movie.posterarts.first,
                  fit: BoxFit.cover),
              SizedBox(height: 14),
              Text(movie.title,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14, color: Colors.white))
            ]));
  }
}
