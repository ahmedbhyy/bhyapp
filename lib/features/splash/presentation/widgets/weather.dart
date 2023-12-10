import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:bhyapp/features/splash/presentation/widgets/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: use_key_in_widget_constructors
class WeatherPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  int _selectedIndex = 1;
  String? username;
  void _navigateBottomBar(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final WeatherService weatherService =
      WeatherService('93121a5cf45f14b42696b5f1e84d605d');

  // ignore: non_constant_identifier_names
  late Future<Weather> TunisWeather;
  late Future<Weather> nabeulWeather;
  // ignore: non_constant_identifier_names
  late Future<Weather> KebiliWeather;
  late Future<Weather> kasserineWeather;

  @override
  void initState() {
    super.initState();
    TunisWeather = weatherService.getWeather('Tunis');
    nabeulWeather = weatherService.getWeather('Nabeul');
    KebiliWeather = weatherService.getWeather('Kebili');
    kasserineWeather = weatherService.getWeather('kasserine');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/weather.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWeatherCard('Tunis', TunisWeather),
              _buildWeatherCard('Nabeul', nabeulWeather),
              _buildWeatherCard('Kebili', KebiliWeather),
              _buildWeatherCard('Kasserine', kasserineWeather),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          backgroundColor: Colors.white,
          color: Colors.green,
          animationDuration: const Duration(milliseconds: 300),
          onTap: _navigateBottomBar,
          index: _selectedIndex,
          items: const [
            Icon(
              Icons.home,
              color: Colors.black,
            ),
            Icon(
              Icons.wb_sunny,
              color: Colors.black,
            ),
            Icon(
              Icons.person,
              color: Colors.black,
            ),
          ]),
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
