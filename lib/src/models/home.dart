import 'package:equatable/equatable.dart';
import 'movie.dart';
import 'movie_list.dart';

class HomePageModel extends Equatable {
  final Map<String, Movie> movies;
  final List<MovieList> movieLists;

  HomePageModel(this.movies, this.movieLists);

  static HomePageModel fromJson(Map<String, dynamic> json) {
    var moviesJson = (json['contents'] as Map<String, dynamic>);
    var movies = Map<String, Movie>();
    moviesJson.forEach((k, v) {
      movies[k] = Movie.fromJson(v);
    });

    var containersJson = json['containers'] as List<dynamic>;
    var movieLists = containersJson.map((json) {
      var movieList = MovieList.fromJson(json);
      movieList.childrenMovies = movieList.children.map((id) => movies[id]).toList();
      return movieList;
    }).toList();

    return HomePageModel(movies, movieLists);
  }

  @override
  String toString() {
    return 'HomePageModel: ${movies.length} movies.';
  }

  // Helpers

  List<Movie> getFeaturedMovies() {
    return movieLists
        .firstWhere((list) => list.id == "featured")
        .childrenMovies;
  }

  List<MovieList> movieListExcludeFeatured() {
    return movieLists.where((list) => list.id != 'featured').toList();
  }
}
