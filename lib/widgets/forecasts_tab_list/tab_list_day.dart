
// widgets/forecasts_tab_list/tab_list_day.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/forecast_day.dart';
import '../../theme/app_theme.dart';
import '../../utils/weathercode.dart';
import 'tab_list_day_content.dart';

/// A widget that represents a day's forecast in a list.
class TabListDay extends StatefulWidget {
  final DateTime day;
  final ForecastDay forecast;
  final bool isTouchpad;
  final bool isSelected;
  final bool isExpanded;
  final Map<String, String> hourlyUnits;
  final Function(DateTime) onDaySelected;

  const TabListDay({
    super.key,
    required this.day,
    required this.forecast,
    required this.isTouchpad,
    required this.isSelected,
    required this.isExpanded,
    required this.hourlyUnits,
    required this.onDaySelected,
  });

  @override
  TabListDayState createState() => TabListDayState();
}

class TabListDayState extends State<TabListDay> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant TabListDay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onDaySelected(widget.day);
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1)
                : _isHovered || widget.isExpanded
                    ? ColorScheme.fromSeed(seedColor: Colors.indigo).secondaryFixed.withOpacity(0.5)
                    : AppTheme.colorSurface,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                minVerticalPadding: 16.0,
                leading: Icon(
                  getWeatherIcon(widget.forecast.weathercode),
                  size: 24,
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMEd', 'fr_FR').format(widget.day),
                      style: AppTheme.bodyLarge,
                    ),
                    Text(
                      getWeatherDescriptionFR(widget.forecast.weathercode),
                      style: AppTheme.bodySmall?.copyWith(color: AppTheme.colorSecondary),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.forecast.temperatureMax.toStringAsFixed(0)}°C',
                      style: AppTheme.bodyLarge,
                    ),
                    Text(
                      '${widget.forecast.temperatureMin.toStringAsFixed(0)}°C',
                      style: AppTheme.bodySmall?.copyWith(color: AppTheme.colorSecondary),
                    ),
                  ],
                ),
              ),
              if (widget.isTouchpad)
                SizeTransition(
                  sizeFactor: _heightFactor,
                  child: widget.isExpanded
                      ? TabListDayContent(
                          hourlyUnits: widget.hourlyUnits,
                          day: widget.day,
                          forecast: widget.forecast,
                          isTouchpad: widget.isTouchpad,
                        )
                      : Container(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
