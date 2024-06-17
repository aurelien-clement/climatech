
// constants.dart

import 'package:flutter/material.dart'; // needed for Color class

// Some breakpoints
const double kContentMaxWidth = 1200.0;
const double kTouchpadBreakpoint = 850.0;
const double kMobileBreakpoint = 600.0;

// Colors for graphs in the ForecastTabChart
  const Map<String, Color> kChartColors = {
    'temperature': Colors.red,
    'feltTemperature': Colors.orange,
    'humidity': Colors.blue,
    'windSpeed': Colors.green,
    'pressure': Colors.purple,
    'precipitation': Colors.lightBlue,
    'cloudCover': Colors.grey,
  };