import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class BlocState<T> extends Equatable {
  T data;
}

class BlocStateUninitialized extends BlocState {
  @override
  String toString() => 'BlocStateUninitialized';
}

class BlocStateLoading extends BlocState {
  @override
  String toString() => 'BlocStateLoading';
}

class BlocStateLoaded extends BlocState {
  var data;
  BlocStateLoaded({@required this.data});

  @override
  String toString() => 'BlocStateLoaded';
}

class BlocStateError extends BlocState {
  final Error error;
  BlocStateError({@required this.error});

  @override
  String toString() => 'RelatedError';
}
