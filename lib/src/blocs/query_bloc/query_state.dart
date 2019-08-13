import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class QueryState extends Equatable {
  QueryState([List props = const <dynamic>[]]) : super(props);
}

class InitialQueryState extends QueryState {}

class QueryLoadingState extends QueryState {}

class QueryFetchedState extends QueryState {}
