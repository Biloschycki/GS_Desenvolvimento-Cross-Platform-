// lib/theme.dart
import 'package:flutter/material.dart';
import 'models/event_model.dart';

class AppTheme {
  // ── Cores base ──────────────────────────────────────
  static const Color bg          = Color(0xFF050D1A);
  static const Color navy        = Color(0xFF0A1628);
  static const Color surface     = Color(0xFF0D1F35);
  static const Color surface2    = Color(0xFF122540);
  static const Color border      = Color(0xFF1A3050);
  static const Color cyan        = Color(0xFF00D4FF);
  static const Color green       = Color(0xFF00FF9C);
  static const Color orange      = Color(0xFFFF8C00);
  static const Color red         = Color(0xFFFF3B5C);
  static const Color yellow      = Color(0xFFFFD600);
  static const Color textPrimary = Color(0xFFE0EEFF);
  static const Color muted       = Color(0xFF4A6080);

  // ── ThemeData ────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: cyan,
      secondary: green,
      surface: surface,
      error: red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'monospace',
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
        color: textPrimary,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    // CardTheme (não CardThemeData) — compatível com Flutter 3.x
    // cardTheme: CardTheme(
    //   color: surface,
    //   elevation: 0,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(Radius.circular(14)),
    //     side: BorderSide(color: border),
    //   ),
    // ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bg,
      selectedItemColor: cyan,
      unselectedItemColor: muted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: cyan, width: 1.5),
      ),
      hintStyle: const TextStyle(color: muted, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12),
    ),
    dividerColor: border,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          color: textPrimary, fontWeight: FontWeight.w800),
      titleLarge: TextStyle(
          color: textPrimary, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(
          color: textPrimary, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: muted, fontSize: 13, height: 1.6),
      bodySmall: TextStyle(color: muted, fontSize: 11),
      labelSmall: TextStyle(
        color: muted,
        fontSize: 9,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  // ── Helpers ──────────────────────────────────────────
  static Color getSeverityColor(EventSeverity s) => switch (s) {
    EventSeverity.critica => red,
    EventSeverity.alta    => orange,
    EventSeverity.media   => yellow,
    EventSeverity.baixa   => green,
  };

  static Color getEventTypeColor(EventType t) => switch (t) {
    EventType.queimada     => orange,
    EventType.enchente     => cyan,
    EventType.desmatamento => green,
    EventType.tempestade   => yellow,
    EventType.nivelMar     => const Color(0xFF7C6FFF),
  };

  static String getEventTypeIcon(EventType t) => switch (t) {
    EventType.queimada     => '🔥',
    EventType.enchente     => '🌊',
    EventType.desmatamento => '🌲',
    EventType.tempestade   => '⛈️',
    EventType.nivelMar     => '🌍',
  };

  static String getSeverityLabel(EventSeverity s) => switch (s) {
    EventSeverity.critica => 'CRÍTICA',
    EventSeverity.alta    => 'ALTA',
    EventSeverity.media   => 'MÉDIA',
    EventSeverity.baixa   => 'BAIXA',
  };

  static String getEventTypeLabel(EventType t) => switch (t) {
    EventType.queimada     => 'Queimada',
    EventType.enchente     => 'Enchente',
    EventType.desmatamento => 'Desmatamento',
    EventType.tempestade   => 'Tempestade',
    EventType.nivelMar     => 'Nível do Mar',
  };

  // ── Helper para opacity compatível com todas as versões ──
  // Evita o deprecated Color.withOpacity nos widgets
  static Color alpha(Color c, double opacity) =>
      c.withValues(alpha: opacity);
}
