import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:weather_provider/src/models/query_result.dart';
import 'package:weather_provider/src/resources/api_provider.dart';
import './bloc.dart';

class QueryBloc extends Bloc<QueryEvent, QueryState> {
  ApiProvider apiProvider = ApiProvider();
  List<QueryResult> results;
  @override
  QueryState get initialState => InitialQueryState();

  @override
  Stream<QueryState> mapEventToState(
    QueryEvent event,
  ) async* {
    // TODO: Add Logic
    if (event is SendQueryEvent) {
      yield QueryLoadingState();
      results = await apiProvider.queryCities(event.queryString);
      yield QueryFetchedState();
    }
  }
}
