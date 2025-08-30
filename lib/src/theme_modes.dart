/// Defines the different adaptive theme modes available
enum AdaptiveThemeMode {
  /// Follows the system theme setting
  system,

  /// Always uses light theme
  light,

  /// Always uses dark theme
  dark,

  /// Automatically switches based on time of day
  timeBased,

  /// Custom adaptive mode based on user preferences
  custom,
}

/// Extension to provide helper methods for AdaptiveThemeMode
extension AdaptiveThemeModeExtension on AdaptiveThemeMode {
  /// Returns a human-readable name for the theme mode
  String get displayName {
    switch (this) {
      case AdaptiveThemeMode.system:
        return 'System';
      case AdaptiveThemeMode.light:
        return 'Light';
      case AdaptiveThemeMode.dark:
        return 'Dark';
      case AdaptiveThemeMode.timeBased:
        return 'Time Based';
      case AdaptiveThemeMode.custom:
        return 'Custom';
    }
  }

  /// Returns the string representation for storage
  String get stringValue {
    switch (this) {
      case AdaptiveThemeMode.system:
        return 'system';
      case AdaptiveThemeMode.light:
        return 'light';
      case AdaptiveThemeMode.dark:
        return 'dark';
      case AdaptiveThemeMode.timeBased:
        return 'time_based';
      case AdaptiveThemeMode.custom:
        return 'custom';
    }
  }

  /// Creates an AdaptiveThemeMode from a string value
  static AdaptiveThemeMode fromString(final String value) {
    switch (value) {
      case 'system':
        return AdaptiveThemeMode.system;
      case 'light':
        return AdaptiveThemeMode.light;
      case 'dark':
        return AdaptiveThemeMode.dark;
      case 'time_based':
        return AdaptiveThemeMode.timeBased;
      case 'custom':
        return AdaptiveThemeMode.custom;
      default:
        return AdaptiveThemeMode.system;
    }
  }
}
