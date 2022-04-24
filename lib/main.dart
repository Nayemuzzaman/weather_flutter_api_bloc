
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_flutter_api_bloc/WeatherBloc.dart';
import 'package:weather_flutter_api_bloc/WeatherData.dart';
import 'package:weather_flutter_api_bloc/WeatherModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: BlocProvider(
          //pass context and return weatherBloc class,
          //weather bloc pass weatehrData
          create: (context) => WeatherBloc(WeatherData()),
          child: SearchCity(),
        ),
      ),
    );
  }
}

//SearchCity access weatherbloc
class SearchCity extends StatelessWidget {
  const SearchCity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //refer our weatherbloc
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: SizedBox(
            child: Image.asset("assets/weatherlg.png", width: 100, height: 100),
            height: 300,
            width: 300,
          ),
        ),
        //first pase ui shows 
        BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
          //based on state, change on state
          if (state is WeatherIsNotSearched) {
            return Container(
              padding: EdgeInsets.only(left: 32, right: 32,),
              child: Column(
                children: <Widget>[
                  Text(
                    "Search Weather",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70),
                  ),
                  Text(
                    "Instanly",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w200,
                        color: Colors.white70),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: cityController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white70,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Colors.white70, style: BorderStyle.solid)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Colors.blue, style: BorderStyle.solid)),
                      hintText: "City Name",
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        //textedit controller cityController
                        weatherBloc.add(FetchWeather(cityController.text));
                      },
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state is WeatherIsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherIsLoaded) {
            return ShowWeather(state.getWeather, cityController.text);
          } else {
            return Text(
              "Error",
              style: TextStyle(color: Colors.white),
            );
          }
        }),
      ],
    );
  }
}
//show weather also access weatherbloc
class ShowWeather extends StatelessWidget {
  WeatherModel weatherModel;
  final city;

  ShowWeather(
    this.weatherModel,
    this.city,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 32, left: 32, top: 10),
        child: Column(
          children: <Widget>[
            Text(
              city,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              weatherModel.getTemp.round().toString() + "°C",
              style: TextStyle(color: Colors.white70, fontSize: 50),
            ),
            Text(
              "Temprature",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      weatherModel.getMinTemp.round().toString() + "°C",
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    Text(
                      "Min Temprature",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      weatherModel.getMaxTemp.round().toString() + "°C",
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    Text(
                      "Max Temprature",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox (
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                  onPressed: () {
                   // BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                     Navigator.of(context).push( new MaterialPageRoute(builder: (Context) {
                      return MyApp();
                    }));
                  },
                  child: Text(
                    "Search",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),)
          ],
        ));
  }
}
