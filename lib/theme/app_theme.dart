import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _lightSeedColor = Color(0xFF654FE3);
  static const Color _darkSeedColor = Color(0xFF654FE3);
  //TODO will prob want focus and rest themes

  //TODO I think I'm just gonna have to manually make my own palettes
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
      seedColor: _darkSeedColor,
      brightness: Brightness.dark
  );

  static const double _commonBorderRadius = 3.0;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'StackSans',
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.surface,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_commonBorderRadius),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_commonBorderRadius),
        ),
        backgroundColor: _darkSeedColor,
        foregroundColor: Colors.white
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_commonBorderRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_commonBorderRadius),
        ),
      ),
    ),
  );
}