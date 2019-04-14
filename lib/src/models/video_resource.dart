import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_resource.g.dart';

@JsonSerializable()
class VideoResource extends Equatable {
  final VideoResourceManifest manifest;
  final String type;

  VideoResource(this.manifest, this.type);

  factory VideoResource.fromJson(Map<String, dynamic> json) =>
      _$VideoResourceFromJson(json);

  Map<String, dynamic> toJson() => _$VideoResourceToJson(this);
}

@JsonSerializable()
class VideoResourceManifest {
  final int duration;
  final String url;

  VideoResourceManifest(this.duration, this.url);

  factory VideoResourceManifest.fromJson(Map<String, dynamic> json) =>
      _$VideoResourceManifestFromJson(json);

  Map<String, dynamic> toJson() => _$VideoResourceManifestToJson(this);
}
