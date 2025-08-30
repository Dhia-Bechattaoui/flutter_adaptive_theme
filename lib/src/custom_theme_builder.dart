import 'package:flutter/material.dart';
import 'material3_theme_builders.dart';

/// Callback type for building custom themes
typedef ThemeBuilderCallback =
    ThemeData Function(
      Brightness brightness,
      ColorScheme? colorScheme,
      Map<String, dynamic>? customData,
    );

/// Callback type for building custom color schemes
typedef ColorSchemeBuilderCallback =
    ColorScheme Function(
      Brightness brightness,
      Map<String, dynamic>? customData,
    );

/// Base class for custom theme builders
abstract class CustomThemeBuilder {
  const CustomThemeBuilder();

  /// Build a light theme
  ThemeData buildLightTheme();

  /// Build a dark theme
  ThemeData buildDarkTheme();

  /// Build a theme with custom brightness
  ThemeData buildTheme(final Brightness brightness);

  /// Get the current custom data
  Map<String, dynamic>? get customData;

  /// Update custom data
  void updateCustomData(final Map<String, dynamic> newData);
}

/// Custom theme builder using callbacks
class CallbackThemeBuilder extends CustomThemeBuilder {
  const CallbackThemeBuilder({
    required this.themeBuilder,
    this.colorSchemeBuilder,
    this.useMaterial3 = true,
    final Map<String, dynamic>? customData,
  }) : _customData = customData;

  final ThemeBuilderCallback themeBuilder;
  final ColorSchemeBuilderCallback? colorSchemeBuilder;
  final bool useMaterial3;
  final Map<String, dynamic>? _customData;

  @override
  ThemeData buildLightTheme() {
    return _buildTheme(Brightness.light);
  }

  @override
  ThemeData buildDarkTheme() {
    return _buildTheme(Brightness.dark);
  }

  @override
  ThemeData buildTheme(final Brightness brightness) {
    return _buildTheme(brightness);
  }

  ThemeData _buildTheme(final Brightness brightness) {
    ColorScheme? colorScheme;

    if (colorSchemeBuilder != null) {
      colorScheme = colorSchemeBuilder!(brightness, _customData);
    }

    return themeBuilder(brightness, colorScheme, _customData);
  }

  @override
  Map<String, dynamic>? get customData => _customData;

  @override
  void updateCustomData(final Map<String, dynamic> newData) {
    // Note: This is a limitation of the current implementation
    // In a real implementation, you might want to make this mutable
    throw UnsupportedError(
      'Custom data cannot be updated in CallbackThemeBuilder',
    );
  }
}

/// Mutable custom theme builder
class MutableCustomThemeBuilder extends CustomThemeBuilder {
  MutableCustomThemeBuilder({
    required this.themeBuilder,
    this.colorSchemeBuilder,
    this.useMaterial3 = true,
    final Map<String, dynamic>? customData,
  }) : _customData = customData;

  final ThemeBuilderCallback themeBuilder;
  final ColorSchemeBuilderCallback? colorSchemeBuilder;
  final bool useMaterial3;
  Map<String, dynamic>? _customData;

  @override
  ThemeData buildLightTheme() {
    return _buildTheme(Brightness.light);
  }

  @override
  ThemeData buildDarkTheme() {
    return _buildTheme(Brightness.dark);
  }

  @override
  ThemeData buildTheme(final Brightness brightness) {
    return _buildTheme(brightness);
  }

  ThemeData _buildTheme(final Brightness brightness) {
    ColorScheme? colorScheme;

    if (colorSchemeBuilder != null) {
      colorScheme = colorSchemeBuilder!(brightness, _customData);
    }

    return themeBuilder(brightness, colorScheme, _customData);
  }

  @override
  Map<String, dynamic>? get customData => _customData;

  @override
  void updateCustomData(final Map<String, dynamic> newData) {
    _customData = newData;
  }
}

/// Theme builder that combines multiple builders
class CompositeThemeBuilder extends CustomThemeBuilder {
  const CompositeThemeBuilder({
    required this.builders,
    this.useMaterial3 = true,
  });

  final List<CustomThemeBuilder> builders;
  final bool useMaterial3;

  @override
  ThemeData buildLightTheme() {
    return _buildTheme(Brightness.light);
  }

  @override
  ThemeData buildDarkTheme() {
    return _buildTheme(Brightness.dark);
  }

  @override
  ThemeData buildTheme(final Brightness brightness) {
    return _buildTheme(brightness);
  }

  ThemeData _buildTheme(final Brightness brightness) {
    ThemeData theme = ThemeData(useMaterial3: useMaterial3);

    for (final builder in builders) {
      final builderTheme = builder.buildTheme(brightness);
      theme = theme.copyWith(
        colorScheme: builderTheme.colorScheme,
        brightness: builderTheme.brightness,
        // Merge other theme properties as needed
      );
    }

    return theme;
  }

  @override
  Map<String, dynamic>? get customData {
    // Return combined custom data from all builders
    final combinedData = <String, dynamic>{};
    for (final builder in builders) {
      if (builder.customData != null) {
        combinedData.addAll(builder.customData!);
      }
    }
    return combinedData.isEmpty ? null : combinedData;
  }

  @override
  void updateCustomData(final Map<String, dynamic> newData) {
    // Update custom data in all builders that support it
    for (final builder in builders) {
      if (builder is MutableCustomThemeBuilder) {
        builder.updateCustomData(newData);
      }
    }
  }
}

/// Theme builder with conditional logic
class ConditionalThemeBuilder extends CustomThemeBuilder {
  const ConditionalThemeBuilder({
    required this.trueBuilder,
    required this.falseBuilder,
    required this.condition,
    this.useMaterial3 = true,
  });

  final CustomThemeBuilder trueBuilder;
  final CustomThemeBuilder falseBuilder;
  final bool Function() condition;
  final bool useMaterial3;

  @override
  ThemeData buildLightTheme() {
    return _getActiveBuilder().buildLightTheme();
  }

  @override
  ThemeData buildDarkTheme() {
    return _getActiveBuilder().buildDarkTheme();
  }

  @override
  ThemeData buildTheme(final Brightness brightness) {
    return _getActiveBuilder().buildTheme(brightness);
  }

  CustomThemeBuilder _getActiveBuilder() {
    return condition() ? trueBuilder : falseBuilder;
  }

  @override
  Map<String, dynamic>? get customData => _getActiveBuilder().customData;

  @override
  void updateCustomData(final Map<String, dynamic> newData) {
    _getActiveBuilder().updateCustomData(newData);
  }
}

/// Utility class for creating common custom theme builders
class CustomThemeBuilderUtils {
  const CustomThemeBuilderUtils._();

  /// Create a simple theme builder from a callback
  static CustomThemeBuilder fromCallback(
    final ThemeBuilderCallback callback, {
    final bool useMaterial3 = true,
    final Map<String, dynamic>? customData,
  }) {
    return CallbackThemeBuilder(
      themeBuilder: callback,
      useMaterial3: useMaterial3,
      customData: customData,
    );
  }

  /// Create a mutable theme builder from a callback
  static MutableCustomThemeBuilder fromMutableCallback(
    final ThemeBuilderCallback callback, {
    final bool useMaterial3 = true,
    final Map<String, dynamic>? customData,
  }) {
    return MutableCustomThemeBuilder(
      themeBuilder: callback,
      useMaterial3: useMaterial3,
      customData: customData,
    );
  }

  /// Create a theme builder that applies a transformation to an existing theme
  static CustomThemeBuilder transform(
    final CustomThemeBuilder baseBuilder,
    final ThemeData Function(ThemeData) transformer,
  ) {
    return CallbackThemeBuilder(
      themeBuilder:
          (
            final Brightness brightness,
            final ColorScheme? colorScheme,
            final Map<String, dynamic>? customData,
          ) {
            final baseTheme = baseBuilder.buildTheme(brightness);
            return transformer(baseTheme);
          },
      useMaterial3: baseBuilder is Material3ThemeBuilder,
    );
  }
}
