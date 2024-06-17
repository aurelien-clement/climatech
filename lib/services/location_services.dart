
// services/location_services.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/forecast_location.dart';
import '../services/weather_services.dart';
import '../utils/screen_logger.dart';

/// Fetches place suggestions and details from Google Maps API.
class LocationServices {
  /// Fetches place suggestions based on input.
  static Future<List<Map<String, dynamic>>> getSuggestions(String input, String sessionToken) async {
    // Get API key and URL from environment variables
    final apiKey = dotenv.env['MAPS_API_KEY'];
    final baseUrl = dotenv.env['MAPS_PLACES_API_URL'];
    
    // Verify that the API key and URL are set
    if (apiKey == null) throw Exception('API key is not set.');
    if (baseUrl == null) throw Exception('API URL is not set.');

    // Create request URL and trigger the request
    final url = '$baseUrl?input=$input&key=$apiKey&sessiontoken=$sessionToken&locationbias';
    final response = await http.get(Uri.parse(url));

    // Process response
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List predictions = data['predictions'];
      return predictions.map<Map<String, dynamic>>((p) => {
        'description': p['description'] ?? '',
        'place_id': p['place_id'] ?? '',
        'main_text': p['structured_formatting']['main_text'] ?? '',
        'secondary_text': p['structured_formatting']['secondary_text'] ?? '',
      }).toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  /// Fetches place details based on place ID.
  static Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    // Get API key and URL from environment variables
    final apiKey = dotenv.env['MAPS_API_KEY'];
    final baseUrl = dotenv.env['MAPS_DETAILS_API_URL'];

    // Verify that the API key and URL are set
    if (apiKey == null) throw Exception('API key is not set.');
    if (baseUrl == null) throw Exception('API URL is not set.');

    // Create request URL and trigger the request
    final url = '$baseUrl?placeid=$placeId&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    // Process response
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['result'];
      final location = result['geometry']['location'];
      return {
        'latitude': location['lat'],
        'longitude': location['lng'],
        'formatted_address': result['formatted_address']
      };
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  /// Manages location selection and fetching weather data.
  static Future<ForecastLocation> selectLocation(
      String address,
      double lat,
      double lng,
      String placeId,
      String mainText,
      String secondaryText) async {
    final location = ForecastLocation(
      mainText: mainText,
      secondaryText: secondaryText,
      latitude: lat,
      longitude: lng,
      placeId: placeId,
    );

    try {
      await FetchForecast.getForecast(
        location.latitude,
        location.longitude,
        DateTime.now(),
        7,
      );
      return location;
    } catch (e) {
      logOnScreen('Error fetching weather forecast: $e');
      rethrow;
    }
  }
}
