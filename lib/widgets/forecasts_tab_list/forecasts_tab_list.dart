
// widgets/forecasts_tab_list/forecast_tab_list.dart

import 'package:flutter/material.dart';

import '../../models/forecast_day.dart';
import '../../models/ui_states.dart';
import 'tab_list_day.dart';
import 'tab_list_day_content.dart';
import '../../constants.dart';

/// A widget that displays a list of forecast days, allowing users to select a day and view detailed hourly forecasts.
class ForecastsTabList extends StatefulWidget {
  final bool isMobile;
  final bool isTouchpad;
  final UiStates uiStates;
  final Map<DateTime, ForecastDay>? forecasts;
  final VoidCallback loadPrevious;
  final VoidCallback loadNext;
  final DateTime? selectedDay;
  final Function(DateTime) onDaySelected;
  final bool isLoading;
  final Map<String, String> hourlyUnits;

  const ForecastsTabList({
    super.key,
    required this.isMobile,
    required this.isTouchpad,
    required this.uiStates,
    this.forecasts,
    required this.loadPrevious,
    required this.loadNext,
    this.selectedDay,
    required this.onDaySelected,
    required this.isLoading,
    required this.hourlyUnits,
  });

  @override
  ForecastsTabListState createState() => ForecastsTabListState();
}

class ForecastsTabListState extends State<ForecastsTabList> {
  int? _openedDayIndex;
  int? _selectedHourIndex;

  @override
  void initState() {
    super.initState();
    _selectedHourIndex = DateTime.now().hour;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: widget.forecasts == null || widget.forecasts!.isEmpty || widget.selectedDay == null
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                key: ValueKey(widget.selectedDay),
                builder: (context, constraints) {
                  try {
                    List<DateTime> forecastDays = widget.forecasts!.keys.toList();
                    forecastDays.sort();

                    // Filter forecastDays to only include dates in the dateRangeList range
                    forecastDays = forecastDays.where((day) =>
                        day.isAfter(widget.uiStates.dateRangeList.start.subtract(const Duration(days: 1))) &&
                        day.isBefore(widget.uiStates.dateRangeList.end.add(const Duration(days: 1)))).toList();

                    return constraints.maxWidth < kTouchpadBreakpoint
                        ? _buildMobileLayout(context, forecastDays)
                        : _buildDesktopLayout(context, forecastDays);
                  } catch (e) {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
      ),
    );
  }

  /// Builds the mobile layout for the forecast list.
  Widget _buildMobileLayout(BuildContext context, List<DateTime> forecastDays) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _buildForecastList(context, forecastDays),
        ),
      ],
    );
  }

  /// Builds the desktop layout for the forecast list.
  Widget _buildDesktopLayout(BuildContext context, List<DateTime> forecastDays) {
    return Row(
      children: [
        SizedBox(
          width: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: _buildForecastList(context, forecastDays),
              ),
            ],
          ),
        ),
        if (!widget.isTouchpad && widget.selectedDay != null) ...[
          VerticalDivider(color: Colors.grey.withOpacity(0.5), width: 8.0),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 2,
            child: TabListDayContent(
              day: widget.selectedDay!,
              forecast: widget.forecasts![widget.selectedDay!]!,
              initialHourIndex: _selectedHourIndex ?? DateTime.now().hour,
              hourlyUnits: widget.hourlyUnits,
              isTouchpad: widget.isTouchpad,
            ),
          ),
        ],
      ],
    );
  }

  /// Builds the list of forecast days.
  Widget _buildForecastList(BuildContext context, List<DateTime> forecastDays) {
    return ListView.builder(
      padding: widget.isTouchpad ? const EdgeInsets.all(8.0) : const EdgeInsets.only(right: 16.0),
      itemCount: forecastDays.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _ForecastButton(
            onPressed: widget.uiStates.dateRangeList.start.isAfter(widget.uiStates.dateRangeMax.start) ? widget.loadPrevious : null,
            label: 'Jours précédents',
            isEnabled: widget.uiStates.dateRangeList.start.isAfter(widget.uiStates.dateRangeMax.start),
          );
        } else if (index == forecastDays.length + 1) {
          return _ForecastButton(
            onPressed: widget.uiStates.dateRangeList.end.isBefore(widget.uiStates.dateRangeMax.end) ? widget.loadNext : null,
            label: 'Jours suivants',
            isEnabled: widget.uiStates.dateRangeList.end.isBefore(widget.uiStates.dateRangeMax.end),
          );
        } else {
          DateTime day = forecastDays[index - 1];
          return TabListDay(
            day: day,
            hourlyUnits: widget.hourlyUnits,
            forecast: widget.forecasts![day]!,
            isTouchpad: widget.isTouchpad,
            isSelected: day == widget.selectedDay,
            isExpanded: _openedDayIndex == index - 1,
            onDaySelected: (selectedDay) {
              widget.onDaySelected(selectedDay);
              setState(() {
                _openedDayIndex = index - 1;
                _selectedHourIndex = DateTime.now().hour;
              });
            },
          );
        }
      },
    );
  }
}

/// A button widget for loading more forecast days.
class _ForecastButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isEnabled;

  const _ForecastButton({
    required this.onPressed,
    required this.label,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: ListTile(
        minTileHeight: 64.0,
        mouseCursor: SystemMouseCursors.click,
        leading: Icon(Icons.add, size: 24, color: isEnabled ? Colors.black : Colors.grey),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? Colors.black : Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
