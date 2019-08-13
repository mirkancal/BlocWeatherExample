import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:weather_provider/src/models/query_result.dart';
import 'package:weather_provider/src/models/weather_detail.dart';

class ApiProvider {
  String baseUrl = "https://www.metaweather.com/api/location/";
  Client client = Client();

  Future<List<QueryResult>> queryCities(String str) async {
    String reqUrl = baseUrl + "search/?query=$str";
    final Response response = await client.get(reqUrl);
    if (response.statusCode == 200) {
      return compute(parseQueryResult, response.body);
    } else {
      throw Exception('Failed to query');
    }
  }

  Future<WeatherDetail> getWeatherDetail(int woeid) async {
    String reqUrl = baseUrl + woeid.toString();
    final Response response = await client.get(reqUrl);
    if (response.statusCode == 200) {
      return compute(parseWeatherDetail, response.body);
    } else {
      throw Exception('Failed to bring results');
    }
  }

  String generateIconLink(String weatherAbbreviation) {
    return "https://www.metaweather.com/static/img/weather/png/$weatherAbbreviation.png";
  }
}

List<QueryResult> parseQueryResult(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<QueryResult>((json) => QueryResult.fromJson(json)).toList();
}

WeatherDetail parseWeatherDetail(String responseBody) {
  final parsed = json.decode(responseBody);

  return WeatherDetail.fromJson(parsed);
}
