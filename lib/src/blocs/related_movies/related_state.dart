import 'package:equatable/equatable.dart';
import 'package:flutter_tubi/src/models/models.dart';
import 'package:meta/meta.dart';

abstract class RelatedState extends Equatable {
  RelatedState([List props = const []]) : super(props);
}

class RelatedUninitialized extends RelatedState {
  @override
  String toString() => 'RelatedUninitialized';
}

class RelatedLoading extends RelatedState {
  @override
  String toString() => 'RelatedLoading';
}

class RelatedLoaded extends RelatedState {
  final List<Movie> movies;

  RelatedLoaded({this.movies}) : super([movies]);

  @override
  String toString() => 'RelatedLoaded { data: $movies }';
}

class RelatedError extends RelatedState {
  final Error error;
  RelatedError({@required this.error});

  @override
  String toString() => 'RelatedError';
}
