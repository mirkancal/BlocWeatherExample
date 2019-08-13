import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_provider/src/models/weather_detail.dart';
import 'package:weather_provider/src/resources/api_provider.dart';

class WeatherDetailScreen extends StatefulWidget {
  const WeatherDetailScreen(this.woeid);
  final int woeid;
  @override
  _WeatherDetailScreenState createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  ApiProvider apiProvider = ApiProvider();
  Future<WeatherDetail> weatherDetailFuture;
  int weatherIndex = 0;
  @override
  void initState() {
    super.initState();
    weatherDetailFuture = apiProvider.getWeatherDetail(widget.woeid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<WeatherDetail>(
          future: weatherDetailFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
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
                              name: snapshot.data.title,
                            ),
                            Weekday(
                              weatherDate: snapshot
                                  .data
                                  .consolidatedWeather[weatherIndex]
                                  .applicableDate,
                            ),
                            Temperature(
                              temperature: snapshot.data
                                  .consolidatedWeather[weatherIndex].theTemp,
                            ),
                            WeatherIcon(
                              weatherAbbreviation: snapshot
                                  .data
                                  .consolidatedWeather[weatherIndex]
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
                        itemCount: snapshot.data.consolidatedWeather.length,
                        itemBuilder: (context, index) {
                          ConsolidatedWeather weatherData =
                              snapshot.data.consolidatedWeather[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  weatherIndex = index;
                                });
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
          }),
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
