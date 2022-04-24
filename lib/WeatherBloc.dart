import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:weather_flutter_api_bloc/WeatherData.dart';
import 'package:weather_flutter_api_bloc/WeatherModel.dart';
import 'package:weather_flutter_api_bloc/main.dart';

//event take as a input 
//fetch weather of given city then weather bloc communicate with repository & bring weather data 
//bring data genearte new state where weather is loaded 

//base class for all the event 
abstract class WeatherEvent {

}
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

//fetch weather repository as users input city 
class FetchWeather extends WeatherEvent {
  final _city;
  FetchWeather(this._city);

}
//after searching city, then reset for again search
class ResetWeather extends WeatherEvent {
 
}
//not search state 
class WeatherIsNotSearched extends WeatherState {}

//weather is loading 
class WeatherIsLoading extends WeatherState {}

class WeatherIsLoaded extends WeatherState {
  final _weather;
  //Constructor
  WeatherIsLoaded(this._weather);  
  WeatherModel get getWeather => _weather;
}

//case of api error
class WeatherIsNotLoaded extends WeatherState {}

//bloc style of bloc after 8 pubspec.yaml
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherData weatherData;

  WeatherBloc(this.weatherData) : super(WeatherIsNotSearched()) {
    on<FetchWeather>(_onFetchWeather);
  }

  //data getting from repository 
  void _onFetchWeather(FetchWeather event, emit) async {
    emit(WeatherIsLoading());
    try {
      //pass here of city name 
      final weather = await weatherData.getWeather(event._city);
      emit(WeatherIsLoaded(weather));
    } catch (_) {
      //incase of any error 
      emit(WeatherIsNotLoaded());
    }
  }
}

