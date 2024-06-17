
// models/forecast_hour.dart

/// Class representing the weather forecast for a single hour.
class ForecastHour {
  final double temperature;
  final double feltTemperature;
  final double humidity;
  final double windSpeed;
  final double windDirection;
  final double pressure;
  final double precipitation;
  final double cloudCover;
  final int weathercode;

  ForecastHour({
    required this.temperature,
    required this.feltTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.precipitation,
    required this.cloudCover,
    required this.weathercode,
  });

  /// Convert the forecast hour data to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feltTemperature': feltTemperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'pressure': pressure,
      'precipitation': precipitation,
      'cloudCover': cloudCover,
      'weathercode': weathercode,
    };
  }

  /// French translations for the weather properties.
  static final Map<String, String> namesFR = {
    'temperature': 'Température',
    'feltTemperature': 'Température ressentie',
    'humidity': 'Humidité',
    'windSpeed': 'Vitesse du vent',
    'windDirection': 'Direction du vent',
    'pressure': 'Pression',
    'precipitation': 'Précipitations',
    'cloudCover': 'Couverture nuageuse',
    'weathercode': 'Code météo',
  };

  /// Get the French name for a given property key.
  static String getNameFR(String key) {
    return namesFR[key] ?? key;
  }
}
