import 'package:flutter/material.dart';
import 'theme_modes.dart';

/// Configuration class for adaptive theme settings
class AdaptiveThemeConfig {
  /// The current theme mode
  final AdaptiveThemeMode mode;

  /// Light theme data
  final ThemeData lightTheme;

  /// Dark theme data
  final ThemeData darkTheme;

  /// Custom theme data (optional)
  final ThemeData? customTheme;

  /// Duration for theme transitions
  final Duration transitionDuration;

  /// Curve for theme transitions
  final Curve transitionCurve;

  /// Time-based theme settings
  final TimeBasedThemeSettings? timeBasedSettings;

  /// Whether to save theme preferences
  final bool savePreferences;

  /// Storage key for preferences
  final String storageKey;

  /// Whether to show debug information
  final bool debug;

  const AdaptiveThemeConfig({
    required this.mode,
    required this.lightTheme,
    required this.darkTheme,
    this.customTheme,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.transitionCurve = Curves.easeInOut,
    this.timeBasedSettings,
    this.savePreferences = true,
    this.storageKey = 'adaptive_theme_preferences',
    this.debug = false,
  });

  /// Creates a copy of this config with updated values
  AdaptiveThemeConfig copyWith({
    AdaptiveThemeMode? mode,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    ThemeData? customTheme,
    Duration? transitionDuration,
    Curve? transitionCurve,
    TimeBasedThemeSettings? timeBasedSettings,
    bool? savePreferences,
    String? storageKey,
    bool? debug,
  }) {
    return AdaptiveThemeConfig(
      mode: mode ?? this.mode,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      customTheme: customTheme ?? this.customTheme,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      transitionCurve: transitionCurve ?? this.transitionCurve,
      timeBasedSettings: timeBasedSettings ?? this.timeBasedSettings,
      savePreferences: savePreferences ?? this.savePreferences,
      storageKey: storageKey ?? this.storageKey,
      debug: debug ?? this.debug,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdaptiveThemeConfig &&
        other.mode == mode &&
        other.lightTheme == lightTheme &&
        other.darkTheme == darkTheme &&
        other.customTheme == customTheme &&
        other.transitionDuration == transitionDuration &&
        other.transitionCurve == transitionCurve &&
        other.timeBasedSettings == timeBasedSettings &&
        other.savePreferences == savePreferences &&
        other.storageKey == storageKey &&
        other.debug == debug;
  }

  @override
  int get hashCode {
    return Object.hash(
      mode,
      lightTheme,
      darkTheme,
      customTheme,
      transitionDuration,
      transitionCurve,
      timeBasedSettings,
      savePreferences,
      storageKey,
      debug,
    );
  }
}

/// Settings for time-based theme switching
class TimeBasedThemeSettings {
  /// Hour when dark theme should start (0-23)
  final int darkThemeStartHour;

  /// Hour when light theme should start (0-23)
  final int lightThemeStartHour;

  /// Whether to use 24-hour format
  final bool use24HourFormat;

  const TimeBasedThemeSettings({
    this.darkThemeStartHour = 18, // 6 PM
    this.lightThemeStartHour = 6, // 6 AM
    this.use24HourFormat = true,
  });

  /// Creates a copy of this settings with updated values
  TimeBasedThemeSettings copyWith({
    int? darkThemeStartHour,
    int? lightThemeStartHour,
    bool? use24HourFormat,
  }) {
    return TimeBasedThemeSettings(
      darkThemeStartHour: darkThemeStartHour ?? this.darkThemeStartHour,
      lightThemeStartHour: lightThemeStartHour ?? this.lightThemeStartHour,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeBasedThemeSettings &&
        other.darkThemeStartHour == darkThemeStartHour &&
        other.lightThemeStartHour == lightThemeStartHour &&
        other.use24HourFormat == use24HourFormat;
  }

  @override
  int get hashCode {
    return Object.hash(
      darkThemeStartHour,
      lightThemeStartHour,
      use24HourFormat,
    );
  }
}
