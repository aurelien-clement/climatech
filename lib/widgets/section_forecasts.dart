
// widgets/section_forecasts.dart

import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/forecast_day.dart';
import '../models/ui_states.dart';
import '../theme/app_theme.dart';
import 'forecasts_tab_chart/forecasts_tab_chart.dart';
import 'forecasts_tab_list/forecasts_tab_list.dart';

/// A widget that displays weather forecasts in a tabbed view with options for hourly and chart views.
class SectionForecasts extends StatefulWidget {
  final bool isMobile;
  final bool isTouchpad;
  final UiStates uiStates;
  final Map<DateTime, ForecastDay>? forecasts;
  final Map<String, String>? hourlyUnits;
  final VoidCallback loadPrevious;
  final VoidCallback loadNext;
  final Future<void> Function(DateTimeRange) onChartRangeChanged;
  final DateTime? selectedDay;
  final Function(DateTime) onDaySelected;

  const SectionForecasts({
    super.key,
    required this.isMobile,
    required this.isTouchpad,
    required this.uiStates,
    this.forecasts,
    this.hourlyUnits,
    required this.loadPrevious,
    required this.loadNext,
    required this.onChartRangeChanged,
    this.selectedDay,
    required this.onDaySelected,
  });

  @override
  SectionForecastsState createState() => SectionForecastsState();
}

class SectionForecastsState extends State<SectionForecasts> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.colorSurface,
      child: Column(
        children: [
          /// Tab bar for switching between hourly and chart views.
          Container(
            width: double.infinity,
            color: AppTheme.colorSurfaceContainerHigh,
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Par heure', icon: Icon(Icons.calendar_today)),
                    Tab(text: 'Graphique', icon: Icon(Icons.bar_chart)),
                  ],
                ),
              ),
            ),
          ),
          /// Tab bar view for displaying the selected tab's content.
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    ForecastsTabList(
                      isMobile: widget.isMobile,
                      isTouchpad: widget.isTouchpad,
                      uiStates: widget.uiStates,
                      forecasts: widget.forecasts,
                      loadPrevious: widget.loadPrevious,
                      loadNext: widget.loadNext,
                      selectedDay: widget.selectedDay,
                      onDaySelected: widget.onDaySelected,
                      isLoading: false,
                      hourlyUnits: widget.hourlyUnits!,
                    ),
                    ForecastsTabChart(
                      forecasts: widget.forecasts!,
                      hourlyUnits: widget.hourlyUnits!,
                      uiStates: widget.uiStates,
                      isMobile: widget.isMobile,
                      onChartRangeChanged: widget.onChartRangeChanged,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
