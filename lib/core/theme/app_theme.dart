import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,

      // Esquema de colores
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.surface,
        onSurface: AppColors.neutral,
      ),

      // Tipografías Globales
      textTheme: const TextTheme(
        // Headline -> Quicksand
        headlineLarge: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.neutral,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.neutral,
        ),

        // Body -> Nunito
        bodyLarge: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.neutral,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.neutral,
        ),

        // Label -> Nunito
        labelLarge: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral,
        ),
      ),
    );
  }
}
