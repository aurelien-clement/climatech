
// widgets/forecasts_tab_chart/forecasts_tab_chart.dart

import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/forecast_day.dart';
import '../../models/ui_states.dart';
import 'tab_chart_options.dart';
import 'tab_chart_graphs.dart';

/// Main view for displaying weather data in charts.
class ForecastsTabChart extends StatefulWidget {
  final Map<DateTime, ForecastDay> forecasts;
  final Map<String, String> hourlyUnits;
  final UiStates uiStates;
  final bool isMobile;
  final Future<void> Function(DateTimeRange) onChartRangeChanged;

  const ForecastsTabChart({
    super.key,
    required this.forecasts,
    required this.hourlyUnits,
    required this.uiStates,
    required this.isMobile,
    required this.onChartRangeChanged,
  });

  @override
  ForecastsTabChartState createState() => ForecastsTabChartState();
}

class ForecastsTabChartState extends State<ForecastsTabChart> {
  List<String> selectedData = ['temperature', 'humidity', 'precipitation'];
  double zoomLevel = 1.0;
  bool isLoading = false;

  /// Updates the selected data types to display on the chart.
  void updateSelectedData(List<String> newSelectedData) {
    setState(() {
      selectedData = newSelectedData;
    });
  }

  /// Updates the zoom level for the chart.
  void updateZoomLevel(double newZoomLevel) {
    setState(() {
      zoomLevel = newZoomLevel;
    });
  }

  /// Checks for missing data within the specified date range.
  void checkDataCompleteness(DateTimeRange range) {
    List<DateTime> missingDates = [];
    for (DateTime date = range.start; date.isBefore(range.end); date = date.add(const Duration(days: 1))) {
      if (!widget.forecasts.containsKey(date)) {
        missingDates.add(date);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkDataCompleteness(widget.uiStates.dateRangeChart);
  }

  /// Handles the change in date range for the chart.
  Future<void> handleDateRangeChanged(DateTimeRange newRange) async {
    setState(() {
      isLoading = true;
    });
    await widget.onChartRangeChanged(newRange);
    checkDataCompleteness(newRange);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredForecasts = widget.forecasts.entries
        .where((entry) =>
            entry.key.isAfter(widget.uiStates.dateRangeChart.start.subtract(const Duration(days: 1))) &&
            entry.key.isBefore(widget.uiStates.dateRangeChart.end))
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              /// Widget for selecting chart options such as date range and data types.
              TabChartOptions(
                dateRange: widget.uiStates.dateRangeChart,
                dateRangeMax: widget.uiStates.dateRangeMax,
                selectedData: selectedData,
                zoomLevel: zoomLevel,
                onChartRangeChanged: handleDateRangeChanged,
                onSelectedDataChanged: updateSelectedData,
                onZoomLevelChanged: updateZoomLevel,
                isMobile: widget.isMobile,
              ),
              /// Displays the chart with the selected options.
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabChartGraphs(
                        forecasts: filteredForecasts,
                        hourlyUnits: widget.hourlyUnits,
                        selectedData: selectedData,
                        zoomLevel: zoomLevel,
                        dataColors: kChartColors,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
