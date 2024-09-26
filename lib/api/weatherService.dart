import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String domain = 'api.openweathermap.org';
  final String path = 'data/2.5/weather';
  final String apikey = 'cfe894b0f1ea118bb437bbf56e147572';

  Future<Map<String, dynamic>> getWeather(String location) async {
    Map<String, String> parameters = {
      'q': location,
      'appid': apikey,
      'units': 'metric' // 섭씨로 설정
    };
    Uri uri = Uri.https(domain, path, parameters);
    http.Response result = await http.get(uri);

    if (result.statusCode == 200) {
      return json.decode(result.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}