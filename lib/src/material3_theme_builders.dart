import 'package:flutter/material.dart';

/// Base class for Material 3 theme builders
abstract class Material3ThemeBuilder {
  const Material3ThemeBuilder();

  /// Build a light theme
  ThemeData buildLightTheme();

  /// Build a dark theme
  ThemeData buildDarkTheme();

  /// Build a theme with custom brightness
  ThemeData buildTheme(final Brightness brightness);
}

/// Material 3 theme builder using ColorScheme.fromSeed
class SeedColorThemeBuilder extends Material3ThemeBuilder {
  const SeedColorThemeBuilder({
    required this.seedColor,
    this.useMaterial3 = true,
    this.lightColorScheme,
    this.darkColorScheme,
    this.baseTheme,
  });

  final Color seedColor;
  final bool useMaterial3;
  final ColorScheme? lightColorScheme;
  final ColorScheme? darkColorScheme;
  final ThemeData? baseTheme;

  @override
  ThemeData buildLightTheme() {
    final colorScheme =
        lightColorScheme ??
        ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        );

    return _buildTheme(colorScheme, Brightness.light);
  }

  @override
  ThemeData buildDarkTheme() {
    final colorScheme =
        darkColorScheme ??
        ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark);

    return _buildTheme(colorScheme, Brightness.dark);
  }

  @override
  ThemeData buildTheme(final Brightness brightness) {
    return brightness == Brightness.dark ? buildDarkTheme() : buildLightTheme();
  }

  ThemeData _buildTheme(
    final ColorScheme colorScheme,
    final Brightness brightness,
  ) {
    final theme = baseTheme ?? ThemeData();

    return theme.copyWith(colorScheme: colorScheme, brightness: brightness);
  }
}

/// Material 3 theme builder using custom ColorScheme
class CustomColorSchemeBuilder extends Material3ThemeBuilder {
  const CustomColorSchemeBuilder({
    required this.lightColorScheme,
    required this.darkColorScheme,
    this.useMaterial3 = true,
    this.baseTheme,
  });

  final ColorScheme lightColorScheme;
  final ColorScheme darkColorScheme;
  final bool useMaterial3;
  final ThemeData? baseTheme;

  @override
  ThemeData buildLightTheme() {
    return _buildTheme(lightColorScheme, Brightness.light);
  }

  @override
  ThemeData buildDarkTheme() {
    return _buildTheme(darkColorScheme, Brightness.dark);
  }

  @override
  ThemeData buildTheme(final Brightness brightness) {
    return brightness == Brightness.dark ? buildDarkTheme() : buildLightTheme();
  }

  ThemeData _buildTheme(
    final ColorScheme colorScheme,
    final Brightness brightness,
  ) {
    final theme = baseTheme ?? ThemeData();

    return theme.copyWith(colorScheme: colorScheme, brightness: brightness);
  }
}

/// Material 3 theme builder with dynamic color support
class DynamicColorThemeBuilder extends Material3ThemeBuilder {
  const DynamicColorThemeBuilder({
    this.fallbackSeedColor,
    this.useMaterial3 = true,
    this.baseTheme,
  });

  final Color? fallbackSeedColor;
  final bool useMaterial3;
  final ThemeData? baseTheme;

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
    final theme = baseTheme ?? ThemeData();

    // Try to use dynamic colors if available
    ColorScheme? colorScheme;

    if (useMaterial3 && fallbackSeedColor != null) {
      try {
        colorScheme = ColorScheme.fromSeed(
          seedColor: fallbackSeedColor!,
          brightness: brightness,
        );
      } catch (e) {
        // Fallback to default color scheme
        colorScheme = brightness == Brightness.dark
            ? ColorScheme.fromSeed(
                seedColor: fallbackSeedColor!,
                brightness: Brightness.dark,
              )
            : ColorScheme.fromSeed(
                seedColor: fallbackSeedColor!,
                brightness: Brightness.light,
              );
      }
    }

    return theme.copyWith(colorScheme: colorScheme, brightness: brightness);
  }
}

/// Material 3 theme builder with custom component themes
class ComponentThemeBuilder extends Material3ThemeBuilder {
  const ComponentThemeBuilder({
    required this.baseBuilder,
    this.appBarTheme,
    this.cardTheme,
    this.elevatedButtonTheme,
    this.textButtonTheme,
    this.outlinedButtonTheme,
    this.inputDecorationTheme,
    this.bottomNavigationBarTheme,
    this.floatingActionButtonTheme,
  });

  final Material3ThemeBuilder baseBuilder;
  final AppBarTheme? appBarTheme;
  final CardThemeData? cardTheme;
  final ElevatedButtonThemeData? elevatedButtonTheme;
  final TextButtonThemeData? textButtonTheme;
  final OutlinedButtonThemeData? outlinedButtonTheme;
  final InputDecorationTheme? inputDecorationTheme;
  final BottomNavigationBarThemeData? bottomNavigationBarTheme;
  final FloatingActionButtonThemeData? floatingActionButtonTheme;

  @override
  ThemeData buildLightTheme() {
    return _applyComponentThemes(baseBuilder.buildLightTheme());
  }

  @override
  ThemeData buildDarkTheme() {
    return _applyComponentThemes(baseBuilder.buildDarkTheme());
  }

  @override
  ThemeData buildTheme(final Brightness brightness) {
    return _applyComponentThemes(baseBuilder.buildTheme(brightness));
  }

  ThemeData _applyComponentThemes(final ThemeData baseTheme) {
    return baseTheme.copyWith(
      appBarTheme: appBarTheme,
      cardTheme: cardTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      textButtonTheme: textButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      inputDecorationTheme: inputDecorationTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
    );
  }
}

/// Utility class for creating common Material 3 themes
class Material3ThemeUtils {
  const Material3ThemeUtils._();

  /// Create a theme with Material 3 enabled and seed color
  static ThemeData createSeedTheme({
    required final Color seedColor,
    required final Brightness brightness,
    final bool useMaterial3 = true,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    if (brightness == Brightness.light) {
      return ThemeData.light(
        useMaterial3: useMaterial3,
      ).copyWith(colorScheme: colorScheme);
    } else {
      return ThemeData.dark(
        useMaterial3: useMaterial3,
      ).copyWith(colorScheme: colorScheme);
    }
  }

  /// Create a theme with Material 3 enabled and custom color scheme
  static ThemeData createCustomTheme({
    required final ColorScheme colorScheme,
    final bool useMaterial3 = true,
  }) {
    if (colorScheme.brightness == Brightness.light) {
      return ThemeData.light(
        useMaterial3: useMaterial3,
      ).copyWith(colorScheme: colorScheme);
    } else {
      return ThemeData.dark(
        useMaterial3: useMaterial3,
      ).copyWith(colorScheme: colorScheme);
    }
  }

  /// Create a theme with Material 3 enabled and dynamic colors
  static ThemeData createDynamicTheme({
    required final Brightness brightness,
    final Color? fallbackSeedColor,
    final bool useMaterial3 = true,
  }) {
    ColorScheme? colorScheme;

    if (fallbackSeedColor != null) {
      colorScheme = ColorScheme.fromSeed(
        seedColor: fallbackSeedColor,
        brightness: brightness,
      );
    }

    if (brightness == Brightness.light) {
      return ThemeData.light(
        useMaterial3: useMaterial3,
      ).copyWith(colorScheme: colorScheme);
    } else {
      return ThemeData.dark(
        useMaterial3: useMaterial3,
      ).copyWith(colorScheme: colorScheme);
    }
  }
}
