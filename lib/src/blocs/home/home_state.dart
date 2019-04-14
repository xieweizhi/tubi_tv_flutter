import 'package:equatable/equatable.dart';
import 'package:flutter_tubi/src/models/models.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {
  HomeState([List props = const []]) : super(props);
}

class HomeUninitialized extends HomeState {
  @override
  String toString() => 'HomeUninitialized';
}

class HomeLoading extends HomeState {
  @override
  String toString() => 'HomeLoading';
}

class HomeLoaded extends HomeState {
  final HomePageModel model;

  HomeLoaded({this.model}) : super([model]);

  @override
  String toString() => 'HomeLoaded { data: $model }';
}

class HomeError extends HomeState {
  final Error error;
  HomeError({@required this.error});

  @override
  String toString() => 'HomeError';
}
