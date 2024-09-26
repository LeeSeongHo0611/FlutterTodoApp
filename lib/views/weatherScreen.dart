import 'package:flutter/material.dart';
import 'package:todo_list/api/weatherService.dart'; // 날씨 api 호출

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String location = 'Seoul';
  String weatherInfo = 'Loading...';
  String weatherIconUrl = '';
  bool isLoading = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
    });

    WeatherService weatherService = WeatherService();
    try {
      Map<String, dynamic> data = await weatherService.getWeather(location);
      setState(() {
        double temperature = data['main']['temp'];
        double maxTemp = data['main']['temp_max'];
        double minTemp = data['main']['temp_min'];
        int humidity = data['main']['humidity'];
        double rainProbability = data['rain'] != null ? data['rain']['1h'] ?? 0.0 : 0.0;

        weatherInfo = '온도: ${temperature.toStringAsFixed(1)}°C\n'
            '최고 기온: ${maxTemp.toStringAsFixed(1)}°C\n'
            '최저 기온: ${minTemp.toStringAsFixed(1)}°C\n'
            '습도: $humidity%\n'
            '강수량(1시간): ${rainProbability.toStringAsFixed(1)} mm\n'
            '날씨: ${data['weather'][0]['description']}';
        String iconCode = data['weather'][0]['icon'];
        weatherIconUrl = 'http://openweathermap.org/img/wn/$iconCode@2x.png';
      });
    } catch (e) {
      setState(() {
        weatherInfo = 'Failed to load weather data';
        weatherIconUrl = '';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateWeather() {
    setState(() {
      location = _controller.text;
      weatherInfo = 'Loading...';
      weatherIconUrl = '';
    });
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold 추가
      appBar: AppBar(
        title: Text('Weather'),
      ),
      body: Center(
        child: SingleChildScrollView( // 화면이 작을 때 스크롤 가능하도록 처리
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '도시를 입력하세요.',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: updateWeather,
                child: Text('날씨 보기'),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator() // 로딩 중인 경우
                  : Column(
                children: [
                  if (weatherIconUrl.isNotEmpty)
                    Image.network(weatherIconUrl, height: 100),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      weatherInfo,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
