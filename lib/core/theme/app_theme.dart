// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class ContextTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ContextColors.background,
    primaryColor: ContextColors.accent,
    fontFamily: ContextTypography.fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: ContextColors.background,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: ContextTypography.h4.copyWith(
        color: ContextColors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: const IconThemeData(color: ContextColors.textPrimary),
      // The 'bottom' property was removed as it's not a valid AppBarTheme parameter.
      // The border is now applied directly on the AppBar widgets where needed.
    ),
    textTheme: TextTheme(
      displayLarge: ContextTypography.h1,
      displayMedium: ContextTypography.h2,
      displaySmall: ContextTypography.h3,
      headlineMedium: ContextTypography.h4,
      titleLarge: ContextTypography.bodyLg,
      bodyLarge: ContextTypography.bodyMd,
      bodyMedium: ContextTypography.bodySm,
      labelLarge: ContextTypography.bodyMd.copyWith(
        fontWeight: FontWeight.w800,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ContextColors.background,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 18.0,
      ),
      hintStyle: ContextTypography.bodyMd.copyWith(
        color: ContextColors.textSecondary,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: ContextColors.border, width: 2.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: ContextColors.border, width: 2.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: ContextColors.accent, width: 2.0),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ContextColors.background,
      selectedItemColor: ContextColors.textPrimary,
      unselectedItemColor: ContextColors.textSecondary,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: ContextColors.border,
      thickness: 2.0,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor:
          ContextColors.accent.withAlpha(38), // Corrected deprecated member
      labelStyle: ContextTypography.bodySm.copyWith(
        color: ContextColors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide.none,
      ),
    ),
    cardTheme: const CardThemeData(
      // Corrected class name
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
    ),
    tabBarTheme: TabBarThemeData(
      // Corrected class name
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: ContextColors.textPrimary,
          width: 3.0,
        ),
      ),
      labelColor: ContextColors.textPrimary,
      unselectedLabelColor: ContextColors.textSecondary,
      labelStyle:
          ContextTypography.bodySm.copyWith(fontWeight: FontWeight.w800),
      unselectedLabelStyle:
          ContextTypography.bodySm.copyWith(fontWeight: FontWeight.w800),
    ),
  );
}
