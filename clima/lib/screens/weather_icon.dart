import 'package:flutter/material.dart';

class WeatherIconHelper {
  static IconData getWeatherIcon(String description) {
    IconData weatherIcon;

    if (description.contains('rain')) {
      weatherIcon = Icons.grain;
    } else if (description.contains('sun') || description.contains('clear')) {
      weatherIcon = Icons.wb_sunny;
    } else if (description.contains('cloud')) {
      weatherIcon = Icons.cloud;
    } else if (description.contains('snow')) {
      weatherIcon = Icons.ac_unit;
    } else if (description.contains('storm') || description.contains('thunder')) {
      weatherIcon = Icons.bolt;
    } else if (description.contains('fog') || description.contains('mist') || description.contains('haze')) {
      weatherIcon = Icons.blur_on;
    } else if (description.contains('wind')) {
      weatherIcon = Icons.air;
    } else if (description.contains('hail')) {
      weatherIcon = Icons.cloud_queue;
    } else if (description.contains('tornado')) {
      weatherIcon = Icons.rotate_left;
    } else if (description.contains('dust')) {
      weatherIcon = Icons.location_on;
    } else {
      weatherIcon = Icons.help_outline;
    }

    return weatherIcon;
  }
}