
// models/forecast_location.dart

import 'dart:convert';

/// Class representing the location context for the weather forecast.
class ForecastLocation {
  final String mainText;
  final String secondaryText;
  final double latitude;
  final double longitude;
  final String placeId;

  ForecastLocation({
    required this.mainText,
    required this.secondaryText,
    required this.latitude,
    required this.longitude,
    required this.placeId,
  });

  /// Convert the location data to JSON format.
  String toJson() {
    return jsonEncode({
      'mainText': mainText,
      'secondaryText': secondaryText,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
    });
  }

  /// Create a ForecastLocation object from JSON data.
  static ForecastLocation fromJson(String json) {
    final data = jsonDecode(json);
    return ForecastLocation(
      mainText: data['mainText'],
      secondaryText: data['secondaryText'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      placeId: data['placeId'],
    );
  }
}
