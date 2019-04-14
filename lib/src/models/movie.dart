import 'package:flutter_tubi/src/models/video_resource.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie extends Equatable {
  final String id;
  final String type;
  final String title;
  final int duration;
  final String description;
  final int year;

  @JsonKey(name: "has_trailer")
  final bool hasTrailer;

  @JsonKey(name: "publisher_id")
  final String publisherId;

  @JsonKey(name: "has_subtitle")
  final bool hasSubtitle;

  @JsonKey(name: "import_id")
  final String importId;

  List<Map<String, String>> ratings;
  List<String> actors;
  List<String> directors;
  List<String> tags;

@JsonKey(name: 'video_resources', defaultValue: [])
  List<VideoResource> videoResources;

  final List<String> thumbnails;
  final List<String> posterarts;
  final List<String> backgrounds;

  @JsonKey(name: "hero_images")
  final List<String> heroImages;
  @JsonKey(name: "landscape_images")
  final List<String> landscapeImages;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);

  Movie(
      this.id,
      this.description,
      this.heroImages,
      this.thumbnails,
      this.posterarts,
      this.title,
      this.type,
      this.duration,
      this.year,
      this.hasTrailer,
      this.publisherId,
      this.hasSubtitle,
      this.importId,
      this.ratings,
      this.backgrounds,
      this.landscapeImages,
      this.videoResources);
}
