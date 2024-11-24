import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'weather_service.dart';
import 'weather_details.dart';
import 'weather_icon.dart';
import 'weather_suggestion.dart'; // Import the weather_suggestion.dart file

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String? cityName;
  String? temperature;
  String? description;
  double? windSpeed;
  String? time;
  int? humidity;
  double? aqi;
  double? uvIndex;
  String? sunsetTime;
  bool isLoading = true;
  IconData weatherIcon = Icons.cloud; // Default icon for weather
  String suggestionMessage = ''; // Default suggestion message

  @override
  void initState() {
    super.initState();
    fetchWeatherByLocation();
  }

  // Fetch weather data by city name
  void fetchWeatherByCity() async {
    if (cityName == null || cityName!.isEmpty) return;
    setState(() {
      isLoading = true;
    });

    try {
      var weather = await WeatherService.fetchWeatherByCity(cityName!);
      print('Weather data fetched: $weather'); // Debugging print

      setState(() {
        isLoading = false;
        temperature = weather['main']['temp'].toString();
        description = weather['weather'][0]['description'];
        windSpeed = weather['wind']['speed'];
        time = weather['time'];
        humidity = weather['main']['humidity'];
        aqi = weather['aqi']; // AQI value
        uvIndex = weather['uv_index']; // UV Index value
        sunsetTime = weather['sunset'];

        // Set the weather icon and suggestion message
        weatherIcon = WeatherIconHelper.getWeatherIcon(description ?? '');
        suggestionMessage = getSuggestionMessage(
            description ?? '', double.tryParse(temperature ?? '0') ?? 0);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        temperature = null;
        description = null;
        windSpeed = null;
        time = null;
        humidity = null;
        aqi = null;
        uvIndex = null;
        sunsetTime = null;
      });
      print('Error fetching weather: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching weather data!'),
      ));
    }
  }

  // Fetch weather data by location
  void fetchWeatherByLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      var position = await WeatherService.getCurrentPosition();
      var weather = await WeatherService.fetchWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      setState(() {
        isLoading = false;
        cityName = weather['name'];
        temperature = weather['main']['temp'].toString();
        description = weather['weather'][0]['description'];
        windSpeed = weather['wind']['speed'];
        time = weather['time'];
        humidity = weather['main']['humidity'];
        aqi = weather['aqi']; // AQI value
        uvIndex = weather['uv_index']; // UV Index value
        sunsetTime = weather['sunset'];

        // Set the weather icon and suggestion message
        weatherIcon = WeatherIconHelper.getWeatherIcon(description ?? '');
        suggestionMessage = getSuggestionMessage(
            description ?? '', double.tryParse(temperature ?? '0') ?? 0);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching weather: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching weather data!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Clima",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 151, 123, 204),
                  Color(0xFF6CA0DC),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.25, 1.0],
              ),
            ),
          ),

          // Content or Progress Bar
          Center(
            child: isLoading
                ? const SpinKitThreeBounce(
                    color: Colors.white,
                    size: 30.0,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Search Bar
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Enter city name...',
                                hintStyle:
                                    const TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 20.0,
                                ),
                                suffixIcon: Container(
                                  height: 53.0,
                                  width: 53.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFd864ff),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        cityName = _controller.text;
                                        FocusScope.of(context).unfocus();
                                      });
                                      fetchWeatherByCity();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30.0),

                          // Weather Information
                          temperature != null
                              ? Column(
                                  children: [
                                    Text(
                                      capitalizeCityName(
                                          cityName ?? 'City Name'),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 36,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Icon(
                                      weatherIcon,
                                      size: 175,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 15.0),
                                    Text(
                                      '$temperature°C',
                                      style: const TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      description ?? '',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),

                                    // Suggestion Message
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        suggestionMessage,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    const SizedBox(height: 30.0),

                                    // Weather Details
                                    WeatherDetails(
                                      windSpeed: windSpeed ?? 0.0,
                                      humidity: humidity ?? 0,
                                      aqi: aqi ?? 0.0,
                                      uvIndex: uvIndex ?? 0.0,
                                      sunsetTime: sunsetTime ?? '',
                                    ),
                                  ],
                                )
                              : const Text(
                                  'No weather data available.',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String capitalizeCityName(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
}
