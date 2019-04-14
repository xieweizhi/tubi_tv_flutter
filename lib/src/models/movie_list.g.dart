// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieList _$MovieListFromJson(Map<String, dynamic> json) {
  return MovieList(
      json['title'] as String,
      json['description'] as String,
      json['id'] as String,
      json['slug'] as String,
      json['thumbnail'] as String,
      json['type'] as String,
      (json['children'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$MovieListToJson(MovieList instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'slug': instance.slug,
      'thumbnail': instance.thumbnail,
      'children': instance.children
    };
