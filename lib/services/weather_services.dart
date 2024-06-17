
// services/weather_services.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/forecast_day.dart';
import '../models/forecast_hour.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Fetches weather forecast data from the Open-Meteo API.
class FetchForecast {
  /// Returns the current temperature, weather code, forecast data, and hourly units.
  static Future<(double, int, Map<DateTime, ForecastDay>, Map<String, String>)> getForecast(
    double latitude,
    double longitude,
    DateTime startDate,
    int duration,
    { bool isImperial = false }
  ) async {
    // Get API base URL from environment variables
    final baseUrl = dotenv.env['OPEN_METEO_API_URL'];
    if (baseUrl == null) throw Exception('Open-Meteo API URL is not set.');

    // Set units depending on the given isImperial bool
    final temperatureUnit = isImperial ? 'fahrenheit' : 'celsius';
    final windSpeedUnit = isImperial ? 'mph' : 'kmh';
    final precipitationUnit = isImperial ? 'inch' : 'mm';

    // Convert and add dates if given
    final String start = startDate.toIso8601String().split('T')[0];
    final String end = startDate.add(Duration(days: duration)).toIso8601String().split('T')[0];

    // Create request URL and trigger the request
    String requestUrl =
      '$baseUrl/forecast?latitude=$latitude&longitude=$longitude&timezone=auto'
      '&temperature_unit=$temperatureUnit&wind_speed_unit=$windSpeedUnit&precipitation_unit=$precipitationUnit'
      '&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,weathercode'
      '&hourly=temperature_2m,apparent_temperature,relativehumidity_2m,windspeed_10m,winddirection_10m,pressure_msl,precipitation,cloudcover,weathercode'
      '&current_weather=true&start_date=$start&end_date=$end';
    final response = await http.get(Uri.parse(requestUrl));

    // Process response
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final dailyData = data['daily'];
      final hourlyData = data['hourly'];
      final hourlyUnitsData = data['hourly_units'];
      final int currentWeathercode = data['current_weather']?['weathercode'] ?? -1;
      final double currentTemperature = data['current_weather']?['temperature'] ?? 0.0;
      
      // Map API properties to ForecastHour properties
      final Map<String, String> hourlyUnits = {
        'time':             hourlyUnitsData['time'],
        'temperature':      hourlyUnitsData['temperature_2m'],
        'feltTemperature':  hourlyUnitsData['apparent_temperature'],
        'humidity':         hourlyUnitsData['relativehumidity_2m'],
        'windSpeed':        hourlyUnitsData['windspeed_10m'],
        'windDirection':    hourlyUnitsData['winddirection_10m'],
        'pressure':         hourlyUnitsData['pressure_msl'],
        'precipitation':    hourlyUnitsData['precipitation'],
        'cloudCover':       hourlyUnitsData['cloudcover'],
        'weathercode':      hourlyUnitsData['weathercode']
      };

      Map<DateTime, ForecastDay> forecasts = {};

      // Process daily data
      try {
        for (var i = 0; i < dailyData['time'].length; i++) {
          List<ForecastHour> hours = [];
          for (var j = 0; j < 24; j++) {
            final k = (i * 24) + j;

            hours.add(ForecastHour(
              temperature:      hourlyData['temperature_2m']?[k]?.toDouble() ?? 0.0,
              feltTemperature:  hourlyData['apparent_temperature']?[k]?.toDouble() ?? 0.0,
              humidity:         hourlyData['relativehumidity_2m']?[k]?.toDouble() ?? 0.0,
              windSpeed:        hourlyData['windspeed_10m']?[k]?.toDouble() ?? 0.0,
              windDirection:    hourlyData['winddirection_10m']?[k]?.toDouble() ?? 0.0,
              pressure:         hourlyData['pressure_msl']?[k]?.toDouble() ?? 0.0,
              precipitation:    hourlyData['precipitation']?[k]?.toDouble() ?? 0.0,
              cloudCover:       hourlyData['cloudcover']?[k]?.toDouble() ?? 0.0,
              weathercode:      hourlyData['weathercode']?[k] ?? -1,
            ));
          }
          final day = DateTime.parse(dailyData['time'][i]);
          forecasts[day] = ForecastDay(
            temperatureMin: dailyData['temperature_2m_min'][i].toDouble(),
            temperatureMax: dailyData['temperature_2m_max'][i].toDouble(),
            sunsetTimeStr: _getTimeFromIso(dailyData['sunset'][i]),
            sunriseTimeStr: _getTimeFromIso(dailyData['sunrise'][i]),
            weathercode: dailyData['weathercode'][i],
            hourly: hours,
          );
        }
      } catch(e) {
        throw Exception('Failed to fetch weather forecast: $e');
      }
      return (currentTemperature, currentWeathercode, forecasts, hourlyUnits);
    } else {
      throw Exception('Failed to fetch weather forecast: ${response.statusCode}');
    }
  }
}

/// Extracts "HH:MM" from ISO date string.
String _getTimeFromIso(String isoTimeString) {
  final dateTime = DateTime.parse(isoTimeString);
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}
