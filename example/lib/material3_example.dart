import 'package:flutter/material.dart';
import 'package:flutter_adaptive_theme/flutter_adaptive_theme.dart';

/// Example demonstrating Material 3 theme builders
class Material3Example extends StatelessWidget {
  const Material3Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Theme Builders'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Seed Color Theme Builder',
              'Creates themes using ColorScheme.fromSeed',
              _buildSeedColorExample(),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Custom Color Scheme Builder',
              'Creates themes with custom ColorScheme',
              _buildCustomColorSchemeExample(),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Dynamic Color Theme Builder',
              'Supports dynamic colors with fallback',
              _buildDynamicColorExample(),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Component Theme Builder',
              'Customizes specific component themes',
              _buildComponentThemeExample(),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Custom Theme Builder',
              'Advanced theme building with callbacks',
              _buildCustomThemeBuilderExample(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, Widget example) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        example,
      ],
    );
  }

  Widget _buildSeedColorExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Using SeedColorThemeBuilder'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildColorButton(
                  Colors.blue,
                  'Blue',
                  () => _showSeedColorTheme(Colors.blue),
                ),
                _buildColorButton(
                  Colors.green,
                  'Green',
                  () => _showSeedColorTheme(Colors.green),
                ),
                _buildColorButton(
                  Colors.purple,
                  'Purple',
                  () => _showSeedColorTheme(Colors.purple),
                ),
                _buildColorButton(
                  Colors.orange,
                  'Orange',
                  () => _showSeedColorTheme(Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomColorSchemeExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Using CustomColorSchemeBuilder'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showCustomColorSchemeTheme,
              child: const Text('Show Custom Color Scheme Theme'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicColorExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Using DynamicColorThemeBuilder'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showDynamicColorTheme,
              child: const Text('Show Dynamic Color Theme'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentThemeExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Using ComponentThemeBuilder'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showComponentTheme,
              child: const Text('Show Component Theme'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomThemeBuilderExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Using Custom Theme Builders'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showCustomThemeBuilder,
              child: const Text('Show Custom Theme Builder'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }

  void _showSeedColorTheme(Color seedColor) {
    final builder = SeedColorThemeBuilder(seedColor: seedColor);

    showDialog(
      context: _getContext(),
      builder: (context) => AlertDialog(
        title: Text('Seed Color: ${seedColor.toString()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemePreview(builder.buildLightTheme(), 'Light Theme'),
            const SizedBox(height: 16),
            _buildThemePreview(builder.buildDarkTheme(), 'Dark Theme'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCustomColorSchemeTheme() {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.light,
    );

    final darkScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    );

    final builder = CustomColorSchemeBuilder(
      lightColorScheme: lightScheme,
      darkColorScheme: darkScheme,
    );

    showDialog(
      context: _getContext(),
      builder: (context) => AlertDialog(
        title: const Text('Custom Color Scheme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemePreview(builder.buildLightTheme(), 'Light Theme'),
            const SizedBox(height: 16),
            _buildThemePreview(builder.buildDarkTheme(), 'Dark Theme'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDynamicColorTheme() {
    final builder = DynamicColorThemeBuilder(
      fallbackSeedColor: Colors.indigo,
    );

    showDialog(
      context: _getContext(),
      builder: (context) => AlertDialog(
        title: const Text('Dynamic Color Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemePreview(builder.buildLightTheme(), 'Light Theme'),
            const SizedBox(height: 16),
            _buildThemePreview(builder.buildDarkTheme(), 'Dark Theme'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showComponentTheme() {
    final baseBuilder = SeedColorThemeBuilder(seedColor: Colors.deepPurple);

    final builder = ComponentThemeBuilder(
      baseBuilder: baseBuilder,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardTheme(
        elevation: 4,
        margin: EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );

    showDialog(
      context: _getContext(),
      builder: (context) => AlertDialog(
        title: const Text('Component Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemePreview(builder.buildLightTheme(), 'Light Theme'),
            const SizedBox(height: 16),
            _buildThemePreview(builder.buildDarkTheme(), 'Dark Theme'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCustomThemeBuilder() {
    final builder = CustomThemeBuilderUtils.fromCallback(
      (brightness, colorScheme, customData) {
        final baseColor = customData?['baseColor'] ?? Colors.red;
        final scheme = ColorScheme.fromSeed(
          seedColor: baseColor,
          brightness: brightness,
        );

        return ThemeData(
          colorScheme: scheme,
          brightness: brightness,
          textTheme: ThemeData(brightness: brightness).textTheme.apply(
                bodyColor: scheme.onSurface,
                displayColor: scheme.onSurface,
              ),
        );
      },
      customData: {'baseColor': Colors.amber},
    );

    // Note: In a real app, you would pass the BuildContext from the widget
    // This is just a demonstration - the context should come from the widget
    debugPrint('Custom theme builder created - would show dialog in real app');
  }

  Widget _buildThemePreview(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Note: This method is not used in the current implementation
  // In a real app, you would pass the BuildContext from the widget
  BuildContext _getContext() {
    throw UnsupportedError(
      'This method is not supported. Pass BuildContext from the widget instead.',
    );
  }
}
