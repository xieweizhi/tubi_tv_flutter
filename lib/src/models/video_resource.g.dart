// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoResource _$VideoResourceFromJson(Map<String, dynamic> json) {
  return VideoResource(
      json['manifest'] == null
          ? null
          : VideoResourceManifest.fromJson(
              json['manifest'] as Map<String, dynamic>),
      json['type'] as String);
}

Map<String, dynamic> _$VideoResourceToJson(VideoResource instance) =>
    <String, dynamic>{'manifest': instance.manifest, 'type': instance.type};

VideoResourceManifest _$VideoResourceManifestFromJson(
    Map<String, dynamic> json) {
  return VideoResourceManifest(json['duration'] as int, json['url'] as String);
}

Map<String, dynamic> _$VideoResourceManifestToJson(
        VideoResourceManifest instance) =>
    <String, dynamic>{'duration': instance.duration, 'url': instance.url};
