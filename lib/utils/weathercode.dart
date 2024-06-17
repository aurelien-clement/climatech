
// utils/weathercode.dart

import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

/// Returns a French description for the given weather code.
String getWeatherDescriptionFR(int weathercode) {
  final int wc = weathercode >= 10 ? weathercode ~/ 10 : weathercode;
  switch (wc) {
    case 0:   case 1: return 'Dégagé';
    case 2:   return 'Nuageux';
    case 3:   return 'Couvert';
    case 4:   return 'Brouillard';
    case 5:   return 'Bruine';
    case 6:   return weathercode <= 65 ? 'Pluie' : 'Pluie verglaçante';
    case 7:   return 'Neige';
    case 8:   return weathercode <= 82 ? 'Averses' : 'Averses de neige';
    case 9:   return 'Orage';
    default:  return 'Inconnu';
  }
}

/// Returns an icon representing the weather for the given weather code.
IconData getWeatherIcon(int weathercode, { bool isDay = true }) {
  if (weathercode == 85 || weathercode == 86) weathercode = 79;
  // Move 85 & 86 codes ("snow showers") to the unused 79 code.
  // After that, all the 7X are snowy and all the 6X & 8X are rainy
  // So we can only use the tens digit to get the matching symbol.

  final int wc = weathercode >= 10 ? weathercode ~/ 10 : weathercode;
  switch (wc) {
    case 0:   case 1: return isDay ? Symbols.clear_day : Symbols.clear_night;
    case 2:   return isDay ? Symbols.partly_cloudy_day : Symbols.partly_cloudy_night;
    case 3:   return Symbols.cloud;
    case 4:   case 5: return Symbols.foggy;
    case 6:   case 8: return Symbols.rainy;
    case 7:   return Symbols.cloudy_snowing;
    case 9:   return Symbols.thunderstorm;
    default:  return Symbols.sentiment_frustrated;
  }
}
