
// // models/forecast_data.dart


// import 'dart:convert';


// // WEATHER DATA (hourly) ---------------------------------------------
// // Weather data for each hour of a day
// // -------------------------------------------------------------------
// class ForecastHour {
//   // final String time;
//   final double temperature;
//   final double feltTemperature;
//   final double humidity;
//   final double windSpeed;
//   final double windDirection;
//   final double pressure;
//   final double precipitation;
//   final double cloudCover;
//   final int weathercode;

//     ForecastHour({
//     // required this.time,
//     required this.temperature,
//     required this.feltTemperature,
//     required this.humidity,
//     required this.windSpeed,
//     required this.windDirection,
//     required this.pressure,
//     required this.precipitation,
//     required this.cloudCover,
//     required this.weathercode,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'temperature': temperature,
//       'feltTemperature': feltTemperature,
//       'humidity': humidity,
//       'windSpeed': windSpeed,
//       'windDirection': windDirection,
//       'pressure': pressure,
//       'precipitation': precipitation,
//       'cloudCover': cloudCover,
//       'weathercode': weathercode,
//     };
//   }

//   // Add a static Map for properties displayable names
//   static final Map<String, String> namesFR = {
//     'temperature': 'Température',
//     'feltTemperature': 'Température ressentie',
//     'humidity': 'Humidité',
//     'windSpeed': 'Vitesse du vent',
//     'windDirection': 'Direction du vent',
//     'pressure': 'Pression',
//     'precipitation': 'Précipitations',
//     'cloudCover': 'Couverture nuageuse',
//     'weathercode': 'Code météo',
//   };

//   // Getter pour accéder aux traductions
//   static String getNameFR(String key) {
//     return namesFR[key] ?? key;
//   }
// }


// // WEATHER DATA (daily) ----------------------------------------------
// // Hour data aggregations made by open-meteo
// // -------------------------------------------------------------------
// class ForecastDay {
//   final double temperatureMin;
//   final double temperatureMax;
//   final String sunsetTimeStr;
//   final String sunriseTimeStr;
//   final int weathercode;
//   final List<ForecastHour> hourly;

//   ForecastDay({
//     required this.temperatureMin,
//     required this.temperatureMax,
//     required this.sunsetTimeStr,
//     required this.sunriseTimeStr,
//     required this.weathercode,
//     required this.hourly,
//   });
// }

// // WEATHER CONTEXT ---------------------------------------------------
// // Global information on the currently viewed weather forecast
// // -------------------------------------------------------------------
// class ForecastLocation {
//   final String mainText;
//   final String secondaryText;
//   final double latitude;
//   final double longitude;
//   final String placeId;

//   ForecastLocation({
//     required this.mainText,
//     required this.secondaryText,
//     required this.latitude,
//     required this.longitude,
//     required this.placeId,
//   });

//   String toJson() {
//     return jsonEncode({
//       'mainText': mainText,
//       'secondaryText': secondaryText,
//       'latitude': latitude,
//       'longitude': longitude,
//       'placeId': placeId,
//     });
//   }

//   static ForecastLocation fromJson(String json) {
//     final data = jsonDecode(json);
//     return ForecastLocation(
//       mainText: data['mainText'],
//       secondaryText: data['secondaryText'],
//       latitude: data['latitude'],
//       longitude: data['longitude'],
//       placeId: data['placeId'],
//     );
//   }
// }