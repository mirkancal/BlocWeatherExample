import 'package:flutter/material.dart';
import 'package:weather_provider/src/models/query_result.dart';
import 'package:weather_provider/src/models/weather_detail.dart';
import 'package:weather_provider/src/resources/api_provider.dart';
import 'package:weather_provider/src/screens/weather_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    setState(() {
                      isLoading = true;
                    });
                    final queryResultList =
                        await apiProvider.queryCities(query);
                    setState(() {
                      isLoading = false;
                      resultList = queryResultList;
                    });
                  },
                )
              ],
            ),
          ),
          if (isLoading == true)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (resultList != null && isLoading == false)
            Flexible(
              child: ListView.builder(
                itemCount: resultList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WeatherDetailScreen(
                                  resultList[index].woeid)));
                    },
                    title: Text(resultList[index].title),
                    subtitle: Text(resultList[index].lattLong),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
