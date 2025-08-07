import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_modes.dart';
import 'theme_config.dart';

/// Main class for managing adaptive themes
class AdaptiveTheme {
  late AdaptiveThemeConfig _config;
  late SharedPreferences _prefs;

  final StreamController<ThemeData> _themeController =
      StreamController<ThemeData>.broadcast();
  final StreamController<AdaptiveThemeMode> _modeController =
      StreamController<AdaptiveThemeMode>.broadcast();

  Timer? _timeBasedTimer;
  bool _isInitialized = false;

  /// Stream of theme changes
  Stream<ThemeData> get themeStream => _themeController.stream;

  /// Stream of mode changes
  Stream<AdaptiveThemeMode> get modeStream => _modeController.stream;

  /// Current theme data
  ThemeData get currentTheme => _getCurrentTheme();

  /// Current theme mode
  AdaptiveThemeMode get currentMode => _config.mode;

  /// Current configuration
  AdaptiveThemeConfig get config => _config;

  AdaptiveTheme();

  /// Initialize the adaptive theme system
  Future<void> initialize(AdaptiveThemeConfig config) async {
    if (_isInitialized) {
      throw StateError('AdaptiveTheme is already initialized');
    }

    await _initialize(config);
  }

  Future<void> _initialize(AdaptiveThemeConfig config) async {
    _config = config;
    _prefs = await SharedPreferences.getInstance();

    // Load saved preferences if enabled
    if (_config.savePreferences) {
      await _loadPreferences();
    }

    // Set up time-based theme switching if enabled
    if (_config.mode == AdaptiveThemeMode.timeBased) {
      _setupTimeBasedTheme();
    }

    // Listen to system theme changes
    _listenToSystemTheme();

    _isInitialized = true;

    if (_config.debug) {
      debugPrint(
          'AdaptiveTheme initialized with mode: ${_config.mode.displayName}');
    }
  }

  /// Set the theme mode
  Future<void> setMode(AdaptiveThemeMode mode) async {
    if (!_isInitialized) {
      throw StateError('AdaptiveTheme is not initialized');
    }

    _config = _config.copyWith(mode: mode);

    // Stop time-based timer if switching away from time-based mode
    if (mode != AdaptiveThemeMode.timeBased) {
      _timeBasedTimer?.cancel();
    } else {
      _setupTimeBasedTheme();
    }

    // Save preferences
    if (_config.savePreferences) {
      await _savePreferences();
    }

    // Notify listeners
    _themeController.add(_getCurrentTheme());
    _modeController.add(mode);

    if (_config.debug) {
      debugPrint('Theme mode changed to: ${mode.displayName}');
    }
  }

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    final currentTheme = _getCurrentTheme();
    final isDark = currentTheme.brightness == Brightness.dark;

    await setMode(isDark ? AdaptiveThemeMode.light : AdaptiveThemeMode.dark);
  }

  /// Update the configuration
  Future<void> updateConfig(AdaptiveThemeConfig newConfig) async {
    if (!_isInitialized) {
      throw StateError('AdaptiveTheme is not initialized');
    }

    _config = newConfig;

    // Update time-based theme if needed
    if (_config.mode == AdaptiveThemeMode.timeBased) {
      _setupTimeBasedTheme();
    } else {
      _timeBasedTimer?.cancel();
    }

    // Save preferences
    if (_config.savePreferences) {
      await _savePreferences();
    }

    // Notify listeners
    _themeController.add(_getCurrentTheme());
    _modeController.add(_config.mode);

    if (_config.debug) {
      debugPrint('Configuration updated');
    }
  }

  /// Get the current theme based on the mode
  ThemeData _getCurrentTheme() {
    switch (_config.mode) {
      case AdaptiveThemeMode.light:
        return _config.lightTheme;
      case AdaptiveThemeMode.dark:
        return _config.darkTheme;
      case AdaptiveThemeMode.custom:
        return _config.customTheme ?? _config.lightTheme;
      case AdaptiveThemeMode.system:
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark
            ? _config.darkTheme
            : _config.lightTheme;
      case AdaptiveThemeMode.timeBased:
        return _getTimeBasedTheme();
    }
  }

  /// Get theme based on current time
  ThemeData _getTimeBasedTheme() {
    final now = DateTime.now();
    final hour = now.hour;
    final settings =
        _config.timeBasedSettings ?? const TimeBasedThemeSettings();

    // Check if it's dark theme time
    if (hour >= settings.darkThemeStartHour ||
        hour < settings.lightThemeStartHour) {
      return _config.darkTheme;
    } else {
      return _config.lightTheme;
    }
  }

  /// Set up time-based theme switching
  void _setupTimeBasedTheme() {
    _timeBasedTimer?.cancel();

    _timeBasedTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_config.mode == AdaptiveThemeMode.timeBased) {
        final newTheme = _getTimeBasedTheme();
        _themeController.add(newTheme);

        if (_config.debug) {
          debugPrint('Time-based theme updated: ${newTheme.brightness}');
        }
      } else {
        timer.cancel();
      }
    });
  }

  /// Listen to system theme changes
  void _listenToSystemTheme() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      if (_config.mode == AdaptiveThemeMode.system) {
        final newTheme = _getCurrentTheme();
        _themeController.add(newTheme);

        if (_config.debug) {
          debugPrint('System theme changed: ${newTheme.brightness}');
        }
      }
    };
  }

  /// Load saved preferences
  Future<void> _loadPreferences() async {
    try {
      final modeString = _prefs.getString('${_config.storageKey}_mode');
      if (modeString != null) {
        final savedMode = AdaptiveThemeModeExtension.fromString(modeString);
        _config = _config.copyWith(mode: savedMode);

        if (_config.debug) {
          debugPrint('Loaded saved theme mode: ${savedMode.displayName}');
        }
      }
    } catch (e) {
      if (_config.debug) {
        debugPrint('Error loading preferences: $e');
      }
    }
  }

  /// Save preferences
  Future<void> _savePreferences() async {
    try {
      await _prefs.setString(
          '${_config.storageKey}_mode', _config.mode.stringValue);

      if (_config.debug) {
        debugPrint('Saved theme mode: ${_config.mode.displayName}');
      }
    } catch (e) {
      if (_config.debug) {
        debugPrint('Error saving preferences: $e');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _timeBasedTimer?.cancel();
    _themeController.close();
    _modeController.close();
    _isInitialized = false;
  }

  /// Check if the theme is currently dark
  bool get isDark => currentTheme.brightness == Brightness.dark;

  /// Check if the theme is currently light
  bool get isLight => currentTheme.brightness == Brightness.light;
}
