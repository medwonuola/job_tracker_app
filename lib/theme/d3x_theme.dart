import 'package:flutter/material.dart';
import 'd3x_colors.dart';
import 'd3x_typography.dart';

class D3XTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: D3XColors.backgroundDark,
    primaryColor: D3XColors.brandPrimary,
    fontFamily: D3XTypography.bodyFontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: D3XColors.backgroundDark,
      elevation: 0,
      titleTextStyle: D3XTypography.bodyLg
          .copyWith(fontWeight: FontWeight.w600, color: D3XColors.textPrimary),
      iconTheme: const IconThemeData(color: D3XColors.textPrimary),
    ),
    textTheme: TextTheme(
      headlineLarge: D3XTypography.headingH2,
      headlineMedium: D3XTypography.headingH3,
      bodyLarge: D3XTypography.bodyLg,
      bodyMedium: D3XTypography.bodyMd,
      bodySmall: D3XTypography.bodySm,
      labelLarge: D3XTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: D3XColors.backgroundMedium,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: D3XColors.backgroundLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: D3XColors.backgroundLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: D3XColors.brandSecondary, width: 2),
      ),
      hintStyle:
          D3XTypography.bodyMd.copyWith(color: D3XColors.textMutedInverse),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: D3XColors.backgroundMedium,
      selectedItemColor: D3XColors.brandSecondary,
      unselectedItemColor: D3XColors.textMuted,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: D3XColors.brandAccent,
      labelStyle: D3XTypography.bodySm.copyWith(color: D3XColors.textPrimary),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
    ),
  );
}
