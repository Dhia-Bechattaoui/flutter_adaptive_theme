import 'package:flutter/material.dart';
import 'package:flutter_adaptive_theme/flutter_adaptive_theme.dart';
import 'package:provider/provider.dart';

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
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[900],
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        customTheme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.purple,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
        ),
        transitionDuration: Duration(milliseconds: 400),
        transitionCurve: Curves.easeInOut,
        timeBasedSettings: TimeBasedThemeSettings(
          darkThemeStartHour: 18, // 6 PM
          lightThemeStartHour: 6, // 6 AM
        ),
        savePreferences: true,
        debug: true,
      ),
      home: MyHomePage(),
    );
  }
}

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
                context.adaptiveTheme.toggleTheme();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThemeInfo(context),
              SizedBox(height: 24),
              _buildThemeModeSelector(context),
              SizedBox(height: 24),
              _buildThemeAwareWidgets(context),
              SizedBox(height: 24),
              _buildTimeBasedSettings(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeInfo(BuildContext context) {
    return Consumer<AdaptiveThemeProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Theme Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 12),
                _buildInfoRow('Mode', provider.mode.displayName),
                _buildInfoRow('Brightness', provider.isDark ? 'Dark' : 'Light'),
                _buildInfoRow(
                    'Primary Color', provider.theme.primaryColor.toString()),
                _buildInfoRow('Background Color',
                    provider.theme.scaffoldBackgroundColor.toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildThemeModeSelector(BuildContext context) {
    return Consumer<AdaptiveThemeProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Mode Selector',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<AdaptiveThemeMode>(
                  value: provider.mode,
                  decoration: InputDecoration(
                    labelText: 'Select Theme Mode',
                    border: OutlineInputBorder(),
                  ),
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
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => provider.toggleTheme(),
                        icon: Icon(Icons.swap_horiz),
                        label: Text('Toggle Theme'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            provider.setMode(AdaptiveThemeMode.system),
                        icon: Icon(Icons.settings),
                        label: Text('System'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeAwareWidgets(BuildContext context) {
    return Consumer<AdaptiveThemeProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme-aware Widgets',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        provider.isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: provider.isDark
                          ? Colors.grey[600]!
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    'This container adapts to the current theme',
                    style: TextStyle(
                      color: provider.isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: provider.isDark
                                ? [Colors.blue[700]!, Colors.purple[700]!]
                                : [Colors.blue[300]!, Colors.purple[300]!],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Gradient Card',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: provider.isDark
                              ? Colors.orange[800]
                              : Colors.orange[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Color Card',
                            style: TextStyle(
                              color: provider.isDark
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeBasedSettings(BuildContext context) {
    return Consumer<AdaptiveThemeProvider>(
      builder: (context, provider, child) {
        final settings = provider.config?.timeBasedSettings;
        if (settings == null) return SizedBox.shrink();

        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time-based Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 12),
                _buildInfoRow(
                    'Dark Theme Start', '${settings.darkThemeStartHour}:00'),
                _buildInfoRow(
                    'Light Theme Start', '${settings.lightThemeStartHour}:00'),
                _buildInfoRow(
                    '24-hour Format', settings.use24HourFormat ? 'Yes' : 'No'),
                SizedBox(height: 12),
                if (provider.mode == AdaptiveThemeMode.timeBased)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Text(
                      'Time-based theme is active! The theme will automatically switch based on the time of day.',
                      style: TextStyle(color: Colors.green[800]),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
