# Flutter Adaptive Theme

A Flutter package for adaptive themes with Material 3 support and custom theme builders.

[![Pub Version](https://img.shields.io/pub/v/flutter_adaptive_theme)](https://pub.dev/packages/flutter_adaptive_theme)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)

## Features

- 🌓 **Automatic Theme Switching**: Light, dark, system, custom, and time-based themes
- 🎨 **Material 3 Support**: Built-in Material 3 theme builders with ColorScheme.fromSeed
- 🔧 **Custom Theme Builders**: Advanced theme building with callbacks and customizations
- ⏰ **Time-based Themes**: Automatically switch themes based on time of day
- 💾 **Persistent Preferences**: Save and restore user theme preferences
- 🚀 **Smooth Transitions**: Configurable theme transition animations
- 📱 **System Integration**: Automatically follows system theme changes
- 🏆 **Perfect Quality**: 160/160 Pana score with zero linting issues

## Getting Started

### Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_adaptive_theme: ^0.0.3
```

### Basic Usage

```dart
import 'package:flutter_adaptive_theme/flutter_adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final adaptiveTheme = AdaptiveTheme();
  
  await adaptiveTheme.initialize(
    AdaptiveThemeConfig(
      mode: AdaptiveThemeMode.system,
      lightTheme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
    ),
  );
  
  runApp(MyApp(adaptiveTheme: adaptiveTheme));
}
```

## Material 3 Support

### Seed Color Theme Builder

Create themes using `ColorScheme.fromSeed`:

```dart
final seedBuilder = SeedColorThemeBuilder(
  seedColor: Colors.blue,
  useMaterial3: true,
);

final lightTheme = seedBuilder.buildLightTheme();
final darkTheme = seedBuilder.buildDarkTheme();
```

### Custom Color Scheme Builder

Use custom ColorScheme objects:

```dart
final customBuilder = CustomColorSchemeBuilder(
  lightColorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.light,
  ),
  darkColorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark,
  ),
);
```

### Dynamic Color Theme Builder

Support dynamic colors with fallback:

```dart
final dynamicBuilder = DynamicColorThemeBuilder(
  fallbackSeedColor: Colors.indigo,
  useMaterial3: true,
);
```

### Component Theme Builder

Customize specific component themes:

```dart
final componentBuilder = ComponentThemeBuilder(
  baseBuilder: seedBuilder,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
  ),
  cardTheme: const CardTheme(
    elevation: 4,
    margin: EdgeInsets.all(8),
  ),
);
```

## Custom Theme Builders

### Callback-based Builders

Create themes using custom callbacks:

```dart
final callbackBuilder = CustomThemeBuilderUtils.fromCallback(
  (brightness, colorScheme, customData) {
    final baseColor = customData?['baseColor'] ?? Colors.red;
    final scheme = ColorScheme.fromSeed(
      seedColor: baseColor,
      brightness: brightness,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
    );
  },
  customData: {'baseColor': Colors.amber},
);
```

### Mutable Custom Theme Builders

Update theme data dynamically:

```dart
final mutableBuilder = CustomThemeBuilderUtils.fromMutableCallback(
  (brightness, colorScheme, customData) {
    // Your theme building logic
    return ThemeData(useMaterial3: true);
  },
);

// Update custom data
mutableBuilder.updateCustomData({'newColor': Colors.green});
```

### Composite Theme Builders

Combine multiple builders:

```dart
final compositeBuilder = CompositeThemeBuilder(
  builders: [seedBuilder, componentBuilder],
);
```

### Conditional Theme Builders

Choose builders based on conditions:

```dart
final conditionalBuilder = ConditionalThemeBuilder(
  trueBuilder: seedBuilder,
  falseBuilder: customBuilder,
  condition: () => DateTime.now().hour < 12, // Use seed builder before noon
);
```

## Advanced Configuration

### Using Material 3 Builders

```dart
final config = AdaptiveThemeConfig(
  mode: AdaptiveThemeMode.system,
  material3Builder: SeedColorThemeBuilder(
    seedColor: Colors.blue,
    useMaterial3: true,
  ),
  // Individual themes are ignored when material3Builder is provided
);
```

### Using Custom Theme Builders

```dart
final config = AdaptiveThemeConfig(
  mode: AdaptiveThemeMode.system,
  customThemeBuilder: CustomThemeBuilderUtils.fromCallback(
    (brightness, colorScheme, customData) {
      // Your advanced theme building logic
      return ThemeData(useMaterial3: true);
    },
  ),
);
```

### Theme Transitions

```dart
final config = AdaptiveThemeConfig(
  mode: AdaptiveThemeMode.system,
  lightTheme: ThemeData.light(useMaterial3: true),
  darkTheme: ThemeData.dark(useMaterial3: true),
  transitionDuration: const Duration(milliseconds: 500),
  transitionCurve: Curves.easeInOutCubic,
);
```

### Time-based Themes

```dart
final config = AdaptiveThemeConfig(
  mode: AdaptiveThemeMode.timeBased,
  lightTheme: ThemeData.light(useMaterial3: true),
  darkTheme: ThemeData.dark(useMaterial3: true),
  timeBasedSettings: const TimeBasedThemeSettings(
    darkThemeStartHour: 18, // 6 PM
    lightThemeStartHour: 6,  // 6 AM
  ),
);
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_theme/flutter_adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final adaptiveTheme = AdaptiveTheme();
  
  // Create a Material 3 theme builder
  final material3Builder = SeedColorThemeBuilder(
    seedColor: Colors.blue,
    useMaterial3: true,
  );
  
  await adaptiveTheme.initialize(
    AdaptiveThemeConfig(
      mode: AdaptiveThemeMode.system,
      material3Builder: material3Builder,
      transitionDuration: const Duration(milliseconds: 300),
      savePreferences: true,
      debug: true,
    ),
  );
  
  runApp(MyApp(adaptiveTheme: adaptiveTheme));
}

class MyApp extends StatelessWidget {
  final AdaptiveTheme adaptiveTheme;
  
  const MyApp({super.key, required this.adaptiveTheme});
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
      stream: adaptiveTheme.themeStream,
      initialData: adaptiveTheme.currentTheme,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Adaptive Theme Demo',
          theme: snapshot.data,
          home: const MyHomePage(),
        );
      },
    );
  }
}
```

## API Reference

### Core Classes

- `AdaptiveTheme`: Main theme management class
- `AdaptiveThemeConfig`: Configuration for theme settings
- `AdaptiveThemeMode`: Available theme modes

### Material 3 Builders

- `Material3ThemeBuilder`: Base class for Material 3 builders
- `SeedColorThemeBuilder`: Creates themes from seed colors
- `CustomColorSchemeBuilder`: Uses custom ColorScheme objects
- `DynamicColorThemeBuilder`: Supports dynamic colors
- `ComponentThemeBuilder`: Customizes component themes

### Custom Theme Builders

- `CustomThemeBuilder`: Base class for custom builders
- `CallbackThemeBuilder`: Uses callback functions
- `MutableCustomThemeBuilder`: Supports runtime updates
- `CompositeThemeBuilder`: Combines multiple builders
- `ConditionalThemeBuilder`: Conditional theme selection

### Utilities

- `Material3ThemeUtils`: Helper methods for Material 3 themes
- `CustomThemeBuilderUtils`: Helper methods for custom builders

## Quality & Standards

This package maintains the highest quality standards:

- ✅ **Perfect Pana Score**: 160/160 points
- ✅ **Zero Linting Issues**: All static analysis issues resolved
- ✅ **Full Test Coverage**: Comprehensive test suite
- ✅ **Modern Flutter**: Uses latest Flutter best practices
- ✅ **Material 3 Ready**: Full Material 3 support
- ✅ **Cross-Platform**: Supports all 6 platforms (iOS, Android, Web, Windows, macOS, Linux)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 