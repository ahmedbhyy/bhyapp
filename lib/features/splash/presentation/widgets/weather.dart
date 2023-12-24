import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);
  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  String? username;

  final WeatherService weatherService =
      WeatherService('93121a5cf45f14b42696b5f1e84d605d');

  late Future<Weather> tunisWeather;
  late Future<Weather> nabeulWeather;
  late Future<Weather> kebiliWeather;
  late Future<Weather> kasserineWeather;
  late Future<Weather> sidiBouzidWeather;
  late Future<Weather> gafsaWeather;

  @override
  void initState() {
    super.initState();
    tunisWeather = weatherService.getWeather('Tunis');
    nabeulWeather = weatherService.getWeather('Nabeul');
    kebiliWeather = weatherService.getWeather('Kebili');
    kasserineWeather = weatherService.getWeather('kasserine');
    sidiBouzidWeather = weatherService.getWeather('Sidi Bouzid');
    gafsaWeather = weatherService.getWeather('Gafsa');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/weather2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: Platform.isAndroid
            ? EdgeInsets.all(0)
            : EdgeInsets.fromLTRB(350, 100, 350, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildWeatherCard('Tunis', tunisWeather),
            _buildWeatherCard('Nabeul', nabeulWeather),
            _buildWeatherCard('Kebili', kebiliWeather),
            _buildWeatherCard('Kasserine', kasserineWeather),
            _buildWeatherCard('Sidi Bouzid', sidiBouzidWeather),
            _buildWeatherCard('Gafsa', gafsaWeather),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(String location, Future<Weather> weather) {
    return FutureBuilder<Weather>(
      future: weather,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final weather = snapshot.data!;
          return Card(
            child: ListTile(
              title: Text(location),
              subtitle:
                  Text('${weather.temperature}°C - ${weather.description}'),
              trailing: _weatherIcon(weather.description),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading weather data');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Icon _weatherIcon(String weatherDescription) {
    switch (weatherDescription.toLowerCase()) {
      case 'clear sky':
        return const Icon(Icons.wb_sunny);
      case 'few clouds':
        return const Icon(Icons.cloud);
      case 'scattered clouds':
        return const Icon(Icons.cloud);
      case 'broken clouds':
        return const Icon(Icons.cloud_queue);
      case 'shower rain':
        return const Icon(Icons.thunderstorm);
      case 'rain':
        return const Icon(Icons.thunderstorm);
      case 'thunderstorm':
        return const Icon(Icons.thunderstorm);
      case 'snow':
        return const Icon(Icons.ac_unit);
      case 'mist':
        return const Icon(Icons.cloud_circle);
      default:
        return const Icon(Icons.wb_sunny);
    }
  }
}

class Weather {
  final String location;
  final double temperature;
  final String description;

  Weather(
      {required this.location,
      required this.temperature,
      required this.description});
}

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather(
        location: data['name'],
        temperature: data['main']['temp'],
        description: data['weather'][0]['description'],
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
