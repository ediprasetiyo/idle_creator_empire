import 'package:flutter/material.dart';

ThemeData buildDarkTheme(Color seedColor) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(0xFF0E0E12),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0E0E12),
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1A24),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1A1A24),
      indicatorColor: seedColor.withAlpha(50),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}
