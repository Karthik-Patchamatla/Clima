import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherDetails extends StatelessWidget {
  final double? windSpeed;
  final String? time;
  final int? humidity;
  final double? aqi;
  final double? uvIndex;
  final String? sunsetTime;

  const WeatherDetails({
    Key? key,
    this.windSpeed,
    this.time,
    this.humidity,
    this.aqi,
    this.uvIndex,
    this.sunsetTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(
          icon: Icons.air,
          label: "Wind Speed",
          value: "${windSpeed ?? 'N/A'} m/s",
        ),
        _buildDetailItem(
          icon: Icons.access_time,
          label: "Local Time",
          value: time ?? 'N/A',
        ),
        _buildDetailItem(
          icon: Icons.water_drop,
          label: "Humidity",
          value: "${humidity ?? 'N/A'}%",
        ),
        _buildDetailItem(
          icon: Icons.cloud,
          label: "Air Quality Index (AQI)",
          value: aqi?.toStringAsFixed(1) ?? 'N/A',
        ),
        _buildDetailItem(
          icon: Icons.wb_sunny,
          label: "UV Index",
          value: uvIndex?.toStringAsFixed(1) ?? 'N/A',
        ),
        _buildDetailItem(
          icon: Icons.nightlight_round,
          label: "Sunset Time",
          value: 'N/A',
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Fetch weather data from OpenWeatherMap API
  static Future<Map<String, dynamic>> fetchWeatherData(String cityName) async {
    const apiKey = '6c7d31ffecadabae9ea5f6ce459de5bb'; // Replace with your OpenWeatherMap API key
    final weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';
    final airQualityUrl =
        'https://api.openweathermap.org/data/2.5/air_pollution?lat={latitude}&lon={longitude}&appid=$apiKey';
    final uvIndexUrl =
        'https://api.openweathermap.org/data/2.5/uvi?lat={latitude}&lon={longitude}&appid=$apiKey';

    try {
      // Fetch weather data
      final weatherResponse = await http.get(Uri.parse(weatherUrl));
      final weatherData = json.decode(weatherResponse.body);

      if (weatherData['coord'] == null) {
        throw Exception("Invalid city name or API response format");
      }

      // Get latitude and longitude
      final double lat = weatherData['coord']['lat'];
      final double lon = weatherData['coord']['lon'];

      // Fetch air quality data
      final airQualityResponse = await http.get(Uri.parse(airQualityUrl
          .replaceFirst("{latitude}", lat.toString())
          .replaceFirst("{longitude}", lon.toString())));
      final airQualityData = json.decode(airQualityResponse.body);

      // Fetch UV index data
      final uvIndexResponse = await http.get(Uri.parse(uvIndexUrl
          .replaceFirst("{latitude}", lat.toString())
          .replaceFirst("{longitude}", lon.toString())));
      final uvIndexData = json.decode(uvIndexResponse.body);

      // Extract necessary data
      final double windSpeed = weatherData['wind']['speed'] ?? 0.0;
      final int humidity = weatherData['main']['humidity'] ?? 0;
      final double aqi = airQualityData['list'][0]['main']['aqi'] ?? 0.0;
      final double uvIndex = uvIndexData['value'] ?? 0.0;
      final String sunsetTime = DateTime.fromMillisecondsSinceEpoch(weatherData['sys']['sunset'] * 1000)
          .toLocal()
          .toString();

      return {
        'windSpeed': windSpeed,
        'humidity': humidity,
        'aqi': aqi,
        'uvIndex': uvIndex,
        'sunsetTime': sunsetTime,
      };
    } catch (e) {
      print('Error fetching weather data: $e');
      return {};
    }
  }
}
