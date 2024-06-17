
// widgets/forecasts_tab_chart/tab_chart_graphs.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/forecast_day.dart';
import '../../models/forecast_hour.dart';

/// Widget for displaying weather data in graphs.
class TabChartGraphs extends StatelessWidget {
  final List<MapEntry<DateTime, ForecastDay>> forecasts;
  final Map<String, String> hourlyUnits;
  final List<String> selectedData;
  final double zoomLevel;
  final Map<String, Color> dataColors;

  const TabChartGraphs({
    super.key,
    required this.forecasts,
    required this.hourlyUnits,
    required this.selectedData,
    required this.zoomLevel,
    required this.dataColors,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: constraints.maxWidth * zoomLevel,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Column(
                children: selectedData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final dataType = entry.value;
                  return SizedBox(
                    height: (constraints.maxHeight - 72) / selectedData.length,
                    child: _buildChart(forecasts, dataType, constraints.maxWidth, index == selectedData.length - 1),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds a LineChart for a specific data type.
  Widget _buildChart(List<MapEntry<DateTime, ForecastDay>> forecasts, String dataType, double width, bool isLastChart) {
    final spots = _getSpots(forecasts, dataType); // Get chart points
    final averageValue = _calculateAverage(spots); // Calculate average value

    // Determine min and max values for the Y scale
    final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    final range = maxY - minY;
    final adjustedMinY = minY;
    final adjustedMaxY = maxY + range * 0.5; // Add 50% margin at the top

    return LineChart(
      LineChartData(
        minY: adjustedMinY,
        maxY: adjustedMaxY,
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: averageValue,
              color: dataColors[dataType],
              strokeWidth: 1,
              dashArray: [1, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: const Alignment(-1.0, -1.0), // Align text to the left
                labelResolver: (line) {
                  return '${averageValue.toStringAsFixed(1)} ${hourlyUnits[dataType] ?? ''}';
                },
              ),
            ),
          ],
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: false,
          verticalInterval: 86400000, // Vertical interval of one day (in milliseconds)
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.25),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: dataColors[dataType]!,
            belowBarData: BarAreaData(
              show: true,
              color: dataColors[dataType]!.withOpacity(0.1),
            ),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: isLastChart
                ? SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 86400000,
                    getTitlesWidget: (value, meta) {
                      if (value % 86400000 == 0) {
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(DateFormat('MMMd', 'fr_FR').format(date)),
                        );
                      } else {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Container(),
                        );
                      }
                    },
                  )
                : const SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.white,
            tooltipPadding: const EdgeInsets.all(8),
            maxContentWidth: 240,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final flSpot = touchedSpot;
                final dateTime = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
                final originalValue = flSpot.y;

                final translatedName = ForecastHour.getNameFR(dataType);
                final unit = hourlyUnits[dataType] ?? '';

                return LineTooltipItem(
                  '${DateFormat('dd MMM. yy - HH:mm', 'fr_FR').format(dateTime)}\n$translatedName : ${originalValue.toStringAsFixed(2).replaceAll(' ', '\u00A0')} $unit'.replaceAll(' ', '\u00A0'),
                  TextStyle(
                    color: dataColors[dataType]!,
                  ),
                );
              }).toList();
            },
          ),
          touchSpotThreshold: 8,
          handleBuiltInTouches: true,
        ),
      ),
    );
  }

  /// Gets the points (FlSpot) for the chart based on the forecasts and data type.
  List<FlSpot> _getSpots(List<MapEntry<DateTime, ForecastDay>> forecasts, String dataType) {
    // Convert forecasts to a list of FlSpot
    List<FlSpot> spots = forecasts.expand((entry) {
      return entry.value.hourly.asMap().entries.map((hourEntry) {
        final hourIndex = hourEntry.key;
        final hourData = hourEntry.value;
        final dateTime = entry.key.add(Duration(hours: hourIndex));
        final originalValue = hourData.toJson()[dataType] as double?;

        if (originalValue == null || originalValue.isNaN || originalValue.isInfinite) {
          // Skip invalid or null data points
          return null;
        }

        return FlSpot(
          dateTime.millisecondsSinceEpoch.toDouble(),
          originalValue,
        );
      }).where((spot) => spot != null).cast<FlSpot>().toList();
    }).toList();

    // Sort the points by date (x)
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  /// Calculates the average value of the points.
  double _calculateAverage(List<FlSpot> spots) {
    final total = spots.fold(0.0, (sum, spot) => sum + spot.y);
    return total / spots.length;
  }
}
