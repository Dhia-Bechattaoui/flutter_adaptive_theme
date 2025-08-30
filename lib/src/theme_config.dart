import 'package:flutter/material.dart';
import 'theme_modes.dart';
import 'material3_theme_builders.dart';
import 'custom_theme_builder.dart';

/// Configuration class for adaptive theme settings
class AdaptiveThemeConfig {
  const AdaptiveThemeConfig({
    required this.mode,
    required this.lightTheme,
    required this.darkTheme,
    this.customTheme,
    this.material3Builder,
    this.customThemeBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.transitionCurve = Curves.easeInOut,
    this.timeBasedSettings,
    this.savePreferences = true,
    this.storageKey = 'adaptive_theme_preferences',
    this.debug = false,
    this.useMaterial3 = true,
  });

  /// The current theme mode
  final AdaptiveThemeMode mode;

  /// Light theme data
  final ThemeData lightTheme;

  /// Dark theme data
  final ThemeData darkTheme;

  /// Custom theme data (optional)
  final ThemeData? customTheme;

  /// Material 3 theme builder (optional, overrides individual themes if provided)
  final Material3ThemeBuilder? material3Builder;

  /// Custom theme builder (optional, provides advanced theme building capabilities)
  final CustomThemeBuilder? customThemeBuilder;

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

  /// Whether to use Material 3 by default
  final bool useMaterial3;

  /// Creates a copy of this config with updated values
  AdaptiveThemeConfig copyWith({
    final AdaptiveThemeMode? mode,
    final ThemeData? lightTheme,
    final ThemeData? darkTheme,
    final ThemeData? customTheme,
    final Material3ThemeBuilder? material3Builder,
    final CustomThemeBuilder? customThemeBuilder,
    final Duration? transitionDuration,
    final Curve? transitionCurve,
    final TimeBasedThemeSettings? timeBasedSettings,
    final bool? savePreferences,
    final String? storageKey,
    final bool? debug,
    final bool? useMaterial3,
  }) {
    return AdaptiveThemeConfig(
      mode: mode ?? this.mode,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      customTheme: customTheme ?? this.customTheme,
      material3Builder: material3Builder ?? this.material3Builder,
      customThemeBuilder: customThemeBuilder ?? this.customThemeBuilder,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      transitionCurve: transitionCurve ?? this.transitionCurve,
      timeBasedSettings: timeBasedSettings ?? this.timeBasedSettings,
      savePreferences: savePreferences ?? this.savePreferences,
      storageKey: storageKey ?? this.storageKey,
      debug: debug ?? this.debug,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
    );
  }

  /// Get the effective light theme considering Material 3 and custom builders
  ThemeData get effectiveLightTheme {
    if (customThemeBuilder != null) {
      return customThemeBuilder!.buildLightTheme();
    }

    if (material3Builder != null) {
      return material3Builder!.buildLightTheme();
    }

    return _ensureMaterial3(lightTheme);
  }

  /// Get the effective dark theme considering Material 3 and custom builders
  ThemeData get effectiveDarkTheme {
    if (customThemeBuilder != null) {
      return customThemeBuilder!.buildDarkTheme();
    }

    if (material3Builder != null) {
      return material3Builder!.buildDarkTheme();
    }

    return _ensureMaterial3(darkTheme);
  }

  /// Get the effective custom theme considering Material 3 and custom builders
  ThemeData? get effectiveCustomTheme {
    if (customThemeBuilder != null) {
      return customThemeBuilder!.buildTheme(
        Brightness.light,
      ); // Default to light for custom
    }

    if (material3Builder != null) {
      return material3Builder!.buildTheme(Brightness.light);
    }

    if (customTheme != null) {
      return _ensureMaterial3(customTheme!);
    }

    return null;
  }

  /// Ensure Material 3 is enabled if specified
  ThemeData _ensureMaterial3(final ThemeData theme) {
    // Material 3 is now the default in newer Flutter versions
    // We'll keep the method for backward compatibility but don't set useMaterial3
    return theme;
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;
    return other is AdaptiveThemeConfig &&
        other.mode == mode &&
        other.lightTheme == lightTheme &&
        other.darkTheme == darkTheme &&
        other.customTheme == customTheme &&
        other.material3Builder == material3Builder &&
        other.customThemeBuilder == customThemeBuilder &&
        other.transitionDuration == transitionDuration &&
        other.transitionCurve == transitionCurve &&
        other.timeBasedSettings == timeBasedSettings &&
        other.savePreferences == savePreferences &&
        other.storageKey == storageKey &&
        other.debug == debug &&
        other.useMaterial3 == useMaterial3;
  }

  @override
  int get hashCode {
    return Object.hash(
      mode,
      lightTheme,
      darkTheme,
      customTheme,
      material3Builder,
      customThemeBuilder,
      transitionDuration,
      transitionCurve,
      timeBasedSettings,
      savePreferences,
      storageKey,
      debug,
      useMaterial3,
    );
  }
}

/// Settings for time-based theme switching
class TimeBasedThemeSettings {
  const TimeBasedThemeSettings({
    this.darkThemeStartHour = 18, // 6 PM
    this.lightThemeStartHour = 6, // 6 AM
    this.use24HourFormat = true,
  });

  /// Hour when dark theme should start (0-23)
  final int darkThemeStartHour;

  /// Hour when light theme should start (0-23)
  final int lightThemeStartHour;

  /// Whether to use 24-hour format
  final bool use24HourFormat;

  /// Creates a copy of this settings with updated values
  TimeBasedThemeSettings copyWith({
    final int? darkThemeStartHour,
    final int? lightThemeStartHour,
    final bool? use24HourFormat,
  }) {
    return TimeBasedThemeSettings(
      darkThemeStartHour: darkThemeStartHour ?? this.darkThemeStartHour,
      lightThemeStartHour: lightThemeStartHour ?? this.lightThemeStartHour,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
    );
  }

  @override
  bool operator ==(final Object other) {
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
