
// widgets/forecasts_tab_chart/tab_chart_options.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../models/forecast_hour.dart';

/// Widget for displaying chart options like date range and data filters.
class TabChartOptions extends StatefulWidget {
  final DateTimeRange dateRange;
  final DateTimeRange dateRangeMax;
  final List<String> selectedData;
  final double zoomLevel;
  final ValueChanged<DateTimeRange> onChartRangeChanged;
  final ValueChanged<List<String>> onSelectedDataChanged;
  final ValueChanged<double> onZoomLevelChanged;
  final bool isMobile;

  const TabChartOptions({
    super.key,
    required this.dateRange,
    required this.dateRangeMax,
    required this.selectedData,
    required this.zoomLevel,
    required this.onChartRangeChanged,
    required this.onSelectedDataChanged,
    required this.onZoomLevelChanged,
    required this.isMobile,
  });

  @override
  TabChartOptionsState createState() => TabChartOptionsState();
}

class TabChartOptionsState extends State<TabChartOptions> {
  late DateTimeRange dateRange;

  @override
  void initState() {
    super.initState();
    dateRange = widget.dateRange;
  }

  /// Allows the user to select a date range for the chart.
  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Sélectionnez une période'),
          content: SizedBox(
            height: 400,
            width: 300,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  final PickerDateRange range = args.value;
                  setState(() {
                    dateRange = DateTimeRange(
                      start: range.startDate!,
                      end: range.endDate ?? range.startDate!,
                    );
                  });
                }
              },
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                dateRange.start,
                dateRange.end,
              ),
              minDate: widget.dateRangeMax.start,
              maxDate: widget.dateRangeMax.end,
              backgroundColor: Theme.of(context).colorScheme.surface,
              monthViewSettings: const DateRangePickerMonthViewSettings(
                firstDayOfWeek: 1,
              ),
              headerStyle: const DateRangePickerHeaderStyle(
                textAlign: TextAlign.center,
              ),
              monthFormat: 'MMM',
              monthCellStyle: DateRangePickerMonthCellStyle(
                todayTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                weekendTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler', style: Theme.of(context).textTheme.bodyMedium),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK', style: Theme.of(context).textTheme.bodyMedium),
              onPressed: () {
                widget.onChartRangeChanged(dateRange);
                Navigator.of(context).pop(dateRange);
              },
            ),
          ],
        );
      },
    );

    if (picked != null && picked != dateRange) {
      setState(() {
        dateRange = picked;
        widget.onChartRangeChanged(picked);
      });
    }
  }

  /// Allows the user to select the data filters for the chart.
  void _selectFilters(BuildContext context) async {
    final availableFilters = ForecastHour.namesFR.keys
        .where((key) => key != 'windDirection' && key != 'weathercode')
        .toList();
    final selectedFilters = List<String>.from(widget.selectedData);

    final picked = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: const Text('Afficher les données :'),
              content: SizedBox(
                width: double.minPositive,
                child: SingleChildScrollView(
                  child: ListBody(
                    children: availableFilters.map((filter) {
                      return CheckboxListTile(
                        title: Text(
                          ForecastHour.getNameFR(filter),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: selectedFilters.contains(filter),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedFilters.add(filter);
                            } else {
                              selectedFilters.remove(filter);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Annuler', style: Theme.of(context).textTheme.bodyMedium),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('OK', style: Theme.of(context).textTheme.bodyMedium),
                  onPressed: () {
                    Navigator.of(context).pop(selectedFilters);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (picked != null) {
      widget.onSelectedDataChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.isMobile
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    _buildDateRangeButton(context),
                    const SizedBox(height: 12.0),
                    _buildFiltersButton(context),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: _buildDateRangeButton(context)),
                    const SizedBox(width: 24.0),
                    Expanded(child: _buildFiltersButton(context)),
                  ],
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.zoom_out, color: Colors.grey),
              SizedBox(
                width: 256,
                child: Slider(
                  value: widget.zoomLevel,
                  min: 1,
                  max: 10,
                  onChanged: widget.onZoomLevelChanged,
                  inactiveColor: Colors.grey.withOpacity(0.25),
                ),
              ),
              const Icon(Icons.zoom_in, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the button for selecting the date range.
  Widget _buildDateRangeButton(BuildContext context) {
    return SizedBox(
      width: widget.isMobile ? double.infinity : null,
      child: OutlinedButton(
        onPressed: () => _selectDateRange(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: widget.isMobile ? 12.0 : 16.0),
          side: const BorderSide(color: Colors.grey),
        ),
        child: Column(
          children: [
            Text(
              'Sélectionnez la période',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${DateFormat.yMMMd('fr_FR').format(dateRange.start)} - ${DateFormat.yMMMd('fr_FR').format(dateRange.end)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the button for selecting data filters.
  Widget _buildFiltersButton(BuildContext context) {
    return SizedBox(
      width: widget.isMobile ? double.infinity : null,
      child: OutlinedButton(
        onPressed: () => _selectFilters(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: widget.isMobile ? 12.0 : 16.0),
          side: const BorderSide(color: Colors.grey),
        ),
        child: Column(
          children: [
            Text(
              'Sélectionnez les données',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${ForecastHour.getNameFR(
                widget.selectedData.isNotEmpty ? widget.selectedData.first : ''
              )}, +${
                widget.selectedData.length > 1 ? widget.selectedData.length - 1 : ''
              }',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
