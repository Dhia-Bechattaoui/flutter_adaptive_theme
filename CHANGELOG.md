# Changelog

## [0.0.3] - 2024-08-30

### Added
- **Material 3 Support**: Added comprehensive Material 3 theme builders
  - `SeedColorThemeBuilder`: Creates themes using `ColorScheme.fromSeed`
  - `CustomColorSchemeBuilder`: Uses custom ColorScheme objects
  - `DynamicColorThemeBuilder`: Supports dynamic colors with fallback
  - `ComponentThemeBuilder`: Customizes specific component themes
  - `Material3ThemeUtils`: Helper methods for Material 3 themes

- **Custom Theme Builders**: Added advanced theme building capabilities
  - `CustomThemeBuilder`: Base class for custom builders
  - `CallbackThemeBuilder`: Uses callback functions for theme creation
  - `MutableCustomThemeBuilder`: Supports runtime theme data updates
  - `CompositeThemeBuilder`: Combines multiple builders
  - `ConditionalThemeBuilder`: Conditional theme selection
  - `CustomThemeBuilderUtils`: Helper methods for custom builders

- **Enhanced Configuration**: Extended `AdaptiveThemeConfig` with:
  - `material3Builder`: Optional Material 3 theme builder
  - `customThemeBuilder`: Optional custom theme builder
  - `useMaterial3`: Default Material 3 setting
  - Effective theme getters that consider builders

### Changed
- Updated Flutter SDK requirement to ensure Material 3 compatibility
- Enhanced theme resolution to prioritize Material 3 and custom builders
- Improved theme building pipeline with builder pattern
- Fixed all linting issues and code formatting
- Updated to use modern Flutter ThemeData constructors

### Documentation
- Comprehensive README with Material 3 examples
- Custom theme builder usage examples
- Material 3 theme builder demonstrations
- Advanced configuration examples
- Fixed package description length for pub.dev compliance

### Quality
- Achieved perfect Pana score: 160/160
- All static analysis issues resolved
- Code formatting standardized with dart format
- Full test coverage maintained

## [0.0.2] - 2024-01-XX

### Added
- Initial release with basic adaptive theme functionality
- Support for light, dark, system, custom, and time-based themes
- Theme transition animations
- Persistent theme preferences
- Provider integration
- Time-based theme switching

### Features
- Multiple theme modes (system, light, dark, time-based, custom)
- Smooth theme transitions with customizable duration and curves
- Automatic system theme detection
- Time-based theme switching
- Theme preference persistence
- Provider-based state management