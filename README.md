# flutter_adaptive_theme

A Flutter package that automatically adapts your app's theme based on system settings, time of day, or user preferences with smooth transitions.

## Features

- 🌓 **Multiple Theme Modes**: System, Light, Dark, Time-based, and Custom
- ⏰ **Time-based Themes**: Automatically switch themes based on time of day
- 🔄 **Smooth Transitions**: Animated theme changes with customizable duration and curves
- 💾 **Persistent Preferences**: Save and restore user theme preferences
- 🎨 **Custom Themes**: Support for custom theme configurations
- 📱 **System Integration**: Follow system theme changes automatically
- 🛠️ **Provider Integration**: Built-in support for state management with Provider

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_adaptive_theme: ^0.0.2
```

## Quick Start

### 1. Basic Setup

```dart
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_theme/flutter_adaptive_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveThemeApp(
      config: AdaptiveThemeConfig(
        mode: AdaptiveThemeMode.system,
        lightTheme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
      ),
      home: MyHomePage(),
    );
  }
}
```

### 2. Using the Provider

```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveThemeContent(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Adaptive Theme Demo'),
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                // Toggle between light and dark themes
                context.adaptiveTheme.toggleTheme();
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Theme: ${context.themeMode.displayName}',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Switch to system theme
                  context.adaptiveTheme.setMode(AdaptiveThemeMode.system);
                },
                child: Text('System Theme'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Switch to time-based theme
                  context.adaptiveTheme.setMode(AdaptiveThemeMode.timeBased);
                },
                child: Text('Time-based Theme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Advanced Configuration

### Time-based Theme Settings

```dart
AdaptiveThemeConfig(
  mode: AdaptiveThemeMode.timeBased,
  lightTheme: lightTheme,
  darkTheme: darkTheme,
  timeBasedSettings: TimeBasedThemeSettings(
    darkThemeStartHour: 18, // 6 PM
    lightThemeStartHour: 6, // 6 AM
    use24HourFormat: true,
  ),
)
```

### Custom Transition Settings

```dart
AdaptiveThemeConfig(
  mode: AdaptiveThemeMode.system,
  lightTheme: lightTheme,
  darkTheme: darkTheme,
  transitionDuration: Duration(milliseconds: 500),
  transitionCurve: Curves.easeInOutCubic,
)
```

### Custom Theme Mode

```dart
AdaptiveThemeConfig(
  mode: AdaptiveThemeMode.custom,
  lightTheme: lightTheme,
  darkTheme: darkTheme,
  customTheme: ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.purple,
    // Your custom theme configuration
  ),
)
```

## API Reference

### AdaptiveThemeMode

- `system`: Follows the system theme setting
- `light`: Always uses light theme
- `dark`: Always uses dark theme
- `timeBased`: Automatically switches based on time of day
- `custom`: Custom adaptive mode based on user preferences

### AdaptiveThemeConfig

| Property | Type | Description |
|----------|------|-------------|
| `mode` | `AdaptiveThemeMode` | The current theme mode |
| `lightTheme` | `ThemeData` | Light theme configuration |
| `darkTheme` | `ThemeData` | Dark theme configuration |
| `customTheme` | `ThemeData?` | Custom theme configuration (optional) |
| `transitionDuration` | `Duration` | Duration for theme transitions |
| `transitionCurve` | `Curve` | Curve for theme transitions |
| `timeBasedSettings` | `TimeBasedThemeSettings?` | Time-based theme settings |
| `savePreferences` | `bool` | Whether to save theme preferences |
| `storageKey` | `String` | Storage key for preferences |
| `debug` | `bool` | Whether to show debug information |

### Context Extensions

```dart
// Get the adaptive theme provider
context.adaptiveTheme

// Get the current theme
context.theme

// Get the current theme mode
context.themeMode

// Check if current theme is dark
context.isDarkTheme

// Check if current theme is light
context.isLightTheme

// Watch the adaptive theme provider
context.watchAdaptiveTheme()
```

### Provider Methods

```dart
// Set theme mode
await provider.setMode(AdaptiveThemeMode.dark);

// Toggle between light and dark
await provider.toggleTheme();

// Update configuration
await provider.updateConfig(newConfig);
```

## Examples

### Theme Mode Selector

```dart
class ThemeModeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdaptiveThemeProvider>(
      builder: (context, provider, child) {
        return DropdownButton<AdaptiveThemeMode>(
          value: provider.mode,
          onChanged: (AdaptiveThemeMode? newMode) {
            if (newMode != null) {
              provider.setMode(newMode);
            }
          },
          items: AdaptiveThemeMode.values.map((AdaptiveThemeMode mode) {
            return DropdownMenuItem<AdaptiveThemeMode>(
              value: mode,
              child: Text(mode.displayName),
            );
          }).toList(),
        );
      },
    );
  }
}
```

### Theme-aware Widget

```dart
class ThemeAwareWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdaptiveThemeProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: provider.isDark 
              ? Colors.grey[800] 
              : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'This widget adapts to the current theme',
            style: TextStyle(
              color: provider.isDark 
                ? Colors.white 
                : Colors.black,
            ),
          ),
        );
      },
    );
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 