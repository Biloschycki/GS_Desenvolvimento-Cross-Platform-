// lib/main.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'data/app_state.dart';
import 'screens/splash_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const OrbitWatchApp());
}

// ── StatefulWidget para manter AppState vivo durante hot-reload ──
class OrbitWatchApp extends StatefulWidget {
  const OrbitWatchApp({super.key});

  @override
  State<OrbitWatchApp> createState() => _OrbitWatchAppState();
}

class _OrbitWatchAppState extends State<OrbitWatchApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: _appState,
      child: AnimatedBuilder(
        animation: _appState,
        builder: (_, __) => MaterialApp(
          title: 'OrbitWatch',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          scrollBehavior: _UniversalScrollBehavior(),
          initialRoute: '/',
          routes: {
            '/':      (_) => const SplashScreen(),
            '/intro': (_) => const IntroScreen(),
            '/home':  (_) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}

// ── InheritedWidget para distribuir AppState pela árvore ────────
class AppStateProvider extends InheritedWidget {
  final AppState state;

  const AppStateProvider({
    super.key,
    required this.state,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final p = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(p != null, 'AppStateProvider não encontrado na árvore de widgets');
    return p!.state;
  }

  @override
  bool updateShouldNotify(AppStateProvider old) => old.state != state;
}

// ── Permite scroll com mouse no browser/desktop ──────────────────
class _UniversalScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
