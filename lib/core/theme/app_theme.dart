import 'package:flutter/material.dart';
import 'app_colors.dart';

class RecitationColors extends ThemeExtension<RecitationColors> {
  final Color confirmed;
  final Color cursor;
  final Color mistake;
  final Color pending;

  const RecitationColors({
    required this.confirmed,
    required this.cursor,
    required this.mistake,
    required this.pending,
  });

  @override
  RecitationColors copyWith({
    Color? confirmed,
    Color? cursor,
    Color? mistake,
    Color? pending,
  }) {
    return RecitationColors(
      confirmed: confirmed ?? this.confirmed,
      cursor: cursor ?? this.cursor,
      mistake: mistake ?? this.mistake,
      pending: pending ?? this.pending,
    );
  }

  @override
  RecitationColors lerp(covariant ThemeExtension<RecitationColors>? other, double t) {
    if (other is! RecitationColors) return this;
    return RecitationColors(
      confirmed: Color.lerp(confirmed, other.confirmed, t)!,
      cursor: Color.lerp(cursor, other.cursor, t)!,
      mistake: Color.lerp(mistake, other.mistake, t)!,
      pending: Color.lerp(pending, other.pending, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.lightPrimary,
          onPrimary: AppColors.lightOnPrimary,
          primaryContainer: AppColors.lightPrimaryContainer,
          onPrimaryContainer: AppColors.lightOnPrimaryContainer,
          secondary: AppColors.lightSecondary,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightOnSurface,
          error: AppColors.lightError,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
        ),
        extensions: const [
          RecitationColors(
            confirmed: AppColors.confirmedLight,
            cursor: AppColors.cursorLight,
            mistake: AppColors.mistakeLight,
            pending: AppColors.pendingLight,
          ),
        ],
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkOnPrimary,
          primaryContainer: AppColors.darkPrimaryContainer,
          onPrimaryContainer: AppColors.darkOnPrimaryContainer,
          secondary: AppColors.darkSecondary,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkOnSurface,
          error: AppColors.darkError,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkPrimaryContainer,
          foregroundColor: AppColors.darkOnPrimaryContainer,
        ),
        extensions: const [
          RecitationColors(
            confirmed: AppColors.confirmedDark,
            cursor: AppColors.cursorDark,
            mistake: AppColors.mistakeDark,
            pending: AppColors.pendingDark,
          ),
        ],
      );
}
