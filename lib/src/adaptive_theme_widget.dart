import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'adaptive_theme_provider.dart';
import 'theme_config.dart';

/// Widget that provides adaptive theme functionality to the widget tree
class AdaptiveThemeWidget extends StatefulWidget {
  /// The configuration for the adaptive theme
  final AdaptiveThemeConfig config;

  /// The child widget tree
  final Widget child;

  /// Whether to show debug information
  final bool debug;

  const AdaptiveThemeWidget({
    super.key,
    required this.config,
    required this.child,
    this.debug = false,
  });

  @override
  State<AdaptiveThemeWidget> createState() => _AdaptiveThemeWidgetState();
}

class _AdaptiveThemeWidgetState extends State<AdaptiveThemeWidget>
    with TickerProviderStateMixin {
  late AdaptiveThemeProvider _provider;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _provider = AdaptiveThemeProvider();

    // Set up animation controller for smooth transitions
    _animationController = AnimationController(
      duration: widget.config.transitionDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.config.transitionCurve,
    );

    // Initialize the provider
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    await _provider.initialize(widget.config);

    // Listen to theme changes and animate transitions
    _provider.addListener(() {
      if (mounted) {
        _animationController.forward(from: 0.0);
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<AdaptiveThemeProvider>(
        builder: (context, provider, child) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return MaterialApp(
                theme: provider.theme,
                debugShowCheckedModeBanner: widget.debug,
                home: widget.child,
                builder: (context, child) {
                  return _buildWithTransition(child!);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWithTransition(Widget child) {
    if (!_provider.isInitialized) {
      return MaterialApp(
        theme: widget.config.lightTheme,
        home: child,
      );
    }

    return AnimatedTheme(
      duration: widget.config.transitionDuration,
      curve: widget.config.transitionCurve,
      data: _provider.theme,
      child: child,
    );
  }
}

/// Widget that provides a simple way to wrap your app with adaptive theme
class AdaptiveThemeApp extends StatelessWidget {
  /// The configuration for the adaptive theme
  final AdaptiveThemeConfig config;

  /// The home widget of your app
  final Widget home;

  /// Additional routes for your app
  final Map<String, WidgetBuilder>? routes;

  /// Initial route for your app
  final String? initialRoute;

  /// Whether to show debug information
  final bool debug;

  const AdaptiveThemeApp({
    super.key,
    required this.config,
    required this.home,
    this.routes,
    this.initialRoute,
    this.debug = false,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveThemeWidget(
      config: config,
      debug: debug,
      child: _AppContent(
        home: home,
        routes: routes,
        initialRoute: initialRoute,
      ),
    );
  }
}

class _AppContent extends StatelessWidget {
  final Widget home;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;

  const _AppContent({
    required this.home,
    this.routes,
    this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: home,
    );
  }
}

/// Widget that provides theme-aware content with smooth transitions
class AdaptiveThemeContent extends StatelessWidget {
  /// The content to display
  final Widget child;

  /// Whether to show a loading indicator while theme is initializing
  final bool showLoadingIndicator;

  /// Custom loading widget
  final Widget? loadingWidget;

  const AdaptiveThemeContent({
    super.key,
    required this.child,
    this.showLoadingIndicator = true,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AdaptiveThemeProvider>(
      builder: (context, provider, child) {
        if (!provider.isInitialized && showLoadingIndicator) {
          return loadingWidget ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }

        return AnimatedTheme(
          duration: provider.config?.transitionDuration ??
              Duration(milliseconds: 300),
          curve: provider.config?.transitionCurve ?? Curves.easeInOut,
          data: provider.theme,
          child: this.child,
        );
      },
    );
  }
}
