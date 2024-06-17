
// theme/app_theme.dart

import 'package:flutter/material.dart';

/// A utility class to access theme-related properties and styles.
class AppTheme {
  static ThemeData? themeData;

  /// Initializes the theme data based on the current context.
  static void initialize(BuildContext context) {
    themeData = Theme.of(context);
  }

  /// Accessors for color scheme properties
  static Color get colorSurface => themeData?.colorScheme.surface ?? Colors.white;
  static Color get colorSurfaceContainer => themeData?.colorScheme.surfaceContainer ?? Colors.white;
  static Color get colorSurfaceContainerHigh => themeData?.colorScheme.surfaceContainerHigh ?? Colors.white;
  static Color get colorPrimaryContainer => themeData?.colorScheme.primaryContainer ?? Colors.white;
  static Color get colorPrimary => themeData?.colorScheme.primary ?? Colors.indigo;
  static Color get colorOnPrimary => themeData?.colorScheme.onPrimary ?? Colors.white;
  static Color get colorSecondary => themeData?.colorScheme.secondary ?? Colors.indigo;
  static Color get colorSecondaryContainer => themeData?.colorScheme.secondaryContainer ?? Colors.indigo;

  /// Accessors for text styles
  static TextStyle? get headlineLarge => themeData?.textTheme.headlineLarge;
  static TextStyle? get headlineMedium => themeData?.textTheme.headlineMedium;
  static TextStyle? get headlineSmall => themeData?.textTheme.headlineSmall;
  static TextStyle? get displaySmall => themeData?.textTheme.displaySmall;
  static TextStyle? get titleLarge => themeData?.textTheme.titleLarge;
  static TextStyle? get bodyLarge => themeData?.textTheme.bodyLarge;
  static TextStyle? get bodyMedium => themeData?.textTheme.bodyMedium;
  static TextStyle? get bodySmall => themeData?.textTheme.bodySmall;

  /// Returns the hero title style based on the screen size.
  static TextStyle? heroTitle(bool isMobile) {
    return isMobile
      ? themeData?.textTheme.headlineMedium?.copyWith(
          color: themeData?.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        )
      : themeData?.textTheme.headlineLarge?.copyWith(
          color: themeData?.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        );
  }

  /// Returns the hero subtitle style based on the screen size.
  static TextStyle? heroSubtitle(bool isMobile) {
    return isMobile
      ? themeData?.textTheme.titleMedium?.copyWith(
          color: themeData?.colorScheme.onPrimary.withOpacity(0.5),
          fontWeight: FontWeight.w100,
        )
      : themeData?.textTheme.titleLarge?.copyWith(
          color: themeData?.colorScheme.onPrimary.withOpacity(0.5),
          fontWeight: FontWeight.w100,
        );
  }
}
