import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:weather_provider/src/models/weather_detail.dart';
import 'package:weather_provider/src/resources/api_provider.dart';
import './bloc.dart';

class DetailBloc extends Bloc<DetailBlocEvent, DetailBlocState> {
  ApiProvider apiProvider = ApiProvider();
  WeatherDetail weatherDetail;
  int index = 0;
  @override
  DetailBlocState get initialState => InitialDetailBlocState();

  @override
  Stream<DetailBlocState> mapEventToState(
    DetailBlocEvent event,
  ) async* {
    // TODO: Add Logic
    if (event is BringDetailEvent) {
      yield LoadingDetailState();
      weatherDetail = await apiProvider.getWeatherDetail(event.woeid);
      yield FetchedDetailState();
    }
    if (event is SwitchDetailEvent) {
      yield LoadingDetailState();
      index = event.index;
      yield FetchedDetailState();
    }
  }
}
