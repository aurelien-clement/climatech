
// models/forecast_day.dart

import 'forecast_hour.dart';

/// Class representing the weather forecast for a single day.
class ForecastDay {
  final double temperatureMin;
  final double temperatureMax;
  final String sunsetTimeStr;
  final String sunriseTimeStr;
  final int weathercode;
  final List<ForecastHour> hourly;

  ForecastDay({
    required this.temperatureMin,
    required this.temperatureMax,
    required this.sunsetTimeStr,
    required this.sunriseTimeStr,
    required this.weathercode,
    required this.hourly,
  });
}
