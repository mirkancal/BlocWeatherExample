import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_provider/src/blocs/query_bloc/bloc.dart';
import 'package:weather_provider/src/screens/home_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather App",
      home: BlocProvider(
        builder: (context) => QueryBloc(),
        child: HomeScreen(),
      ),
    );
  }
}
