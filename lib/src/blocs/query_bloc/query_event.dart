import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class QueryEvent extends Equatable {
  QueryEvent([List props = const <dynamic>[]]) : super(props);
}

class SendQueryEvent extends QueryEvent {
  SendQueryEvent(this.queryString, [List props = const <dynamic>[]]) : super(props);

  final String queryString;
}
