import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'movie.dart';

part 'movie_list.g.dart';

@JsonSerializable()
class MovieList extends Equatable {
  final String id;
  final String type;
  final String title;
  final String description;
  final String slug;
  final String thumbnail;
  final List<String> children;

  @JsonKey(ignore: true)
  List<Movie> childrenMovies;

  factory MovieList.fromJson(Map<String, dynamic> json) =>
      _$MovieListFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListToJson(this);

  MovieList(this.title, this.description, this.id, this.slug, this.thumbnail,
      this.type, this.children);
}
