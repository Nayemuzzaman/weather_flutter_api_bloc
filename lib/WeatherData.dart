import 'package:weather_flutter_api_bloc/WeatherModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherData {
  Future<WeatherModel> getWeather(String city) async {
    //call api & url of api
    final result = await http.Client().get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=43ea6baaad7663dc17637e22ee6f78f2'));

    //check the status of api
    // if doesnot return 200 throw exception. 
    if (result.statusCode != 200) {
      throw Exception();
    }
    // it return api whole content
    return parsedJson(result.body);

  }
  //parse, decode json object into weatherModel
     WeatherModel parsedJson(final response) {
      final jsonDecoded = json.decode(response);

      //main have temp,pressure,humidity,temp_min, temp_max object 
      final jsonWeather = jsonDecoded["main"];
      //receve response from http call
      return WeatherModel.fromJson(jsonWeather);
    }
}
