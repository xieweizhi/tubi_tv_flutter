import 'package:equatable/equatable.dart';

abstract class BlocEvent extends Equatable {}

class BlocEventFetch extends BlocEvent {
  @override
  String toString() => 'BlocEventFetch';
}