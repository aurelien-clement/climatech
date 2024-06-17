
// models/ui_states.dart

import '../utils/date_operations.dart'; // Utility functions for date operations
import 'package:flutter/material.dart'; // Needed for DateTimeRange class

/// Class representing the UI state for date ranges and settings.
class UiStates {
  DateTimeRange dateRangeMax;
  DateTimeRange dateRangeList;
  DateTimeRange dateRangeChart;
  int visibleDays;
  bool isImperialUnit;

  UiStates({
    required this.dateRangeMax,
    required this.dateRangeList,
    required this.dateRangeChart,
    required this.visibleDays,
    required this.isImperialUnit,
  });

  /// Change the displayed date range in the UI.
  /// If [previous] is true, move to the previous range, otherwise move to the next range.
  void changeDateRangeList({bool previous = false}) {
    if (previous) {
      // Calculate the number of days left to move backwards
      final int daysLeft = (dateRangeList.start.difference(dateRangeMax.start).inHours / 24).round();
      if (daysLeft > 0) {
        final int delta = daysLeft >= visibleDays ? visibleDays : daysLeft;
        dateRangeList = DateTimeRange(
          start: subDay(dateRangeList.start, delta),
          end: subDay(dateRangeList.end, delta),
        );
      }
    } else {
      // Calculate the number of days left to move forwards
      final int daysLeft = (dateRangeMax.end.difference(dateRangeList.end).inHours / 24).round();
      if (daysLeft > 0) {
        final int delta = daysLeft >= visibleDays ? visibleDays : daysLeft;
        dateRangeList = DateTimeRange(
          start: addDay(dateRangeList.start, delta),
          end: addDay(dateRangeList.end, delta),
        );
      }
    }
  }
}
