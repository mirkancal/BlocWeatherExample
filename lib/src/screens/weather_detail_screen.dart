import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_provider/src/blocs/detail_bloc/bloc.dart';
import 'package:weather_provider/src/models/weather_detail.dart';
import 'package:weather_provider/src/resources/api_provider.dart';

class WeatherDetailScreen extends StatefulWidget {
  @override
  _WeatherDetailScreenState createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  DetailBloc detailBloc;
  @override
  void initState() {
    super.initState();
    detailBloc = BlocProvider.of<DetailBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder(
        builder: (BuildContext context, DetailBlocState state) {
          if (state is LoadingDetailState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FetchedDetailState) {
            WeatherDetail weatherDetail = detailBloc.weatherDetail;
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.lightBlue,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CityName(
                              name: weatherDetail.title,
                            ),
                            Weekday(
                              weatherDate: weatherDetail
                                  .consolidatedWeather[detailBloc.index]
                                  .applicableDate,
                            ),
                            Temperature(
                              temperature: weatherDetail
                                  .consolidatedWeather[detailBloc.index]
                                  .theTemp,
                            ),
                            WeatherIcon(
                              weatherAbbreviation: weatherDetail
                                  .consolidatedWeather[detailBloc.index]
                                  .weatherStateAbbr,
                              height: 150,
                              width: 150,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 150.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: weatherDetail.consolidatedWeather.length,
                        itemBuilder: (context, index) {
                          ConsolidatedWeather weatherData =
                              weatherDetail.consolidatedWeather[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                detailBloc.dispatch(SwitchDetailEvent(index));
                              },
                              child: Container(
                                width: 100.0,
                                child: Card(
                                  color: Colors.amber,
                                  child: Column(
                                    children: <Widget>[
                                      Weekday(
                                          weatherDate:
                                              weatherData.applicableDate),
                                      WeatherIcon(
                                        weatherAbbreviation:
                                            weatherData.weatherStateAbbr,
                                      ),
                                      Temperature(
                                        temperature: weatherData.theTemp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
        bloc: detailBloc,
      ),
    );
  }
}

class CityName extends StatelessWidget {
  const CityName({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.display1,
    );
  }
}

class Weekday extends StatelessWidget {
  const Weekday({
    Key key,
    @required this.weatherDate,
  }) : super(key: key);

  final String weatherDate;

  @override
  Widget build(BuildContext context) {
    return Text(DateFormat.EEEE().format(DateTime.parse(weatherDate)));
  }
}

class Temperature extends StatelessWidget {
  const Temperature({
    Key key,
    @required this.temperature,
  }) : super(key: key);

  final double temperature;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${temperature.toStringAsFixed(2)} °C",
      style: Theme.of(context).textTheme.body1,
    );
  }
}

class WeatherIcon extends StatelessWidget {
  WeatherIcon({
    Key key,
    @required this.weatherAbbreviation,
    this.height,
    this.width,
  }) : super(key: key);

  final String weatherAbbreviation;
  final double height;
  final double width;

  final ApiProvider apiProvider = ApiProvider();

  @override
  Widget build(BuildContext context) {
    return Image.network(
      apiProvider.generateIconLink(weatherAbbreviation),
      height: height ?? 64.0,
      width: width ?? 64.0,
    );
  }
}
