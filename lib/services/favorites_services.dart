
// services/favorites_services.dart

import 'package:shared_preferences/shared_preferences.dart';
import '../models/forecast_location.dart';

/// Manages favorite locations using shared preferences.
class FavoritesManager {
  static const String favoritesKey = 'favorites';

  /// Default location used if no favorites are set.
  static ForecastLocation defaultLocation = ForecastLocation(
    mainText: 'AquaTech Innovation',
    secondaryText: 'Cap Alpha, Avenue de l\'Europe, Clapiers, France',
    latitude: 43.6607695,
    longitude: 3.9007233,
    placeId: 'ChIJjYP3XvqvthIRbUmooM1-QgM',
  );

  /// Adds a location to the list of favorites.
  static Future<void> addFavorite(ForecastLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(favoritesKey) ?? [];
    final locationJson = location.toJson();
    if (!favorites.contains(locationJson)) {
      favorites.add(locationJson);
      await prefs.setStringList(favoritesKey, favorites);
    }
  }

  /// Removes a location from the list of favorites.
  static Future<void> removeFavorite(ForecastLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(favoritesKey) ?? [];
    final locationJson = location.toJson();
    if (favorites.contains(locationJson)) {
      favorites.remove(locationJson);
      await prefs.setStringList(favoritesKey, favorites);
    }
  }

  /// Retrieves the list of favorite locations.
  static Future<List<ForecastLocation>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(favoritesKey) ?? [];
    return favorites.map((locationJson) => ForecastLocation.fromJson(locationJson)).toList();
  }

  /// Initializes the default favorite location.
  static Future<void> initializeDefaultFavorite() async {
    await addFavorite(defaultLocation);
  }

  /// Toggles the favorite status of a location.
  static Future<void> toggleFavorite(ForecastLocation location, bool isFavorite) async {
    isFavorite
        ? await addFavorite(location)
        : await removeFavorite(location);
  }

  /// Checks if a location is in the list of favorites.
  static Future<bool> checkIfFavorite(ForecastLocation location) async {
    final favorites = await getFavorites();
    return favorites.any((favorite) => favorite.placeId == location.placeId);
  }
}
