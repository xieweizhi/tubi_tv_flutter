// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
      json['id'] as String,
      json['description'] as String,
      (json['hero_images'] as List)?.map((e) => e as String)?.toList(),
      (json['thumbnails'] as List)?.map((e) => e as String)?.toList(),
      (json['posterarts'] as List)?.map((e) => e as String)?.toList(),
      json['title'] as String,
      json['type'] as String,
      json['duration'] as int,
      json['year'] as int,
      json['has_trailer'] as bool,
      json['publisher_id'] as String,
      json['has_subtitle'] as bool,
      json['import_id'] as String,
      (json['ratings'] as List)
          ?.map((e) => (e as Map<String, dynamic>)?.map(
                (k, e) => MapEntry(k, e as String),
              ))
          ?.toList(),
      (json['backgrounds'] as List)?.map((e) => e as String)?.toList(),
      (json['landscape_images'] as List)?.map((e) => e as String)?.toList(),
      (json['video_resources'] as List)
              ?.map((e) => e == null
                  ? null
                  : VideoResource.fromJson(e as Map<String, dynamic>))
              ?.toList() ??
          [])
    ..actors = (json['actors'] as List)?.map((e) => e as String)?.toList()
    ..directors = (json['directors'] as List)?.map((e) => e as String)?.toList()
    ..tags = (json['tags'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'duration': instance.duration,
      'description': instance.description,
      'year': instance.year,
      'has_trailer': instance.hasTrailer,
      'publisher_id': instance.publisherId,
      'has_subtitle': instance.hasSubtitle,
      'import_id': instance.importId,
      'ratings': instance.ratings,
      'actors': instance.actors,
      'directors': instance.directors,
      'tags': instance.tags,
      'video_resources': instance.videoResources,
      'thumbnails': instance.thumbnails,
      'posterarts': instance.posterarts,
      'backgrounds': instance.backgrounds,
      'hero_images': instance.heroImages,
      'landscape_images': instance.landscapeImages
    };
