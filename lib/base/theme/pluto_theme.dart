import 'package:flutter/material.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';

class PlutoTheme {
  static ThemeData materialTheme = ThemeData(
    useMaterial3: false,
    primaryColor: PlutoColors.primaryColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: PlutoColors.backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: PlutoColors.backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: PlutoColors.primaryColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: PlutoColors.backgroundColor,
      selectedItemColor: PlutoColors.primaryColor,
      selectedIconTheme: const IconThemeData(size: 24),
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      unselectedIconTheme: const IconThemeData(size: 24),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: PlutoColors.primaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: PlutoColors.primaryColor,
      backgroundColor: PlutoColors.secondaryColor,
      elevation: 0,
      highlightElevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        color: Colors.black,
      ),
    ),
  );
}
