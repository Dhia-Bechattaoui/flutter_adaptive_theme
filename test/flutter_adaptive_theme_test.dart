import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_adaptive_theme/flutter_adaptive_theme.dart';
import 'package:provider/provider.dart';

void main() {
  group('AdaptiveTheme Tests', () {
    late AdaptiveThemeConfig testConfig;
    late ThemeData lightTheme;
    late ThemeData darkTheme;

    setUp(() {
      lightTheme = ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      );

      darkTheme = ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      );

      testConfig = AdaptiveThemeConfig(
        mode: AdaptiveThemeMode.system,
        lightTheme: lightTheme,
        darkTheme: darkTheme,
        transitionDuration: Duration(milliseconds: 300),
        transitionCurve: Curves.easeInOut,
        savePreferences: false,
        debug: false,
      );
    });

    testWidgets('AdaptiveThemeApp should build without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        AdaptiveThemeApp(
          config: testConfig,
          home: Scaffold(body: Text('Test')),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets(
      'AdaptiveThemeContent should show loading indicator initially',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider(
              create: (_) => AdaptiveThemeProvider(),
              child: AdaptiveThemeContent(child: Text('Content')),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    test('AdaptiveThemeMode should have correct display names', () {
      expect(AdaptiveThemeMode.system.displayName, equals('System'));
      expect(AdaptiveThemeMode.light.displayName, equals('Light'));
      expect(AdaptiveThemeMode.dark.displayName, equals('Dark'));
      expect(AdaptiveThemeMode.timeBased.displayName, equals('Time Based'));
      expect(AdaptiveThemeMode.custom.displayName, equals('Custom'));
    });

    test('AdaptiveThemeMode should have correct string values', () {
      expect(AdaptiveThemeMode.system.stringValue, equals('system'));
      expect(AdaptiveThemeMode.light.stringValue, equals('light'));
      expect(AdaptiveThemeMode.dark.stringValue, equals('dark'));
      expect(AdaptiveThemeMode.timeBased.stringValue, equals('time_based'));
      expect(AdaptiveThemeMode.custom.stringValue, equals('custom'));
    });

    test('AdaptiveThemeMode.fromString should work correctly', () {
      expect(
        AdaptiveThemeModeExtension.fromString('system'),
        equals(AdaptiveThemeMode.system),
      );
      expect(
        AdaptiveThemeModeExtension.fromString('light'),
        equals(AdaptiveThemeMode.light),
      );
      expect(
        AdaptiveThemeModeExtension.fromString('dark'),
        equals(AdaptiveThemeMode.dark),
      );
      expect(
        AdaptiveThemeModeExtension.fromString('time_based'),
        equals(AdaptiveThemeMode.timeBased),
      );
      expect(
        AdaptiveThemeModeExtension.fromString('custom'),
        equals(AdaptiveThemeMode.custom),
      );
      expect(
        AdaptiveThemeModeExtension.fromString('invalid'),
        equals(AdaptiveThemeMode.system),
      );
    });

    test('TimeBasedThemeSettings should have correct default values', () {
      final settings = TimeBasedThemeSettings();
      expect(settings.darkThemeStartHour, equals(18));
      expect(settings.lightThemeStartHour, equals(6));
      expect(settings.use24HourFormat, isTrue);
    });

    test('TimeBasedThemeSettings.copyWith should work correctly', () {
      final original = TimeBasedThemeSettings();
      final modified = original.copyWith(
        darkThemeStartHour: 20,
        lightThemeStartHour: 8,
        use24HourFormat: false,
      );

      expect(modified.darkThemeStartHour, equals(20));
      expect(modified.lightThemeStartHour, equals(8));
      expect(modified.use24HourFormat, isFalse);
    });

    test('AdaptiveThemeConfig.copyWith should work correctly', () {
      final modified = testConfig.copyWith(
        mode: AdaptiveThemeMode.light,
        transitionDuration: Duration(milliseconds: 500),
        debug: true,
      );

      expect(modified.mode, equals(AdaptiveThemeMode.light));
      expect(modified.transitionDuration, equals(Duration(milliseconds: 500)));
      expect(modified.debug, isTrue);
      expect(modified.lightTheme, equals(testConfig.lightTheme));
      expect(modified.darkTheme, equals(testConfig.darkTheme));
    });

    test('AdaptiveThemeConfig should support equality', () {
      final config1 = AdaptiveThemeConfig(
        mode: AdaptiveThemeMode.light,
        lightTheme: lightTheme,
        darkTheme: darkTheme,
      );

      final config2 = AdaptiveThemeConfig(
        mode: AdaptiveThemeMode.light,
        lightTheme: lightTheme,
        darkTheme: darkTheme,
      );

      expect(config1, equals(config2));
    });

    test('TimeBasedThemeSettings should support equality', () {
      final settings1 = TimeBasedThemeSettings(
        darkThemeStartHour: 18,
        lightThemeStartHour: 6,
      );

      final settings2 = TimeBasedThemeSettings(
        darkThemeStartHour: 18,
        lightThemeStartHour: 6,
      );

      expect(settings1, equals(settings2));
    });
  });

  group('AdaptiveTheme Integration Tests', () {
    testWidgets('Provider should be available in widget tree', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        AdaptiveThemeApp(
          config: AdaptiveThemeConfig(
            mode: AdaptiveThemeMode.light,
            lightTheme: ThemeData(brightness: Brightness.light),
            darkTheme: ThemeData(brightness: Brightness.dark),
            savePreferences: false,
          ),
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  context.adaptiveTheme.setMode(AdaptiveThemeMode.dark);
                },
                child: Text('Toggle'),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Toggle'), findsOneWidget);
    });
  });
}
