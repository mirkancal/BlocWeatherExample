import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_provider/src/blocs/detail_bloc/bloc.dart';
import 'package:weather_provider/src/blocs/detail_bloc/detail_bloc.dart';
import 'package:weather_provider/src/blocs/query_bloc/bloc.dart';
import 'package:weather_provider/src/models/query_result.dart';
import 'package:weather_provider/src/resources/api_provider.dart';
import 'package:weather_provider/src/screens/weather_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QueryBloc queryBloc;
  @override
  void initState() {
    queryBloc = BlocProvider.of<QueryBloc>(context);
    super.initState();
  }

  String query;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ApiProvider apiProvider = ApiProvider();
  List<QueryResult> resultList = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onSaved: (val) {
                        setState(() {
                          query = val;
                        });
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    _formKey.currentState.save();

                    queryBloc.dispatch(SendQueryEvent(query));
                  },
                )
              ],
            ),
          ),
          BlocBuilder(
            bloc: queryBloc,
            builder: (BuildContext context, QueryState state) {
              if (state is InitialQueryState) {
                return Container();
              }
              if (state is QueryLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is QueryFetchedState) {
                return Flexible(
                  child: ListView.builder(
                    itemCount: queryBloc.results.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          DetailBloc detailBloc = DetailBloc();
                          detailBloc.dispatch(
                              BringDetailEvent(queryBloc.results[index].woeid));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        builder: (context) => detailBloc,
                                        child: WeatherDetailScreen(),
                                      )));
                        },
                        title: Text(queryBloc.results[index].title),
                        subtitle: Text(queryBloc.results[index].lattLong),
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
