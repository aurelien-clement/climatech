
// widgets/forecasts_tab_list/tab_list_hour.dart

import 'package:flutter/material.dart';

import '../../models/forecast_hour.dart';

/// A widget that displays hourly forecast data in a grid.
class TabListHour extends StatelessWidget {
  final ForecastHour forecastHour;
  final Map<String, String> hourlyUnits;

  const TabListHour({
    super.key,
    required this.forecastHour,
    required this.hourlyUnits,
  });

  @override
  Widget build(BuildContext context) {
    final data = forecastHour.toJson()..remove('weathercode');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Prevent scrolling inside the grid
        children: data.keys.map((key) {
          return Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ForecastHour.getNameFR(key),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data[key]}${hourlyUnits[key] ?? ''}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
