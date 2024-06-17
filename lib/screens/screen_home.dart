
// screens/screen_home.dart

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../constants.dart';
import '../models/forecast_day.dart';
import '../models/forecast_location.dart';
import '../models/ui_states.dart';
import '../services/favorites_services.dart';
import '../services/location_services.dart';
import '../services/weather_services.dart';
import '../theme/app_theme.dart';
import '../utils/screen_logger.dart';
import '../widgets/navbar_search.dart';
import '../widgets/section_forecasts.dart';
import '../widgets/section_location.dart';

/// Main screen of the app that displays weather information and allows location search.
class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  ScreenHomeState createState() => ScreenHomeState();
}

class ScreenHomeState extends State<ScreenHome> {
  Map<DateTime, ForecastDay>? forecasts;
  Map<String, String>? hourlyUnits;
  late ForecastLocation location;
  int? currentWeathercode;
  double? currentTemperature;
  late UiStates uiStates;
  bool isFavorite = false;
  bool isLoading = false;
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    _initializeState();
    _initializeDefaultLocation();
  }

  /// Initializes the UI states and default values.
  void _initializeState() {
    DateTime now = DateTime.now();
    DateTime nowDay = DateTime(now.year, now.month, now.day);
    uiStates = UiStates(
      dateRangeMax: DateTimeRange(start: nowDay.subtract(const Duration(days: 60)), end: nowDay.add(const Duration(days: 12))),
      dateRangeList: DateTimeRange(start: nowDay, end: nowDay.add(const Duration(days: 7))),
      dateRangeChart: DateTimeRange(start: nowDay, end: nowDay.add(const Duration(days: 7))),
      visibleDays: 7,
      isImperialUnit: false,
    );
    location = ForecastLocation(
      mainText: '',
      secondaryText: '',
      latitude: 0.0,
      longitude: 0.0,
      placeId: '',
    );
  }

  /// Initializes the default favorite location.
  void _initializeDefaultLocation() async {
    await FavoritesManager.initializeDefaultFavorite();
    _checkIfFavorite();
  }

  /// Handles the selection of a location.
  void handleLocationSelection(
      String address,
      double lat,
      double lng,
      String placeId,
      String mainText,
      String secondaryText) async {
    setState(() {
      isLoading = true;
    });
    try {
      final selectedLocation = await LocationServices.selectLocation(
        address, lat, lng, placeId, mainText, secondaryText);
      setState(() {
        location = selectedLocation;
      });
      await fetchWeather(forceRequest: true);
    } catch (e) {
      logOnScreen('Error fetching weather forecast: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Fetches weather data for the selected location.
  Future<void> fetchWeather({bool forceRequest = false, bool targetRangeList = true}) async {
    setState(() {
      isLoading = true;
    });

    bool dataExists = true;
    DateTimeRange targetRange = targetRangeList ? uiStates.dateRangeList : uiStates.dateRangeChart;

    for (int i = 0; i < uiStates.visibleDays; i++) {
      DateTime day = targetRange.start.add(Duration(days: i));
      if (forecasts == null || !forecasts!.containsKey(day)) {
        dataExists = false;
        break;
      }
    }

    if (dataExists && !forceRequest) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final (
          fetchedCurrentTemperature,
          fetchedCurrentWeathercode,
          fetchedForecasts,
          fetchedUnits,
          ) = await FetchForecast.getForecast(
        location.latitude,
        location.longitude,
        targetRange.start,
        targetRange.duration.inDays,
      );

      setState(() {
        currentTemperature = fetchedCurrentTemperature;
        currentWeathercode = fetchedCurrentWeathercode;
        forecasts = {...?forecasts, ...fetchedForecasts};
        hourlyUnits = fetchedUnits;
      });

      _selectInitialDay();
      await _checkIfFavorite();
    } catch (e) {
      logOnScreen('Error fetching weather forecast: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  /// Selects the initial day for the forecast.
  void _selectInitialDay() {
    if (forecasts != null && forecasts!.isNotEmpty) {
      setState(() {
        selectedDay = uiStates.dateRangeList.start;
      });
    }
  }

  /// Loads the previous days in the forecast list.
  void onPreviousDays() {
    setState(() {
      uiStates.changeDateRangeList(previous: true);
      selectedDay = uiStates.dateRangeList.start;
    });
    fetchWeather(targetRangeList: true);
  }

  /// Loads the next days in the forecast list.
  void onNextDays() {
    setState(() {
      uiStates.changeDateRangeList(previous: false);
      selectedDay = uiStates.dateRangeList.start;
    });
    fetchWeather(targetRangeList: true);
  }

  /// Handles the change in the chart date range.
  Future<void> onChartRangeChanged(DateTimeRange newRange) async {
    if (newRange.start.isBefore(uiStates.dateRangeMax.start) ||
        newRange.end.isAfter(uiStates.dateRangeMax.end)) return;
    setState(() {
      uiStates.dateRangeChart = DateTimeRange(start: newRange.start, end: newRange.end);
    });
    await fetchWeather(targetRangeList: false);
  }

  /// Toggles the favorite status of the current location.
  void _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });
    await FavoritesManager.toggleFavorite(location, isFavorite);
  }

  /// Checks if the current location is a favorite.
  Future<void> _checkIfFavorite() async {
    final favoriteStatus = await FavoritesManager.checkIfFavorite(location);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < kMobileBreakpoint;
    bool isTouchpad = MediaQuery.of(context).size.width < kTouchpadBreakpoint;
    double screenHeight = MediaQuery.of(context).size.height;
    double heroHeight = isMobile ? screenHeight * 0.3 : screenHeight * 0.2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: kTouchpadBreakpoint),
              child: Row(
                children: [
                  if (forecasts != null)
                    IconButton(
                      icon: Icon(
                        Symbols.favorite,
                        fill: isFavorite ? 1.0 : 0.0,
                        size: 48,
                        color: Theme.of(context).colorScheme.onPrimary,
                        weight: 2,
                      ),
                      onPressed: _toggleFavorite,
                    )
                  else
                    const SizedBox(height: 1),
                  Expanded(
                    child: NavbarSearch(
                      onLocationSelected: (address, lat, lng, placeId, mainText, secondaryText) {
                        handleLocationSelection(address, lat, lng, placeId, mainText, secondaryText);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3F6EB5), Color(0xff3F51B5), Color(0xff3F51B5), Color(0xff4B3FB5)],
                stops: [0, 0.25, 0.75, 1],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: heroHeight,
                  constraints: BoxConstraints(minHeight: isMobile ? 300.0 : 200.0),
                  child: SectionLocation(
                    isMobile: isMobile,
                    location: location,
                    currentTemperature: currentTemperature,
                    currentWeathercode: currentWeathercode,
                    hourlyUnits: hourlyUnits,
                  ),
                ),
                Expanded(
                  child: forecasts != null
                      ? SectionForecasts(
                          isMobile: isMobile,
                          isTouchpad: isTouchpad,
                          uiStates: uiStates,
                          forecasts: forecasts,
                          hourlyUnits: hourlyUnits,
                          loadPrevious: onPreviousDays,
                          loadNext: onNextDays,
                          onChartRangeChanged: onChartRangeChanged,
                          selectedDay: selectedDay,
                          onDaySelected: (day) {
                            setState(() {
                              selectedDay = day;
                            });
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Choose a location to display the data",
                              textAlign: TextAlign.center,
                              style: AppTheme.heroSubtitle(isMobile),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

