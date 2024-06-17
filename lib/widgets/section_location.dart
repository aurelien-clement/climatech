// widgets/section_location.dart

import 'package:flutter/material.dart';

import '../models/forecast_location.dart';
import '../theme/app_theme.dart';
import '../utils/weathercode.dart';

/// A widget that displays the current weather information and location details.
class SectionLocation extends StatelessWidget {
  final bool isMobile;
  final ForecastLocation? location;
  final double? currentTemperature;
  final int? currentWeathercode;
  final Map<String, String>? hourlyUnits;

  const SectionLocation({
    super.key,
    required this.isMobile,
    this.location,
    this.currentTemperature,
    this.currentWeathercode,
    this.hourlyUnits,
  });

  @override
  Widget build(BuildContext context) {
    bool isDataReady = (location != null && currentTemperature != null && currentWeathercode != null);
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 850),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isDataReady
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return isMobile
                        ? _buildMobileLayout(context)
                        : _buildDesktopLayout(context);
                  },
                )
              : _buildLoadingIndicator(),
        ),
      ),
    );
  }

  /// Builds the mobile layout for the weather information.
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          location?.mainText ?? '',
          textAlign: TextAlign.center,
          style: AppTheme.heroTitle(isMobile),
        ),
        const SizedBox(height: 8),
        Text(
          location?.secondaryText ?? '',
          textAlign: TextAlign.center,
          style: AppTheme.heroSubtitle(isMobile),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              getWeatherIcon(currentWeathercode ?? 0),
              size: 64,
              color: AppTheme.colorOnPrimary.withOpacity(0.5),
              weight: 1.0,
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Text(
                  '${currentTemperature?.toStringAsFixed(0) ?? '--'}°C',
                  style: AppTheme.heroTitle(isMobile),
                ),
                Text(
                  getWeatherDescriptionFR(currentWeathercode ?? 0),
                  style: AppTheme.heroSubtitle(isMobile),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the desktop layout for the weather information.
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location?.mainText ?? '',
                style: AppTheme.heroTitle(isMobile),
              ),
              const SizedBox(height: 8),
              Text(
                location?.secondaryText ?? '',
                style: AppTheme.heroSubtitle(isMobile),
              ),
            ],
          ),
        ),
        const SizedBox(width: 64),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${currentTemperature?.toStringAsFixed(0) ?? '--'}°C',
                  textAlign: TextAlign.center,
                  style: AppTheme.heroTitle(isMobile),
                ),
                const SizedBox(height: 8),
                Text(
                  getWeatherDescriptionFR(currentWeathercode ?? 0),
                  style: AppTheme.heroSubtitle(isMobile),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Icon(
              getWeatherIcon(currentWeathercode ?? 0),
              size: 128,
              color: AppTheme.colorOnPrimary.withOpacity(0.5),
              weight: 1.0,
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a loading indicator to display while data is being fetched.
  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
