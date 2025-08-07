# Changelog

All notable changes to the `flutter_adaptive_theme` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.2] - 2024-06-09

### Changed
- Updated dependencies: `shared_preferences` to ^2.0.0, `provider` to ^6.0.0, `flutter_lints` to ^6.0.0.
- Improved static analysis compliance and formatting.
- Removed unnecessary imports and fixed nullable access in the example.

### Fixed
- Fixed all static analysis and formatting issues.
- Ensured null safety and compatibility with latest Flutter/Dart versions.

## [0.0.1] - 2024-01-01

### Added
- Initial release of flutter_adaptive_theme package
- Support for multiple theme modes: System, Light, Dark, Time-based, and Custom
- Time-based theme switching with configurable hours
- Smooth theme transitions with customizable duration and curves
- Persistent theme preferences using SharedPreferences
- Provider integration for state management
- Context extensions for easy theme access
- Comprehensive example app demonstrating all features
- Full test coverage for all components
- MIT license

### Features
- **AdaptiveThemeMode**: Enum for different theme modes with helper methods
- **AdaptiveThemeConfig**: Configuration class for theme settings
- **TimeBasedThemeSettings**: Settings for time-based theme switching
- **AdaptiveTheme**: Core class managing theme logic and state
- **AdaptiveThemeProvider**: Provider class for state management
- **AdaptiveThemeWidget**: Widget providing theme functionality
- **AdaptiveThemeApp**: Convenient app wrapper
- **AdaptiveThemeContent**: Theme-aware content widget

### Dependencies
- Flutter SDK >=3.10.0
- Dart SDK >=3.0.0
- shared_preferences: ^2.0.0
- provider: ^6.0.0