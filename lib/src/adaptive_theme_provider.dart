import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'adaptive_theme.dart';
import 'theme_modes.dart';
import 'theme_config.dart';

/// Provider class for adaptive theme state management
class AdaptiveThemeProvider extends ChangeNotifier {
  AdaptiveTheme? _adaptiveTheme;
  AdaptiveThemeConfig? _config;

  /// Current theme data
  ThemeData get theme => _adaptiveTheme?.currentTheme ?? ThemeData();

  /// Current theme mode
  AdaptiveThemeMode get mode =>
      _adaptiveTheme?.currentMode ?? AdaptiveThemeMode.system;

  /// Current configuration
  AdaptiveThemeConfig? get config => _config;

  /// Whether the current theme is dark
  bool get isDark => _adaptiveTheme?.isDark ?? false;

  /// Whether the current theme is light
  bool get isLight => _adaptiveTheme?.isLight ?? true;

  /// Whether the provider is initialized
  bool get isInitialized => _adaptiveTheme != null;

  /// Initialize the provider with configuration
  Future<void> initialize(AdaptiveThemeConfig config) async {
    _config = config;
    _adaptiveTheme = AdaptiveTheme();
    await _adaptiveTheme!.initialize(config);

    // Listen to theme changes
    _adaptiveTheme?.themeStream.listen((theme) {
      notifyListeners();
    });

    // Listen to mode changes
    _adaptiveTheme?.modeStream.listen((mode) {
      notifyListeners();
    });
  }

  /// Set the theme mode
  Future<void> setMode(AdaptiveThemeMode mode) async {
    await _adaptiveTheme?.setMode(mode);
  }

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    await _adaptiveTheme?.toggleTheme();
  }

  /// Update the configuration
  Future<void> updateConfig(AdaptiveThemeConfig newConfig) async {
    await _adaptiveTheme?.updateConfig(newConfig);
    _config = newConfig;
  }

  /// Dispose the provider
  @override
  void dispose() {
    _adaptiveTheme?.dispose();
    super.dispose();
  }
}

/// Extension to provide easy access to AdaptiveThemeProvider
extension AdaptiveThemeProviderExtension on BuildContext {
  /// Get the AdaptiveThemeProvider from the widget tree
  AdaptiveThemeProvider get adaptiveTheme =>
      Provider.of<AdaptiveThemeProvider>(this, listen: false);

  /// Get the current theme
  ThemeData get theme => adaptiveTheme.theme;

  /// Get the current theme mode
  AdaptiveThemeMode get themeMode => adaptiveTheme.mode;

  /// Check if the current theme is dark
  bool get isDarkTheme => adaptiveTheme.isDark;

  /// Check if the current theme is light
  bool get isLightTheme => adaptiveTheme.isLight;

  /// Watch the adaptive theme provider
  AdaptiveThemeProvider watchAdaptiveTheme() =>
      Provider.of<AdaptiveThemeProvider>(this);
}
