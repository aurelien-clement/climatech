
// widgets/forecasts_tab_list/tab_list_day_content.dart

import 'package:flutter/material.dart';

import '../../models/forecast_day.dart';
import '../../models/forecast_hour.dart';
import '../../utils/weathercode.dart';
import 'tab_list_hour.dart';

/// A widget that displays the detailed hourly forecast for a selected day.
class TabListDayContent extends StatefulWidget {
  final DateTime day;
  final ForecastDay forecast;
  final int initialHourIndex;
  final Map<String, String> hourlyUnits;
  final bool isTouchpad;

  const TabListDayContent({
    super.key,
    required this.day,
    required this.forecast,
    required this.hourlyUnits,
    this.initialHourIndex = 0,
    required this.isTouchpad,
  });

  @override
  TabListDayContentState createState() => TabListDayContentState();
}

class TabListDayContentState extends State<TabListDayContent> {
  int? _selectedHourIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedHourIndex = widget.initialHourIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedHour();
    });
  }

  @override
  void didUpdateWidget(covariant TabListDayContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.day != oldWidget.day) {
      _scrollToSelectedHour();
    }
  }

  /// Scrolls to the selected hour.
  void _scrollToSelectedHour() {
    if (_scrollController.hasClients && _selectedHourIndex != null) {
      final position = (_selectedHourIndex! - 3) * 80.0;
      final maxScroll = _scrollController.position.maxScrollExtent;
      _scrollController.jumpTo(position.clamp(0.0, maxScroll));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 100,
          margin: const EdgeInsets.all(8.0),
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.forecast.hourly.length,
            itemBuilder: (context, index) {
              ForecastHour hourData = widget.forecast.hourly[index];
              final dateTime = widget.day.add(Duration(hours: index));
              final isDay = _isDayTime(dateTime);

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedHourIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: _selectedHourIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${dateTime.hour}:00',
                          style: TextStyle(
                            color: _selectedHourIndex == index ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Icon(
                          getWeatherIcon(hourData.weathercode, isDay: isDay),
                          size: 24,
                          color: _selectedHourIndex == index ? Colors.white : Colors.black,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '${hourData.temperature.toStringAsFixed(1)}°C',
                          style: TextStyle(
                            color: _selectedHourIndex == index ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_selectedHourIndex != null)
          widget.isTouchpad
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0), // Padding for mobile
                  child: TabListHour(
                    forecastHour: widget.forecast.hourly[_selectedHourIndex!],
                    hourlyUnits: widget.hourlyUnits,
                  ),
                )
              : Flexible(
                  child: SingleChildScrollView(
                    child: TabListHour(
                      forecastHour: widget.forecast.hourly[_selectedHourIndex!],
                      hourlyUnits: widget.hourlyUnits,
                    ),
                  ),
                ),
      ],
    );
  }

  /// Checks if a given DateTime is during the day (between sunrise and sunset).
  bool _isDayTime(DateTime dateTime) {
    final sunrise = DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      int.parse(widget.forecast.sunriseTimeStr.split(':')[0]),
      int.parse(widget.forecast.sunriseTimeStr.split(':')[1]),
    );
    final sunset = DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      int.parse(widget.forecast.sunsetTimeStr.split(':')[0]),
      int.parse(widget.forecast.sunsetTimeStr.split(':')[1]),
    );
    return dateTime.isAfter(sunrise) && dateTime.isBefore(sunset);
  }
}
