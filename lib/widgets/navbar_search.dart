
// widgets/navbar_search.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/forecast_location.dart';
import '../services/favorites_services.dart';
import '../services/location_services.dart';
import '../theme/app_theme.dart';
import '../utils/screen_logger.dart';

/// A widget that provides a search bar for finding locations and displaying suggestions.
class NavbarSearch extends StatefulWidget {
  const NavbarSearch({
    super.key,
    required this.onLocationSelected,
  });

  /// Callback function triggered when a location is selected.
  /// Provides: address, latitude, longitude, placeId, mainText, secondaryText
  final Function(String, double, double, String, String, String) onLocationSelected;

  @override
  NavbarSearchState createState() => NavbarSearchState();
}

class NavbarSearchState extends State<NavbarSearch> {
  List<Map<String, dynamic>> suggestions = [];
  List<ForecastLocation> favorites = [];
  late String sessionToken;
  final Uuid uuid = const Uuid();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    sessionToken = uuid.v4();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) resetSessionToken();
    });
    _loadFavorites();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Resets the session token for the location search.
  void resetSessionToken() {
    setState(() {
      sessionToken = uuid.v4();
    });
  }

  /// Loads favorite locations from storage.
  void _loadFavorites() async {
    final loadedFavorites = await FavoritesManager.getFavorites();
    setState(() {
      favorites = loadedFavorites;
    });
  }

  /// Fetches location suggestions based on the input text.
  void fetchSuggestions(String input) async {
    if (input.isNotEmpty) {
      try {
        List<Map<String, dynamic>> newSuggestions = await LocationServices.getSuggestions(input, sessionToken);
        setState(() {
          suggestions = newSuggestions;
        });
      } catch (e) {
        logOnScreen('Error fetching suggestions: $e');
      }
    } else {
      setState(() {
        suggestions = [];
      });
    }
  }

  /// Fetches details for a selected place and triggers the location selection callback.
  void fetchPlaceDetails(String placeId, String mainText, String secondaryText) async {
    try {
      final placeDetails = await LocationServices.getPlaceDetails(placeId);
      widget.onLocationSelected(
        placeDetails['formatted_address'],
        placeDetails['latitude'],
        placeDetails['longitude'],
        placeId,
        mainText,
        secondaryText,
      );
    } catch (e) {
      logOnScreen('Error fetching place details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Focus(
        focusNode: _focusNode,
        child: SearchAnchor.bar(
          barHintText: 'Rechercher une ville, un pays...',
          suggestionsBuilder: (BuildContext context, SearchController controller) async {
            final input = controller.text;
            if (input.isEmpty && favorites.isNotEmpty) {
              return favorites.map((favorite) {
                return ListTile(
                  title: Text(favorite.mainText, style: AppTheme.bodyLarge),
                  subtitle: Text(favorite.secondaryText, style: AppTheme.bodyMedium),
                  trailing: const Icon(Icons.favorite, color: Colors.grey),
                  onTap: () {
                    controller.closeView(favorite.mainText);
                    widget.onLocationSelected(
                      favorite.mainText,
                      favorite.latitude,
                      favorite.longitude,
                      favorite.placeId,
                      favorite.mainText,
                      favorite.secondaryText,
                    );
                  },
                );
              }).toList();
            } else if (input.isNotEmpty) {
              fetchSuggestions(input);
              return suggestions.map((suggestion) {
                final mainText = suggestion['main_text'] ?? '';
                final secondaryText = suggestion['secondary_text'] ?? '';
                final isFavorite = favorites.any((fav) => fav.placeId == suggestion['place_id']);
                return ListTile(
                  title: Text(mainText, style: AppTheme.bodyLarge),
                  subtitle: Text(secondaryText, style: AppTheme.bodyMedium),
                  trailing: isFavorite ? const Icon(Icons.favorite, color: Colors.grey) : null,
                  onTap: () {
                    controller.closeView(suggestion['description']);
                    fetchPlaceDetails(
                      suggestion['place_id'],
                      suggestion['main_text'],
                      suggestion['secondary_text']
                    );
                  },
                );
              }).toList();
            }
            return [];
          },
        ),
      ),
    );
  }
}
